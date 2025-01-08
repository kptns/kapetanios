import logging
from typing import Optional

class LogManager:
    """
    A simple logging manager class to handle application logging.
    """
    _instance: Optional['LogManager'] = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(LogManager, cls).__new__(cls)
            cls._instance._initialize_logger()
        return cls._instance

    def _initialize_logger(self):
        """Initialize the logger with basic configuration"""
        self.logger = logging.getLogger('config_manager')
        self.logger.setLevel(logging.INFO)
        
        # Create console handler with formatting
        handler = logging.StreamHandler()
        formatter = logging.Formatter(
            '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
        handler.setFormatter(formatter)
        
        # Add handler to logger
        self.logger.addHandler(handler)

    def info(self, message: str):
        """Log info level message"""
        self.logger.info(message)

    def error(self, message: str):
        """Log error level message"""
        self.logger.error(message)

    def debug(self, message: str):
        """Log debug level message"""
        self.logger.debug(message)

    def warning(self, message: str):
        """Log warning level message"""
        self.logger.warning(message)
