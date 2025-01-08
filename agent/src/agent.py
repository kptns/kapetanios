from src.config.manager import ConfigManager
import threading


class Agent:
    def __init__(self, config_manager, input_queue):
        self.input_queue = input_queue
        
    def run(self):
        while True:
            # Recibir configuración del ConfigManager
            config = self.input_queue.get()  # Este método bloquea hasta que haya datos
            # Procesar la nueva configuración
            self.process_config(config)
