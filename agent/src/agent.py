from config.manager import ConfigManager
import threading
import time
from settings.vault import AGENT_TIME_INTERVAL
from cluster.client import KubeClient

class DataAnalyzer:
    @staticmethod
    def replicas_from_cpu_usage(
        self,
        current_replicas,
        predicted_value,
        CPU_REQUESTS_LIMIT,
        THRESHOLD,
        MAX_REPLICA,
        MIN_REPLICA
    ):
        current_replicas = MIN_REPLICA # query to kube_client

        if predicted_value >= (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) and current_replicas < MAX_REPLICA:
            current_replicas += 1
            # execute a scale up to the deployment
        
        elif current_replicas > MIN_REPLICA:
            lower_bound = (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) * (current_replicas - 1)

            if predicted_value < lower_bound:
                current_replicas -= 1
                # execute a scale down to the deployment

        return current_replicas

    @staticmethod
    def replicas_from_memory_usage(
        self,
        current_replicas,
        predicted_value,
        CPU_REQUESTS_LIMIT,
        THRESHOLD,
        MAX_REPLICA,
        MIN_REPLICA
    ):
        current_replicas = MIN_REPLICA # query to kube_client

        if predicted_value >= (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) and current_replicas < MAX_REPLICA:
            current_replicas += 1
            # execute a scale up to the deployment
        
        elif current_replicas > MIN_REPLICA:
            lower_bound = (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) * (current_replicas - 1)

            if predicted_value < lower_bound:
                current_replicas -= 1
                # execute a scale down to the deployment

        return current_replicas

    @staticmethod
    def get_new_replicas_count(self, replicas_from_cpu, replicas_from_memory):
        return max(replicas_from_cpu, replicas_from_memory)


class Agent:
    def __init__(self, queues):
        # Queues
        self.queues = queues
        self.agent_queue = queues[0]
        self.config_queue = queues[1]
        
        # Kube Client
        try:
            self.kube_client = KubeClient()
        except Exception as e:
            print("[AGENT] Failed to initialize the Kube Client: ", e)
        
        # Flags
        self.running = True

    def start(self):
        while self.running:
            while not self.config_queue.empty():
                # Recibir configuración del ConfigManager
                config = self.config_queue.get()

                print("[AGENT] Config received: ", config.timestamp)
                print("[AGENT] Polling interval: ", config.polling_interval)
                print("[AGENT] A Deployment sample: ", config.deployments[0].name)
                print("[AGENT] Deployment namespace: ", config.deployments[0].namespace)
                print("[AGENT] CPU usage threshold: ", config.deployments[0].cpu_usage_threshold)
                print("[AGENT] Memory usage threshold: ", config.deployments[0].memory_usage_threshold)
                print("[AGENT] HPA enabled: ", config.deployments[0].hpa_enabled)
                print("[AGENT] HPA name: ", config.deployments[0].hpa_name)
                print("[AGENT] Target spec name: ", config.deployments[0].target_spec_name)

                cpu_requests_limit = 200 # query to kube_client
                current_replicas = 1 # query to kube_client
                predicted_values = ... # query to model

                # Runtime
                try:
                    # Get the cpu requests of the deployment
                    cpu_requests_limit = self.kube_client.get_deployment_cpu_requests(
                        name=config.deployments[0].name,
                        namespace=config.deployments[0].namespace
                    )
                    
                    # Get the current number of replicas for the deployment
                    current_replicas = self.kube_client.get_deployment_replicas(
                        name=config.deployments[0].name,
                        namespace=config.deployments[0].namespace
                    )
                    
                    

                    print("[AGENT] CPU requests limit: ", cpu_requests_limit)
                    print("[AGENT] Current replicas: ", current_replicas)
                except Exception as e:
                    print("[AGENT] Error found in the Agent runtime: ", e)     

            print("[AGENT] Main runtime cycle of ", AGENT_TIME_INTERVAL, " seconds.")

            time.sleep(AGENT_TIME_INTERVAL)
    
    def stop(self):
        self.running = False
