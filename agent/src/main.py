from multiprocessing import Queue
import logging
from src.config.manager import ConfigManager
from src.agent import Agent
import time
import sys
from utils.process import start_single_process
from typing import List

logger = logging.getLogger(__name__)


def run_processes(instances: List[object]) -> None:
    """
    Runs the processes.
    
    Args:
        instances: List[object]
    """
    
    def run_queues(instances: List[object]) -> List[Queue]:
        """
        Creates a queue for each process.
        """
        queues = list()
        for instance in len(instances):
            queues.append(Queue())
        return queues
    
    # Create queues
    queues = run_queues(instances)

    # [Agent(), ConfigManager()]
    # [Queue(), Queue()]

    # Start processes
    processes = list()
    for i, instance in enumerate(instances[1:]):
        if process := start_single_process(
            instance(queue=queues[i+1])
        ):
            processes.append(process)

    for instance in instances[:1]:
        if process := start_single_process(
            instance(
                config_queue=queues[1]
            )
        ):
            processes.append(process)
            

def shutdown_processes(processes: List[object]) -> None:
    """
    Shuts down all processes.
    
    Args:
        processes: List[object]
    """
    for process in processes:
        if process.is_alive():
            process.terminate()
            process.join()


def main():
    try:
        # Create instances with Agent as orchestrator
        processes = run_processes(
            Agent(),
            ConfigManager()
        )

        # Wait for termination signal
        while True:
            time.sleep(1)

    except KeyboardInterrupt:
        logger.info("Shutting down processes...")
        shutdown_processes(processes)
        sys.exit(1)


if __name__ == "__main__":
    main()
