"""
FastAPI application for CPU and memory load testing.

This module provides endpoints to test CPU and memory intensive operations,
measuring their execution times and results.
"""

from fastapi import FastAPI
import random
import time
import numpy as np
import json

app = FastAPI()


def cpu_intensive_operation() -> float:
    """
    Perform a CPU-intensive calculation using mathematical operations.

    This function generates a random number of iterations and performs
    complex mathematical calculations to simulate CPU load.

    Returns:
        float: The result of the mathematical operations.
    """
    n = random.randint(100000, 1001000)
    result = 0
    for i in range(n):
        result += pow(i, 2) * pow(i, 3) / (i + 1)
    return result


def memory_intensive_operation() -> float:
    """
    Perform a memory-intensive operation using NumPy arrays.

    This function creates large random arrays in memory and performs
    operations between them to simulate memory usage.

    Returns:
        float: The dot product result of two large random arrays.
    """
    arrays = dict()
    # Create and manipulate large numpy arrays
    for i in range(1, random.randint(2, 10)):
        size = random.randint(1000000, 1001000)
        arrays[f"array_{i}"] = None
        arrays[f"array_{i}"] = np.random.rand(size)
    return arrays["array_1"].sum()


@app.get("/cpu-ops")
async def cpu_load() -> dict:
    """
    Handle CPU load testing endpoint.

    This endpoint triggers a CPU-intensive operation and measures
    its execution time.

    Returns:
        dict: A dictionary containing:
            - result (float): The result of the CPU operation
            - execution_time (float): Time taken to execute the operation
            - operation (str): Description of the operation performed
    """
    start_time = time.time()
    result = cpu_intensive_operation()
    execution_time = time.time() - start_time

    return {
        "result": result,
        "execution_time": execution_time,
        "operation": "CPU intensive task"
    }


@app.get("/mem-ops")
async def memory_load() -> dict:
    """
    Handle memory load testing endpoint.

    This endpoint triggers a memory-intensive operation and measures
    its execution time.

    Returns:
        dict: A dictionary containing:
            - result (float): The result of the memory operation
            - execution_time (float): Time taken to execute the operation
            - operation (str): Description of the operation performed
    """
    start_time = time.time()
    result = memory_intensive_operation()
    print(result)
    execution_time = time.time() - start_time

    return {
        "result": result,
        "execution_time": execution_time,
        "operation": "Memory intensive task"
    }
