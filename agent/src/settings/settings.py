import os
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Base directories
BASE_DIR = Path(__file__).resolve().parent.parent

# URLs and API
BASE_URL = os.getenv('BASE_URL', 'http://127.0.0.1:8000')
API_VERSION = 'v1'
API_TIMEOUT = int(os.getenv('API_TIMEOUT', 30))  # seconds

# Log configuration
LOG_DIR = os.getenv('LOG_DIR', 'logs')
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
LOG_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

# Authentication configuration
AUTH_TOKEN_EXPIRY = int(os.getenv('AUTH_TOKEN_EXPIRY', 3600))  # seconds
AUTH_REQUIRED = os.getenv('AUTH_REQUIRED', 'True').lower() == 'true'
KPTNS_API_KEY = os.getenv('KPTNS_API_KEY', None)

# Database configuration (if needed)
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = int(os.getenv('DB_PORT', 5432))
DB_NAME = os.getenv('DB_NAME', 'mydb')
DB_USER = os.getenv('DB_USER', 'user')
DB_PASSWORD = os.getenv('DB_PASSWORD', '')

# Cache configuration (if needed)
CACHE_ENABLED = os.getenv('CACHE_ENABLED', 'True').lower() == 'true'
CACHE_TIMEOUT = int(os.getenv('CACHE_TIMEOUT', 300))  # seconds

# Endpoint configuration
API_ENDPOINTS = {
    'config': f'/api/{API_VERSION}/config',
    'auth': f'/api/{API_VERSION}/auth',
    'health': f'/api/{API_VERSION}/health',
}

# Retry configuration
MAX_RETRIES = int(os.getenv('MAX_RETRIES', 3))
RETRY_DELAY = int(os.getenv('RETRY_DELAY', 1))  # seconds


# ConfigManager values
INITIAL_POLLING_INTERVAL = int(os.getenv('CONFIG_MANAGER_POLLING_INTERVAL', 10))  # seconds

# Agent values
AGENT_TIME_INTERVAL = int(os.getenv('AGENT_POLLING_INTERVAL', 5))  # seconds


def get_full_api_url(endpoint: str) -> str:
    """
    Builds the complete URL for a specific endpoint
    """
    return f"{BASE_URL.rstrip('/')}{API_ENDPOINTS[endpoint]}"
