# Python tools
from typing import Dict, Optional
import datetime

# 3rd party
import requests

# Settings
from settings.vault import EVENT_NOTIFICATION_ENDPOINT


class LogValidator:
    """Class responsible for validating event logs"""
    
    REQUIRED_FIELDS = [
        ("timestamp", str),
        ("log_level", str),
        ("message", str),
        ("source", str),
        ("hostname", str)
    ]
    VALID_LOG_LEVELS = ["INFO", "WARN", "DEBUG", "ERROR", "FATAL"]
    
    @classmethod
    def validate(cls, log: Dict) -> tuple[bool, Optional[str]]:
        """
        Validates the structure and content of an event log
        
        Args:
            log: Dict - The log to validate
            
        Returns:
            tuple[bool, Optional[str]] - (is_valid, error_message)
        """
        if not isinstance(log, dict):
            return False, "Invalid log data type. Must be one dict."
        
        if not isinstance(log["timestamp"], str):
            return False, f"Invalid 'timestamp' type in timestamp key; expected string, type given is {type(log["timestamp"])}"

        # Check if all required fields are present
        for field in cls.REQUIRED_FIELDS:
            if field not in log:
                return False, f"Missing required field: {field}"
        
        # Validate log level
        if log["log_level"] not in cls.VALID_LOG_LEVELS:
            return False, f"Invalid log level. Must be one of: {cls.VALID_LOG_LEVELS}"
            
        # All validations passed
        return True, None


class NotificationManager:
    def __init__(self):
        self.validator = LogValidator()
    
    def send_event(self, log: Dict) -> bool:
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
        # Validate the log
        is_valid, error_message = LogValidator.validate(log)
        if not is_valid:
            raise ValueError(f"Invalid log format: {error_message}")
            
        try:
            response = requests.post(EVENT_NOTIFICATION_ENDPOINT, json=log)
            return response.status_code == 200
        except Exception as e:
            raise ConnectionError(f"Failed to send event: {str(e)}")