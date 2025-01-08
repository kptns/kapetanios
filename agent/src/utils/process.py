from multiprocessing import Process
from typing import Any, Optional, Type
import logging

logger = logging.getLogger(__name__)

def start_single_process(
    class_instance: Any,
    method_name: str = "start",
    daemon: bool = True
) -> Optional[Process]:
    """
    Starts a single process for a class instance.
    
    Args:
        class_instance: Instance of the class to run in the process
        method_name: Name of the method to execute (defaults to 'start')
        daemon: Whether the process should be daemon (defaults to True)
    
    Returns:
        Process: The created process or None if error occurs
    """
    try:
        if not hasattr(class_instance, method_name):
            raise AttributeError(
                f"Class {class_instance.__class__.__name__} has no method '{method_name}'"
            )

        process = Process(
            target=getattr(class_instance, method_name),
            name=f"{class_instance.__class__.__name__}Process",
            daemon=daemon
        )
        process.start()
        
        logger.info(f"Process started for {class_instance.__class__.__name__}")
        return process
        
    except Exception as e:
        logger.error(f"Error starting process for {class_instance.__class__.__name__}: {e}")
        return None
