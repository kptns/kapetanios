# Phython tools
import time
from typing import Any

# Modules
from monitor.k8s import KubeClient
from ml_model.client import Predictor
from monitor.prometheus import PrometheusClient
from logs.main import LogManager
from control.main import ReplicaManager

# Settings, values
from settings.vault import AGENT_TIME_INTERVAL


class Agent:
    def __init__(
        self,
        queues,
        prometheus=PrometheusClient(),
        logger=LogManager(name="kapetanios-agent"),
        predictor=Predictor()
    ):
        # Queues
        self.queues = queues
        self.agent_queue = queues[0]
        self.config_queue = queues[1]

        # Config metadata
        self.config = None
        
        # Modules
        self.prometheus = prometheus
        self.predictor = predictor
        
        # Logs
        self.logger = logger.init()

        try:
            self.kube_client = KubeClient()
        except Exception as e:
            self.logger.error("[AGENT] Failed to initialize the Kube Client: ", e)
        
        # Flags
        self.running = True
        
    def start(self):
        """
        Starts the agent pipeline
        """
        while self.running:
            self._pipeline()
            self.logger.info(f"[AGENT] Main runtime: {AGENT_TIME_INTERVAL} seconds of each cycle")
            time.sleep(AGENT_TIME_INTERVAL)

    def stop(self):
        """
        Stops the agent pipeline
        """
        self.running = False

    def _pipeline(self):
        """Main pipeline for the agent's scaling logic"""
        try:
            # Get latest config if available
            self._update_config()

            # Get current cluster state
            cluster_state = self._get_cluster_state()

            # Get predictions
            predictions = self._get_predictions()

            # Calculate new replica count
            new_replica_count = self._calculate_replicas(
                cluster_state=cluster_state,
                predictions=predictions
            )
            
            # Apply changes if needed
            self._apply_scaling(
                current_replicas=cluster_state['current_replicas'],
                new_replicas=new_replica_count
            )

            self._log_pipeline_state(cluster_state, predictions, new_replica_count)

        except Exception as e:
            self.logger.error("[AGENT] Error found in the Agent runtime: %s", str(e))

    def _update_config(self):
        """Updates configuration if new config is available"""
        if self.config is None:
            while self.config is None:
                self.logger.info("[AGENT] Getting lastest configuration at startup.")
                if not self.config_queue.empty():
                    self.config = self.config_queue.get()
                    self.logger.info("[AGENT] Lastest configuration set.")
                time.sleep(1)
    
        else:
            if not self.config_queue.empty():
                self.config = self.config_queue.get()
                self.logger.info("[AGENT] Lastest configuration set.")

    def _get_cluster_state(self):
        """Retrieves current state from the cluster"""
        deployment = self.config.deployments[0]

        try:
            state = {
                'cpu_requests_limit': self.kube_client.get_deployment_cpu_requests(
                    name=deployment.name,
                    namespace=deployment.namespace
                ),
                'memory_requests_limit': self.kube_client.get_deployment_memory_requests(
                    name=deployment.name,
                    namespace=deployment.namespace
                ),
                'current_replicas': self.kube_client.get_deployment_replicas(
                    name=deployment.name,
                    namespace=deployment.namespace
                )
            }
            return state

        except Exception as e:
            self.logger.error("[AGENT] An error occured trying to get the cluster state: ", e)

    def _get_predictions(self):
        """Gets predictions from the ML model"""
        usage_metrics = self.prometheus.get_usage_package()
        return self.predictor.get_predictions(data=usage_metrics)

    def _calculate_replicas(self, cluster_state, predictions):
        """Calculates the new replica count based on predictions"""
        deployment = self.config.deployments[0]
    
        replicas_from_cpu = ReplicaManager.replicas_from_cpu_usage(
            current_replicas=cluster_state['current_replicas'],
            predicted_value=predictions["predictions"]["cpu_usage_total"],
            cpu_requests_limit=cluster_state['cpu_requests_limit'],
            threshold=0.85,
            max_replica=deployment.max_replicas,
            min_replica=deployment.min_replicas
        )
        
        replicas_from_memory = ReplicaManager.replicas_from_memory_usage(
            current_replicas=cluster_state['current_replicas'],
            predicted_value=predictions["predictions"]["memory_usage"],
            memory_requests_limit=cluster_state['memory_requests_limit'],
            threshold=0.85,
            max_replica=deployment.max_replicas,
            min_replica=deployment.min_replicas
        )
        
        return ReplicaManager.get_new_replicas_count(
            replicas_from_cpu=replicas_from_cpu,
            replicas_from_memory=replicas_from_memory
        )

    def _apply_scaling(self, current_replicas, new_replicas):
        """Applies the scaling changes if needed"""
        if new_replicas != current_replicas:
            deployment = self.config.deployments[0]
            self.kube_client.set_deployment_replicas(
                name=deployment.name,
                namespace=deployment.namespace,
                replicas=new_replicas
            )

    def _log_pipeline_state(self, cluster_state, predictions, new_replicas):
        """Logs the current state and decisions of the pipeline"""
        # Put deployment into a variable
        deployment = self.config.deployments[0]

        self.logger.info("[AGENT] Config received: %s", self.config.timestamp)
        self.logger.info("[AGENT] Polling interval: %d", self.config.polling_interval)
        self.logger.info("[AGENT] Deployment name: %s", deployment.name)
        self.logger.info("[AGENT] Deployment namespace: %s", deployment.namespace)
        self.logger.info("[AGENT] CPU usage threshold: %.2f", deployment.cpu_usage_threshold)
        self.logger.info("[AGENT] Memory usage threshold: %.2f", deployment.memory_usage_threshold)
        self.logger.info("[AGENT] HPA enabled: %s", deployment.hpa_enabled)
        self.logger.info("[AGENT] HPA name: %s", deployment.hpa_name)
        self.logger.info("[AGENT] Target spec name: %s", deployment.target_spec_name)
        self.logger.info("[AGENT] Max. replicas in config: %d", deployment.max_replicas)
        self.logger.info("[AGENT] Min. replicas in config: %d", deployment.min_replicas)
        self.logger.info("[AGENT] CPU (nanoseconds) requests limit: %d", cluster_state['cpu_requests_limit'])
        self.logger.info("[AGENT] Memory (Bytes) requests limit: %f", cluster_state['memory_requests_limit'])
        self.logger.info("[AGENT] Current replicas: %d", cluster_state['current_replicas'])
        self.logger.info(f"[AGENT] Current predictions <cpu, memory>: {predictions["predictions"]["cpu_usage_total"]}, {predictions["predictions"]["memory_usage"]}")
        self.logger.info("[AGENT] Replicas to be selected: %d", new_replicas)     
