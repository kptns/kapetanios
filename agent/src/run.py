from multiprocessing import Queue
from config.manager import ConfigManager
from agent.main import Agent
import time
import sys
from utils.process import start_single_process
from typing import List
import multiprocessing
import platform


def run_queues(instances: List[object]) -> List[Queue]:
    """
    Creates a queue ççfor each process.
    """
    queues = list()
    for _ in range(len(instances)):
        queues.append(Queue())
    return queues


def run_processes(instances: List[object]) -> List[object]:
    """
    Runs the processes.
    
    Args:
        instances: List[object]
    Returns:
        List[object]: Lista de procesos iniciados
    """

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
                queues=queues
            )
        ):
            processes.append(process)

    return processes


def shutdown_processes(processes: List[object]) -> None:
    """
    Shuts down all processes.
    
    Args:
        processes: List[object]
    """
    for process in processes:
        if process.is_alive():
            print("Terminating process: ", process)
            process.terminate()
            process.join()


def main():
    try:
        # Create instances with Agent as orchestrator
        processes = run_processes([
            Agent,
            ConfigManager
        ])

        # Wait for termination signal
        while True:
            time.sleep(1)

    except KeyboardInterrupt:
        shutdown_processes(processes)
        sys.exit(1)


if __name__ == "__main__":
    # Detect OS and set appropriate start method
    if platform.system() == 'Darwin':  # macOS
        multiprocessing.set_start_method('fork')
    main()
