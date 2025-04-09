

class ReplicaManager:
    @staticmethod
    def replicas_from_cpu_usage(
        current_replicas,
        predicted_value,
        cpu_requests_limit,
        threshold,
        max_replica,
        min_replica
    ):
        # execute a scale up to the deployment
        if predicted_value >= (cpu_requests_limit * current_replicas * threshold) and current_replicas < max_replica:
            current_replicas += 1

        elif current_replicas > min_replica:
            lower_bound = cpu_requests_limit * threshold * (current_replicas - 1)

            # execute a scale down to the deployment
            if predicted_value < lower_bound:
                current_replicas -= 1
        
        elif current_replicas < min_replica:
            current_replicas = min_replica

        return current_replicas

    @staticmethod
    def replicas_from_memory_usage(
        current_replicas,
        predicted_value,
        memory_requests_limit,
        threshold,
        max_replica,
        min_replica
    ):
        # execute a scale up to the deployment
        if predicted_value >= (memory_requests_limit * current_replicas * threshold) and current_replicas < max_replica:
            current_replicas += 1
        
        elif current_replicas > min_replica:
            lower_bound = memory_requests_limit * threshold * (current_replicas - 1)
            
            # execute a scale down to the deployment
            if predicted_value < lower_bound:
                current_replicas -= 1
        
        elif current_replicas < min_replica:
            current_replicas = min_replica

        return current_replicas

    @staticmethod
    def get_new_replicas_count(replicas_from_cpu, replicas_from_memory):
        return max(replicas_from_cpu, replicas_from_memory)
