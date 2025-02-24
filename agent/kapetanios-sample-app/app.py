from fastapi import FastAPI, Query, Header
from typing import Optional
import datetime
import json

app = FastAPI()


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.get("/api/v1/config")
async def config():
    # Simplified response without parameter validation for testing
    return {
        "timestamp": datetime.datetime.now().isoformat(),
        "polling_interval": 20,
        "deployments": [
            {
                "name": "kapetanios-sample-app",
                "model": f"kptns-sample-app-",
                "status": {
                    "enabled": "true",
                    "min_replicas": 1,
                    "max_replicas": 3,
                    "hpa": {
                        "available": "true",
                        "hpa_name": "sample-hpa",
                        "target_spec_name": "kptns-other-app-1736220219"
                    }
                }
            },
            {
                "name": "other-app",
                "model": "kptns-other-app-1736220345",
                "status": {
                    "enabled": "false",
                    "min_replicas": 1,
                    "max_replicas": 3,
                    "hpa": {
                        "available": "true",
                        "hpa_name": "other-hpa",
                        "target_spec_name": "kptns-other-app-<timestamp>"
                    }
                }
            }
        ]
    }
