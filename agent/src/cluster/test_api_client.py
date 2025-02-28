from prometheus_api_client import PrometheusConnect
from datetime import datetime, timedelta


def get_prometheus_metrics(prometheus_url, deployment_name, namespace, time_window_minutes):
    """Fetches metrics from Prometheus for a specific deployment over a time window
    
    Args:
        prometheus_url (str): URL of the Prometheus server (e.g., 'http://prometheus:9090')
        deployment_name (str): Name of the deployment to get metrics for
        namespace (str): Kubernetes namespace where the deployment is running
        time_window_minutes (int): Time window in minutes to fetch metrics for
        
    Returns:
        dict: Dictionary containing deployment metrics with the following structure:
            - cpu_usage (list): List of CPU usage values over time
            - memory_usage (list): List of memory usage values over time
            - network_rx (list): List of network received bytes over time
            - network_tx (list): List of network transmitted bytes over time
            Each list contains tuples of (timestamp, value)
    """
    try:
        # Initialize Prometheus connection
        prom = PrometheusConnect(url=prometheus_url, disable_ssl=True)
        
        # Calculate time range
        end_time = datetime.now()
        start_time = end_time - timedelta(minutes=time_window_minutes)
        
        # Define queries for different metrics
        queries = {
            'cpu_usage': f'sum(container_cpu_usage_seconds_total{{namespace="{namespace}",pod=~"{deployment_name}-[a-z0-9]+-[a-z0-9]+"}})',
            'memory_usage': f'sum(container_memory_working_set_bytes{{namespace="{namespace}",pod=~"{deployment_name}-[a-z0-9]+-[a-z0-9]+"}}) by (pod)',
            'network_rx': f'sum(rate(container_network_receive_bytes_total{{namespace="{namespace}",pod=~"{deployment_name}-[a-z0-9]+-[a-z0-9]+"}}[5m]))',
            'network_tx': f'sum(rate(container_network_transmit_bytes_total{{namespace="{namespace}",pod=~"{deployment_name}-[a-z0-9]+-[a-z0-9]+"}}[5m]))'
        }
        
        # Fetch metrics
        metrics = {}
        for metric_name, query in queries.items():
            print(f"\nExecuting query for {metric_name}:")
            print(f"Query: {query}")
            
            result = prom.custom_query_range(
                query=query,
                start_time=start_time,
                end_time=end_time,
                step='20s'
            )
            
            print(f"Raw result: {result}")
            
            if result and len(result) > 0:
                # Extract values and timestamps
                metrics[metric_name] = [(float(value[0]), float(value[1])) 
                                      for value in result[0]['values']]
                print(f"Number of data points: {len(metrics[metric_name])}")
            else:
                metrics[metric_name] = []
                print("No data points found")
                
        return metrics
        
    except Exception as e:
        print(f"Error fetching Prometheus metrics: {str(e)}")
        import traceback
        print(traceback.format_exc())
        return None

def print_metrics(metrics):
    """Prints the metrics in a formatted way
    
    Args:
        metrics (dict): Dictionary containing the metrics as returned by get_prometheus_metrics
    """
    if not metrics:
        print("No metrics available")
        return
        
    for metric_name, values in metrics.items():
        print(f"\n{metric_name.replace('_', ' ').title()}:")
        for timestamp, value in values:
            dt = datetime.fromtimestamp(timestamp)
            if 'cpu' in metric_name:
                print(f"  {dt}: {value:.3f} cores")
            elif 'memory' in metric_name:
                print(f"  {dt}: {value / (1024*1024):.2f} MB")
            else:  # network metrics
                print(f"  {dt}: {value / (1024*1024):.2f} MB/s")

# Example usage
if __name__ == "__main__":
    PROMETHEUS_URL = "http://localhost:9090"
    DEPLOYMENT_NAME = "kapetanios-sample-app"
    NAMESPACE = "default"
    TIME_WINDOW = 30  # minutes
    
    metrics = get_prometheus_metrics(
        PROMETHEUS_URL,
        DEPLOYMENT_NAME,
        NAMESPACE,
        TIME_WINDOW
    )
    
    if metrics:
        print(f"\nMetrics for deployment {DEPLOYMENT_NAME} in namespace {NAMESPACE}")
        print(f"Time window: {TIME_WINDOW} minutes")
        print_metrics(metrics)
    else:
        print("Failed to fetch metrics")
