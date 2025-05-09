import time

payload = {
    "timestamp": str(time.time()),
    "polling_interval": 5,
    "deployments": [
        {
            "name": "kapetanios-sample-app",
            "namespace": "default",
            "model": "kptns-sample-app-",
            "status": {
                "enabled": True,
                "min_replicas": 1,
                "max_replicas": 6,
                "cpu_usage_threshold": 0.85,
                "memory_usage_threshold": 0.85,
                "hpa": {
                    "available": False,
                    "hpa_name": "sample-hpa",
                    "target_spec_name": "kptns-other-app-1736220219"
                }
            }
        },
        {
            "name": "other-app",
            "namespace": "default",
            "model": "kptns-other-app-1736220345",
            "status": {
                "enabled": False,
                "min_replicas": 1,
                "max_replicas": 3,
                "cpu_usage_threshold": 0.85,
                "memory_usage_threshold": 0.85,
                "hpa": {
                    "available": True,
                    "hpa_name": "other-hpa",
                    "target_spec_name": "kptns-other-app-<timestamp>"
                }
            }
        }
    ]
}
