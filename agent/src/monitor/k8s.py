from kubernetes import client
from kubernetes import config
from pprint import pprint
from datetime import datetime
from models.kubernetes import Deployment


class KubeClientError(Exception):
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)


class KubeAuth:
    def __init__(self):
        self.api_client = None

    def __is_kube_config_loaded(self):
        """
        Loads the kube config from the default location.
        
        Returns:
            True if the config is loaded successfully, False otherwise.
        """
        try:
            config.load_incluster_config()
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
    def __init__(self, kube_client_auth=KubeAuth()):
        self.kube_client_auth = kube_client_auth
        self.kube_client = None
        self.apps_v1 = None

        try:
            if self.kube_client is None:
                self.kube_client = self.kube_client_auth.create_client()
            
            if self.apps_v1 is None:
                self.apps_v1 = client.AppsV1Api()
        except Exception as e:
            raise KubeClientError(f"Error creating kube client: {e}")


    def get_deployment_cpu_usage(self, deployment_name: str):
        pass

    def get_deployment_memory_usage(self, deployment_name: str):
        pass

    def get_deployment_replicas(self, name: str, namespace: str):
        """
        Get the number of replicas for a deployment

        Args:
            name (str): The name of the deployment
            namespace (str): The namespace of the deployment

        Returns:
            int: The number of replicas currently running for the deployment
        """
        try:
            # Get the deployment from the API
            apps_v1 = client.AppsV1Api()
            deployment = apps_v1.read_namespaced_deployment(name=name, namespace=namespace)

            # Return the number of available replicas (actually running)
            return deployment.status.available_replicas or 0
        except Exception as e:
            raise KubeClientError(f"Error getting deployment replicas: {e}")

    def get_deployment_cpu_requests(self, name: str, namespace: str):
        """
        Get the cpu requests for a deployment

        Args:
            name (str): The name of the deployment
            namespace (str): The namespace of the deployment

        Returns:
            float: The cpu requests for the deployment in nanoseconds
        
        Raises:
            KubeClientError: If the deployment is not found
        """
        try:
            deployment = self.apps_v1.read_namespaced_deployment(name=name, namespace=namespace)

            # Extract CPU requests from the deployment spec
            containers = deployment.spec.template.spec.containers
            total_cpu_request = 0.0
            
            for container in containers:
                if container.resources and container.resources.requests and 'cpu' in container.resources.requests:
                    # CPU requests can be in formats like "100m" (100 millicpu) or "0.1" (0.1 cpu)
                    cpu_request = container.resources.requests['cpu']
                    
                    # Convert to nanoseconds (1 CPU = 1,000,000,000 ns)
                    if cpu_request.endswith('m'):
                        # Convert millicpu to nanoseconds
                        # 100m = 0.1 CPU = 100,000,000 ns
                        total_cpu_request += float(cpu_request[:-1]) * 1000000.0
                    else:
                        # Convert CPU units to nanoseconds
                        # 1 CPU = 1,000,000,000 ns
                        total_cpu_request += float(cpu_request) * 1000000000.0
            
            return total_cpu_request
            
        except client.rest.ApiException as e:
            if e.status == 404:
                raise KubeClientError(f"Deployment '{name}' not found")
            else:
                raise KubeClientError(f"Error getting deployment cpu requests: {e}")
        except Exception as e:
            raise KubeClientError(f"Error getting deployment cpu requests: {e}")

    def get_deployment_memory_requests(self, name: str, namespace: str):
        """
        Get the memory requests for a deployment

        Args:
            name (str): The name of the deployment
            namespace (str): The namespace of the deployment

        Returns:
            float: The memory requests for the deployment in bytes (exact value)
        
        Raises:
            KubeClientError: If the deployment is not found
        """
        try:
            deployment = self.apps_v1.read_namespaced_deployment(name=name, namespace=namespace)

            # Extract memory requests from the deployment spec
            containers = deployment.spec.template.spec.containers
            total_memory_request = 0.0
            
            for container in containers:
                if container.resources and container.resources.requests and 'memory' in container.resources.requests:
                    memory_request = container.resources.requests['memory']

                    # Convert different memory formats to bytes using float for precision
                    if memory_request.endswith('Ki'):
                        total_memory_request += float(memory_request[:-2]) * 1024.0  # Ki to bytes
                    elif memory_request.endswith('Mi'):
                        total_memory_request += float(memory_request[:-2]) * 1024.0 * 1024.0  # Mi to bytes
                    elif memory_request.endswith('Gi'):
                        total_memory_request += float(memory_request[:-2]) * 1024.0 * 1024.0 * 1024.0  # Gi to bytes
                    elif memory_request.endswith('Ti'):
                        total_memory_request += float(memory_request[:-2]) * 1024.0 * 1024.0 * 1024.0 * 1024.0  # Ti to bytes
                    else:
                        # Already in bytes if no unit specified
                        total_memory_request += float(memory_request)

            return total_memory_request

        except client.rest.ApiException as e:
            if e.status == 404:
                raise KubeClientError(f"Deployment '{name}' not found")
            else:
                raise KubeClientError(f"Error getting deployment memory requests: {e}")
        except Exception as e:
            raise KubeClientError(f"Error getting deployment memory requests: {e}")

    def set_deployment_replicas(self, name: str, namespace: str, replicas: int):
        """
        Scale a deployment to the specified number of replicas

        Args:
            name (str): The name of the deployment
            namespace (str): The namespace of the deployment
            replicas (int): The desired number of replicas

        Raises:
            KubeClientError: If there's an error scaling the deployment
        """
        try:
            # Get the deployment
            deployment = self.apps_v1.read_namespaced_deployment(name=name, namespace=namespace)

            # Update the replicas
            deployment.spec.replicas = replicas
            
            # Apply the update
            self.apps_v1.patch_namespaced_deployment(
                name=name,
                namespace=namespace,
                body=deployment
            )
        except client.rest.ApiException as e:
            if e.status == 404:
                raise KubeClientError(f"Deployment '{name}' not found")
            else:
                raise KubeClientError(f"Error scaling deployment: {e}")
        except Exception as e:
            raise KubeClientError(f"Error scaling deployment: {e}")
