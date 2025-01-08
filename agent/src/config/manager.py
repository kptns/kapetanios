from abc import ABC, abstractmethod
from typing import Dict, List, Any, Protocol
from src.log.manager import LogManager
from src.settings.settings import get_full_api_url
from src.settings.settings import KPTNS_API_KEY
from src.auth.manager import AuthManager
import datetime
import uuid
import json
import requests
import time

# Create log filenames with timestamp
timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
log_info_file = f"config_info_{timestamp}.log"
log_error_file = f"config_error_{timestamp}.log"

logger = LogManager()
logger.add_file_handler(log_info_file, level="INFO")
logger.add_file_handler(log_error_file, level="ERROR")

# Auth manager
auth_manager = AuthManager()


class ConfigError(Exception):
    """
    Exception raised for errors in the config manager.
    Attributes:
        message -- explanation of the error
    """
    pass


class ConfigFetcher(Protocol):
    def fetch_config(self, auth_token: str, params: Dict) -> Dict:
        pass


class LoggerInterface(Protocol):
    def info(self, message: str) -> None: pass
    def error(self, message: str) -> None: pass



class HTTPConfigFetcher(ConfigFetcher):
    """
    Concrete implementation of ConfigFetcher that performs HTTP requests
    to obtain configuration data.
    """
    def fetch(self, params: Dict) -> Dict:
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


class ConfigManager:
    """
    Manages configuration data retrieval and processing from the server.
    
    Attributes:
        config_queue (Dict[str, Any]): Configuration data retrieved from server into a queue
    """
    def __init__(self, config_queue):
        self.queue = config_queue
        self.running = False
        self.retry_interval = 60  # seconds between retries
        
    def start(self):
        """Starts the main configuration manager cycle"""
        self.running = True
        while self.running:
            try:
                self.__process_config_cycle()
            except Exception as e:
                self.logger.error(f"Error in configuration cycle: {e}")
                self.__handle_error(e)
 
    def stop(self):
        """Safely stops the main cycle"""
        self.running = False
        
    def __process_config_cycle(self):
        """Executes a complete configuration processing cycle"""
        config = self.get_new_config()
        self._validate_config(config)
        self._process_config(config)
        self.queue.put(config)
        
    def __validate_config(self, config):
        """Validates the structure and content of the configuration"""
        # ... validation logic
        pass
        
    def __process_config(self, config):
        """Processes the configuration before sending it"""
        # ... processing logic
        pass
        
    def __handle_error(self, error):
        """Handles errors and applies retry policy"""
        time.sleep(self.retry_interval)
        
    def __get_new_config(self):
        """
        Gets the config data from the server.

        Returns:
            Dict: Configuration data from the server

        Raises:
            ConfigError: If there is an error fetching the configuration
        """
        try:
            self.logger.info("Fetching config data from server")
            params = {
                "timestamp": datetime.datetime.now().isoformat(),
                "account_id": self.account_id,
            }

            config_data = self.config_fetcher.fetch(params=params)
            self.config_data = config_data

            self.logger.info("Successfully fetched config data")
            return config_data

        except Exception as e:
            self.logger.error(f"Exception while fetching config data: {e}")
            raise ConfigError(f"Failed to get config data: {e}")
