

class Deployment:
    def __init__(
        self,
        name: str,
        namespace: str,
        model: str,
        status: bool,
        min_replicas: int,
        max_replicas: int,
        cpu_usage_threshold: float,
        memory_usage_threshold: float,
        hpa_enabled: bool,
        hpa_name: str,
        target_spec_name: str,
    ):
        self.name = name
        self.namespace = namespace
        self.model = model
        self.status = status
        self.min_replicas = min_replicas
        self.max_replicas = max_replicas
        self.cpu_usage_threshold = cpu_usage_threshold
        self.memory_usage_threshold = memory_usage_threshold
        self.hpa_enabled = hpa_enabled
        self.hpa_name = hpa_name
        self.target_spec_name = target_spec_name
