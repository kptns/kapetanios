from typing import Dict, List, Protocol
from settings.settings import get_full_api_url
from settings.settings import KPTNS_API_KEY
from settings.settings import INITIAL_POLLING_INTERVAL
import datetime
import uuid
import json
import requests
import time
import logging

# Create log filenames with timestamp
timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
log_info_file = f"config_info_{timestamp}.log"
log_error_file = f"config_error_{timestamp}.log"


class ConfigError(Exception):
    """
    Exception raised for errors in the config manager.
    Attributes:
        message -- explanation of the error
    """
    pass


class ConfigFetcher(Protocol):
    def fetch_config(self, params: Dict) -> Dict:
        pass


class HTTPConfigFetcher(ConfigFetcher):
    """
    Concrete implementation of ConfigFetcher that performs HTTP requests
    to obtain configuration data.
    """
    def fetch_config(self, params: Dict = {"key": "value"}) -> Dict:
        """
        Fetches configuration through an HTTP request.

        Args:
            auth_token (str): Authentication token for the API
            params (Dict): Request parameters
            
        Returns:
            Dict: Configuration data obtained from the server
            
        Raises:
            ConfigError: If there is an error fetching the configuration
        """
        try:
            headers = {
                "Authorization": f"Bearer {KPTNS_API_KEY}",
                "Content-Type": "application/json"
            }
            
            response = requests.get(
                get_full_api_url("config"),
                headers=headers,
                params=params
            )
            
            if response.status_code != 200:
                raise ConfigError(f"Server returned status code {response.status_code}")

            return response.json()
            
        except requests.exceptions.RequestException as e:
            raise ConfigError(f"HTTP request failed: {str(e)}")
        except json.JSONDecodeError as e:
            raise ConfigError(f"Failed to parse server response: {str(e)}")


class Deployment:
    def __init__(
        self, 
        name: str, 
        model: str, 
        status: bool, 
        min_replicas: int, 
        max_replicas: int, 
        hpa_enabled: bool,
        hpa_name: str,
        target_spec_name: str
    ):
        self.name = name
        self.model = model
        self.status = status
        self.min_replicas = min_replicas
        self.max_replicas = max_replicas
        self.hpa_enabled = hpa_enabled
        self.hpa_name = hpa_name
        self.target_spec_name = target_spec_name


class ConfigData:
    """
    Represents the configuration data from the server.
    """
    def __init__(
        self,
        timestamp: str = None,
        polling_interval: int = None,
        deployments: List[Deployment] = list()
    ):
        self.timestamp: str = timestamp
        self.polling_interval: int = polling_interval
        self.deployments: List[Deployment] = deployments


class ConfigDeserializer:
    @staticmethod
    def deserialize_metadata(config: Dict) -> ConfigData:
        """
        Deserializes the metadata from the config json
        
        Args:
            config (Dict): The config json
            
        Returns:
            ConfigData: The deserialized config data
            
        Raises:
            ConfigError: If there is an error deserializing the config data
        """
        try:
            if not isinstance(config, dict):
                raise ConfigError("Config is not a dict. It should be a dict of a config.")
            
            if not isinstance(config["deployments"], list):
                raise ConfigError("Deployments is not a list. It should be a list of deployments.")

            if not isinstance(int(config["polling_interval"]), int):
                raise ConfigError("Polling interval is not an int. It should be an int.")

            if not isinstance(config["timestamp"], str):
                raise ConfigError("Timestamp is not a str. It should be a str.")

            return ConfigData(
                timestamp=config["timestamp"],
                polling_interval=int(config["polling_interval"]),
                deployments=[
                    ConfigDeserializer.deserialize_deployments(deployment)
                    for deployment in config["deployments"]
                ]
            )

        except Exception as e:
            raise ConfigError(f"Failed to deserialize metadata: {e}")

    @staticmethod
    def deserialize_deployments(deployment: Dict) -> Deployment:
        """Deserializes a single deployment from the config json"""
        if not isinstance(deployment, dict):
            raise ConfigError("Deployment is not a dict. It should be a dict of a deployment.")

        return Deployment(
            name=deployment["name"],
            model=deployment["model"],
            status=deployment["status"]["enabled"],
            min_replicas=deployment["status"]["min_replicas"],
            max_replicas=deployment["status"]["max_replicas"],
            hpa_enabled=deployment["status"]["hpa"]["available"],
            hpa_name=deployment["status"]["hpa"]["hpa_name"],
            target_spec_name=deployment["status"]["hpa"]["target_spec_name"]
        )


class ConfigManager:
    """
    Manages configuration data retrieval and processing from the server.
    
    Attributes:
        config_queue (Dict[str, Any]): Configuration data retrieved from server into a queue
    """
    def __init__(
        self, 
        queue
    ):
        self.client = HTTPConfigFetcher()
        self.fetched_config = dict()
        self.logger = logging.getLogger(__name__)
        self.metadata = None
        self.queue = queue
        self.running = False

    def start(self):
        """Starts the main configuration manager cycle"""
        self.running = True
        while self.running:
            try:
                # Clear the queue
                while not self.queue.empty():
                    self.queue.get()

                # Run the pipeline
                self.__pipeline_run()

                print(
                    "[CONFIG] Metadata timestamp: ", self.metadata.timestamp,
                    "\n[CONFIG] Polling interval: ", self.metadata.polling_interval,
                    "\n[CONFIG] A Deployment sample: ", self.metadata.deployments[0].name
                )

                # Put the metadata into the queue
                self.queue.put(self.metadata)

            except Exception as e:
                self.logger.error(f"Error in configuration cycle: {e}")

            # Sleep for the polling interval
            if self.metadata is not None:
                time.sleep(self.metadata.polling_interval)
            else:
                time.sleep(INITIAL_POLLING_INTERVAL)

    def stop(self):
        """Safely stops the main cycle"""
        self.running = False
        
    def __pipeline_run(self):
        """Executes a complete configuration processing pipeline"""
        try:
            if self.__fetch_config():
                self.__set_metadata()
        except Exception as e:
            self.logger.error(f"Error in configuration cycle: {e}")
            raise ConfigError(f"Failed to process configuration cycle: {e}")

    def __set_metadata(self):
        """Unserializes the fetched configuration"""
        try:
            if not self.fetched_config:
                raise ConfigError("No configuration data to process")
                
            if not isinstance(self.fetched_config, dict):
                raise ConfigError(f"Expected dict, got {type(self.fetched_config)}")
                
            self.metadata = ConfigDeserializer.deserialize_metadata(config=self.fetched_config)
            
            # Validate critical fields
            if not self.metadata.deployments:
                self.logger.warning("No deployments found in configuration")
                
            if self.metadata.polling_interval < 10:
                self.logger.warning("Polling interval is very low (<10s)")

        except Exception as e:
            self.logger.error(f"Error unserializing fetched config of metadata: {e}")
            raise ConfigError(f"Failed to unserialize fetched config of metadata: {e}")
        
    def __fetch_config(self):
        """
        Gets the config data from the server.

        Returns:
            Dict: Configuration data from the server

        Raises:
            ConfigError: If there is an error fetching the configuration
        """
        max_retries = 3
        retry_delay = 5  # seconds
        
        for attempt in range(max_retries):
            try:
                self.logger.info(f"Fetching config data from server (attempt {attempt + 1}/{max_retries})")

                self.fetched_config = self.client.fetch_config()

                self.logger.info("Successfully fetched config data")

                return True

            except ConfigError as e:
                if attempt == max_retries - 1:
                    raise ConfigError(f"Failed to fetch config data after {max_retries} attempts: {e}")

                self.logger.warning(f"Attempt {attempt + 1} failed, retrying in {retry_delay}s: {e}")

                time.sleep(retry_delay)
