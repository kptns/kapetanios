# Python tools
from typing import Dict, Optional
import datetime
import time

# 3rd party
import requests

# Settings
from settings.vault import KAPETANIOS_SERVER_URL
from settings.vault import KAPETANIOS_EVENTS_ENDPOINT


class Log:
    def __init__(
        self,
        timestamp: str,
        log_level: str,
        message: str,
        source: str
    ):
        self.timestamp = timestamp
        self.log_level = log_level
        self.message = message
        self.source = source
    
    def to_dict(self):
        return {
            "timestamp": self.timestamp,
            "log_level": self.log_level,
            "message": self.message,
            "source": self.source
        }


class LogValidator:
    """Class responsible for validating event logs"""

    VALID_LOG_LEVELS = ["INFO", "WARN", "DEBUG", "ERROR", "FATAL"]
    
    @classmethod
    def validate(cls, log: Log) -> tuple[bool, Optional[str]]:
        """
        Validates the structure and content of an event log
        
        Args:
            log: Log - The log obj to validate
            
        Returns:
            tuple[bool, Optional[str]] - (is_valid, error_message)
        """
        if not isinstance(log.timestamp, str):
            return False, f"Invalid 'timestamp' type in timestamp key; expected string, type given is {type(log.timestamp)}"

        # Validate log level
        if log.log_level not in cls.VALID_LOG_LEVELS:
            return False, f"Invalid log level. Must be one of: {cls.VALID_LOG_LEVELS}"
        
        if not isinstance(log.message, str):
            return False, f"Invalid message data type. Must to be a string. Given is <{type(log.message)}>."
        
        if not isinstance(log.source, str):
            return False, f"Invalid message data type. Must to be a string. Given is <{type(log.source)}>." 
        
        # All validations passed
        return True, None


class NotificationManagerError(Exception):
    """Custom exception class for NotificationManager errors"""
    def __init__(self, message: str):
        super().__init__(message)
        self.message = message


class NotificationManager:
    def __init__(self, source, log_validator=LogValidator()):
        # the source of the event <agent, configmanager, etc>
        self.source = source
        # external modules
        self.log_validator = log_validator

    def send_event(self, log_level: str = "INFO", message: str = "Empty message.") -> bool:
        """
        Sends an event log to the web app backend
        
        Args:
            log: dict. The event log with the next structure:
                {
                    "timestamp": <timestamp>,
                    "log_level": <string> ("INFO", "WARN", "DEBUG", "ERROR", "FATAL"),
                    "message": <string>,
                    "source": <string>,
                    "hostname": <string>
                }
        
        Returns:
            bool: True if the event was sent successfully, False otherwise
        """
        # build the log
        log = Log(
            timestamp=datetime.datetime.now().isoformat(),
            log_level=log_level.upper(),
            message=message,
            source=self.source
        )

        # Validate the log
        is_valid, error_message = LogValidator.validate(log)

        if not is_valid:
            raise ValueError(f"Invalid log format: {error_message}")

        try:
            response = requests.post(KAPETANIOS_SERVER_URL+KAPETANIOS_EVENTS_ENDPOINT, json=log.to_dict(), timeout=10)

            if response.status_code == 200:
                return True

            raise NotificationManagerError(f"Wrong status code returned: <{response.status_code}>")
        except Exception as e:
            raise ConnectionError(f"Failed to send event: {str(e)}")
