# Python
import os
from pathlib import Path
import datetime


def read_configmap_value(key: str, default_value: str = None) -> str:
    """
    Reads a value from Kubernetes ConfigMap if available,
    otherwise falls back to environment variables or default value.
    """
    configmap_path = os.getenv('CONFIGMAP_PATH', '/etc/config')
    config_file = Path(configmap_path) / key
    
    if os.getenv('TEST_MODE'):
        print(f"\n[DEBUG] Reading configuration for: {key}")
        print(f"[DEBUG] Looking in: {config_file}")
    
    try:
        if config_file.exists():
            value = config_file.read_text().strip()
            if value:
                if os.getenv('TEST_MODE'):
                    print(f"[DEBUG] ✓ Found value: {value}")
                return value

        if os.getenv('TEST_MODE'):
            print(f"[DEBUG] ⚠ Using fallback: {default_value}")
        return os.getenv(key, default_value)
        
    except Exception as e:
        if os.getenv('TEST_MODE'):
            print(f"[DEBUG] ✗ Error: {e}")
        return os.getenv(key, default_value)


def get_full_api_url(endpoint: str) -> str:
    """
    Builds the complete URL for a specific endpoint
    """
    return f"{KAPETANIOS_SERVER_URL.rstrip('/')}{API_ENDPOINTS[endpoint]}"


# Base directories
BASE_DIR = Path(__file__).resolve().parent.parent

# URLs and API
KAPETANIOS_SERVER_URL = read_configmap_value('KAPETANIOS_SERVER_URL', 'https://kptnos.com')
API_VERSION = 'v1'
API_TIMEOUT = int(os.getenv('API_TIMEOUT', 30))  # seconds

# Endpoint configuration
API_ENDPOINTS = {
    'config': f'/agent/config',
    'event': '/agent/logs', # CHANGE ME <----- POST
    'auth': f'/api/{API_VERSION}/auth',
    'health': f'/api/{API_VERSION}/health',
}

# Events
KAPETANIOS_EVENTS_ENDPOINT = API_ENDPOINTS['event']
KAPETANIOS_CONFIG_ENDPOINT = API_ENDPOINTS['config']

# Log configuration
LOG_DIR = os.getenv('LOG_DIR', 'logs')
LOG_LEVEL = os.getenv('LOG_LEVEL', 'INFO')
LOG_FORMAT = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
LOG_DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

# Retry configuration
MAX_RETRIES = int(os.getenv('MAX_RETRIES', 3))
RETRY_DELAY = int(os.getenv('RETRY_DELAY', 1))  # seconds

# ConfigManager values
INITIAL_POLLING_INTERVAL = int(os.getenv('CONFIG_MANAGER_POLLING_INTERVAL', 10))  # seconds

# Agent values
AGENT_TIME_INTERVAL = int(os.getenv('AGENT_POLLING_INTERVAL', 5))  # seconds

# Prometheus properties
PROMETHEUS_URL = read_configmap_value('PROMETHEUS_URL', 'http://164.90.255.142:9090')
PROMETHEUS_METRICS_USAGE_TIME = int(read_configmap_value('PROMETHEUS_METRICS_USAGE_TIME', '600'))
PROMETHEUS_METRICS_USAGE_RESOLUTION = int(read_configmap_value('PROMETHEUS_METRICS_USAGE_RESOLUTION', '20'))

# ML model base url
MODEL_API_URL = read_configmap_value('MODEL_API_URL', 'http://98.81.170.67')
PREDICTIONS_ENDPOINT = "/predict"
ML_MODEL_TIMEOUT = 10
