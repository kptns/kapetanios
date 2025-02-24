from config.manager import ConfigManager
import threading
import time
from settings.vault import AGENT_TIME_INTERVAL

class DataAnalyzer:
    @staticmethod
    def replicas_from_cpu_usage(
        self,
        current_replicas,
        predicted_values,
        CPU_REQUESTS_LIMIT,
        THRESHOLD,
        MAX_REPLICA,
        MIN_REPLICA
    ):
        current_replicas = MIN_REPLICA # query to kube_client
        max_predicted_value = max(predicted_values)

        if max_predicted_value >= (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) and current_replicas < MAX_REPLICA:
            current_replicas += 1
            # execute a scale up to the deployment
        
        elif current_replicas > MIN_REPLICA:
            lower_bound = (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) * (current_replicas - 1)

            if max_predicted_value < lower_bound:
                current_replicas -= 1
                # execute a scale down to the deployment

        return current_replicas
    
    @staticmethod
    def replicas_from_memory_usage(
        self,
        current_replicas,
        predicted_values,
        CPU_REQUESTS_LIMIT,
        THRESHOLD,
        MAX_REPLICA,
        MIN_REPLICA
    ):
        current_replicas = MIN_REPLICA # query to kube_client
        max_predicted_value = max(predicted_values)

        if max_predicted_value >= (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) and current_replicas < MAX_REPLICA:
            current_replicas += 1
            # execute a scale up to the deployment
        
        elif current_replicas > MIN_REPLICA:
            lower_bound = (CPU_REQUESTS_LIMIT * current_replicas * THRESHOLD) * (current_replicas - 1)

            if max_predicted_value < lower_bound:
                current_replicas -= 1
                # execute a scale down to the deployment

        return current_replicas
    
    @staticmethod
    def replicas_count(self, from_cpu, from_memory):
        return max(from_cpu, from_memory)


class Agent:
    def __init__(self, queues):
        self.queues = queues
        self.agent_queue = queues[0]
        self.config_queue = queues[1]
        self.kube_client_queue = queues[2]
        self.running = True

    def start(self):
        while self.running:
            while not self.config_queue.empty():
                # Recibir configuración del ConfigManager
                config = self.config_queue.get()

                print("[AGENT] Config received: ", config.timestamp)
                print("[AGENT] Polling interval: ", config.polling_interval)
                print("[AGENT] A Deployment sample: ", config.deployments[0].name)
                
                threshold = 0.85 # query to config
                cpu_requests_limit = 200 # query to kube_client
                min_replicas = 1 # query to config
                max_replicas = 10 # query to config
                predicted_values = ... # query to model
                current_replicas = 1 # query to kube_client
                
                replicas_from_cpu_usage = DataAnalyzer.replicas_from_cpu_usage(
                    current_replicas,
                    predicted_values,
                    cpu_requests_limit,
                    threshold,
                    max_replicas,
                    min_replicas
                )
                
                replicas_from_memory_usage = DataAnalyzer.replicas_from_memory_usage(
                    current_replicas,
                    predicted_values,
                    cpu_requests_limit,
                    threshold,
                    max_replicas,
                    min_replicas
                )
                
                current_replicas = DataAnalyzer.replicas_count(
                    from_cpu=replicas_from_cpu_usage,
                    from_memory=replicas_from_memory_usage
                )
                
                # execute the scale up or down to the deployment here
                # send to the kube_client the new number of replicas
                self.kube_client_queue.put(current_replicas)

            print("[AGENT] This is the Agent running each ", AGENT_TIME_INTERVAL, " seconds.")
            
            time.sleep(AGENT_TIME_INTERVAL)
    
    def stop(self):
        self.running = False
