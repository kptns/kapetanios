from kubernetes import client
from kubernetes import config
from pprint import pprint
from datetime import datetime


class KubeClientError(Exception):
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)


class Deployment:
    def __init__(self, name: str, min_replicas: int, max_replicas: int, hpa_enabled: bool, hpa_name: str, target_spec_name: str):
        pass


class KubeClientAuth:
    def __init__(self):
        self.api_client = None

    def __is_kube_config_loaded(self):
        """
        Loads the kube config from the default location.
        
        Returns:
            True if the config is loaded successfully, False otherwise.
        """
        try:
            config.load_kube_config()
            return True

        except Exception as e:
            raise KubeClientError(f"Error loading kube config: {e}")

    def create_client(self):
        """
        Creates a client for the kube API.
    
        Returns:
            The client for the kube API.
        """
        try:
            if self.__is_kube_config_loaded():
                client_base = client.ApiClient()
                self.api_client = client.CustomObjectsApi(client_base)
                return self.api_client
            else:
                raise KubeClientError("Kube config not loaded")

        except Exception as e:
            raise KubeClientError(f"Error creating kube client: {e}")


class KubeClient:
    def __init__(
        self,
        kube_client_auth = KubeClientAuth(),
    ):
        self.kube_client_auth = kube_client_auth
        self.kube_client = None
        self.running = True
        
    def get_deployment_cpu_usage(self, deployment_name: str):
        
        
        
    def start(self):
        """
        Starts the kube client.
        """
        try:
            if self.kube_client is None:
                self.kube_client = self.kube_client_auth.create_client()
                
            while self.running:
                pass

        except Exception as e:
            raise KubeClientError(f"Error starting kube client: {e}")

    def stop(self):
        """
        Stops the kube client.
        """
        self.running = False

