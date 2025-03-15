from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from qualify import main

# Create the API
app = FastAPI(
    title="Resource Consumption Prediction API",
    description="This API receives historical CPU and memory usage data and predicts their future trends using deep learning models.",
    version="1.0.0"
)

# Define the input schema with validation


class InputData(BaseModel):
    timestamp: list = Field(
        ...,
        example=[
            '2025-02-16 23:50:00', '2025-02-16 23:50:20', '2025-02-16 23:50:40', '2025-02-16 23:51:00',
            '2025-02-16 23:51:20', '2025-02-16 23:51:40', '2025-02-16 23:52:00', '2025-02-16 23:52:20',
            '2025-02-16 23:52:40', '2025-02-16 23:53:00', '2025-02-16 23:53:20', '2025-02-16 23:53:40',
            '2025-02-16 23:54:00', '2025-02-16 23:54:20', '2025-02-16 23:54:40', '2025-02-16 23:55:00',
            '2025-02-16 23:55:20', '2025-02-16 23:55:40', '2025-02-16 23:56:00', '2025-02-16 23:56:20',
            '2025-02-16 23:56:40', '2025-02-16 23:57:00', '2025-02-16 23:57:20', '2025-02-16 23:57:40',
            '2025-02-16 23:58:00', '2025-02-16 23:58:20', '2025-02-16 23:58:40', '2025-02-16 23:59:00',
            '2025-02-16 23:59:20', '2025-02-16 23:59:40', '2025-02-17 00:00:00'
        ],
        description="List of timestamps corresponding to the recorded CPU and memory usage."
    )
    memory_usage: list = Field(
        ...,
        example=[73738922.66666667, 58279253.333333336, 69585578.66666667, 59376981.333333336,
                 62293333.333333336, 60803754.66666666, 52391936.0, 86723242.66666667, 56595797.333333336,
                 57595221.333333336, 55024298.66666666, 53478741.333333336, 73662464.0, 58017109.333333336,
                 56524800.0, 62252373.333333336, 60523861.333333336, 51301034.66666666, 46044501.333333336,
                 46043136.0, 52027392.0, 72983893.33333333, 48674133.333333336, 57993898.66666666, 51217749.333333336,
                 54688426.66666666, 92785322.66666669, 54028970.66666666, 57257984.0, 52396032.0, 46044501.333333336],
        description="List of historical memory usage values in bytes."
    )
    cpu_usage_total: list = Field(
        ...,
        example=[102542234.04773767, 162082993.39437494, 65213358.902418055, 138720066.75578636,
                 96870240.40540367, 147245440.07193786, 109993550.37839688, 81076553.90370427,
                 124951654.08130574, 107234978.18093611, 83638518.66036564, 150061036.3517641,
                 94217401.6648606, 87432097.27114743, 107536992.96826269, 134857073.7971247,
                 93314321.63348328, 83244361.53600778, 166341017.30767345, 96989408.61102076,
                 95500049.497645, 97990595.61629976, 116227920.55279715, 154201133.4692643,
                 94826087.05051276, 115244351.38504164, 121566224.10339712, 107719616.07242936,
                 101512479.08121514, 135615525.33333334, 77156218.66666667],
        description="List of historical total CPU usage values in cycles."
    )

# Health check endpoint


@app.get("/", summary="Check if the API is running", tags=["General"])
def home():
    """
    Endpoint to verify if the API is running.
    """
    return {"message": "API for resource consumption prediction is active."}

# Prediction endpoint


@app.post("/predict/", summary="Predict future CPU and memory usage", tags=["Predictions"])
def predict(data: InputData):
    """
    Receives historical memory and CPU usage data, processes it through prediction models, and returns estimated future values.

    **Parameters**:
    - `timestamp` (list[str]): List of timestamps corresponding to the recorded CPU and memory usage.
    - `memory_usage` (list[float]): List of historical memory usage values.
    - `cpu_usage_total` (list[float]): List of historical total CPU usage values.

    **Response**:
    - `200 OK`: Returns a dictionary with predicted `memory_usage` and `cpu_usage_total`.
    - `500 Internal Server Error`: Returns an error message in case of failure.

    **Example Request**:
    ```json
    {
      "timestamp": ["2025-02-16 23:50:00", "2025-02-16 23:50:20", "2025-02-16 23:50:40"],
      "memory_usage": [73738922.67, 58279253.33, 69585578.67],
      "cpu_usage_total": [102542234.05, 162082993.39, 65213358.90]
    }
    ```
    """
    input_dict = {
        "timestamp": data.timestamp,
        "memory_usage": data.memory_usage,
        "cpu_usage_total": data.cpu_usage_total
    }

    status, response = main(input_dict)

    if status == 200:
        return response
    else:
        raise HTTPException(status_code=500, detail=response)
