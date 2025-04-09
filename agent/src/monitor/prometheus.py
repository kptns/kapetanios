# Python tools
import time
from datetime import datetime
from typing import List, Union

# 3rd party
import requests

# Settings, values
from settings.vault import PROMETHEUS_URL
from settings.vault import PROMETHEUS_METRICS_USAGE_TIME
from settings.vault import PROMETHEUS_METRICS_USAGE_RESOLUTION


class PrometheusError(Exception):
    """Custom exception class for Prometheus-related errors."""
    pass


class PrometheusClient:
    def _get_cpu_metrics(self, start_time, end_time):
        """
        Get CPU metrics from Prometheus.
        Returns a dictionary with timestamps and CPU usage values.
        """
        query = 'sum(rate(container_cpu_usage_seconds_total{namespace="default", pod=~"kapetanios-sample-app-.*", container!=""}[5m])) * 1000000000'
        url = f"{PROMETHEUS_URL}/api/v1/query_range?query={query}&start={start_time}&end={end_time}&step={PROMETHEUS_METRICS_USAGE_RESOLUTION}"

        try:
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()

            if data["status"] == "success" and data["data"]["result"]:
                result = data["data"]["result"][0]
                timestamps = []
                cpu_values = []

                for value in result["values"]:
                    # Convertir timestamp Unix a formato datetime
                    dt = datetime.fromtimestamp(value[0])
                    formatted_time = dt.strftime("%Y-%m-%d %H:%M:%S")
                    timestamps.append(formatted_time)
                    cpu_values.append(float(value[1]))

                return {"timestamp": timestamps, "cpu_usage_total": cpu_values}
            return {"timestamp": [], "cpu_usage_total": []}
        except Exception as e:
            raise {"timestamp": [], "cpu_usage_total": []}

    def _get_memory_metrics(self, start_time, end_time):
        """
        Get memory metrics from Prometheus.
        Returns a dictionary with timestamps and memory usage values in bytes.
        """
        query = 'sum(container_memory_working_set_bytes{namespace="default", pod=~"kapetanios-sample-app-.*", container!=""})'
        url = f"{PROMETHEUS_URL}/api/v1/query_range?query={query}&start={start_time}&end={end_time}&step={PROMETHEUS_METRICS_USAGE_RESOLUTION}"

        try:
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()

            if data["status"] == "success" and data["data"]["result"]:
                result = data["data"]["result"][0]
                timestamps = []
                memory_values = []

                for value in result["values"]:
                    # Convertir timestamp Unix a formato datetime
                    dt = datetime.fromtimestamp(value[0])
                    formatted_time = dt.strftime("%Y-%m-%d %H:%M:%S")
                    timestamps.append(formatted_time)
                    memory_values.append(float(value[1]))

                return {"timestamp": timestamps, "memory_usage": memory_values}
            return {"timestamp": [], "memory_usage": []}
        except Exception as e:
            raise PrometheusError(f"Error getting memory metrics: {e}")

    def get_usage_package(self):
        """
        Returns the usage package of CPU and memory metrics.

        Returns:
            Dict[str, List[Union[str, float]]]: Dictionary containing timestamps, memory and CPU metrics
            
        Raises:
            Exception: If there's an error getting metrics from Prometheus
        """
        try:
            # Calculate time range once to ensure consistency
            end_time = int(time.time())
            start_time = end_time - PROMETHEUS_METRICS_USAGE_TIME

            # Get metrics using the same time range
            cpu_metrics = self._get_cpu_metrics(start_time, end_time)
            memory_metrics = self._get_memory_metrics(start_time, end_time)

            # Verify we have data
            if not cpu_metrics["timestamp"] or not memory_metrics["timestamp"]:
                raise PrometheusError("No metrics data available")

            # Verify timestamps match
            if cpu_metrics["timestamp"] != memory_metrics["timestamp"]:
                raise ValueError("CPU and memory timestamps don't match")

            # Build usage package
            usage_package = {
                "timestamp": cpu_metrics["timestamp"],
                "memory_usage": memory_metrics["memory_usage"],
                "cpu_usage_total": cpu_metrics["cpu_usage_total"]
            }

            return usage_package

        except Exception as e:
            raise PrometheusError(f"Unexpected error getting metrics: {e}")
