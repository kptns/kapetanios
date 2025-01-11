from config.manager import ConfigManager
import threading
import time
from settings.settings import AGENT_TIME_INTERVAL

class Agent:
    def __init__(self, queues):
        self.queues = queues
        self.agent_queue = queues[0]
        self.config_queue = queues[1]
        self.running = True

    def start(self):
        while self.running:
            while not self.config_queue.empty():
                # Recibir configuración del ConfigManager
                config = self.config_queue.get()
                
                print("[AGENT] Config received: ", config.timestamp)
                print("[AGENT] Polling interval: ", config.polling_interval)
                print("[AGENT] A Deployment sample: ", config.deployments[0].name)

            print("[AGENT] This is the Agent running each ", AGENT_TIME_INTERVAL, " seconds.")
            
            time.sleep(AGENT_TIME_INTERVAL)
    
    def stop(self):
        self.running = False
