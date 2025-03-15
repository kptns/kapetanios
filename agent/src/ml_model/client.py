from typing import Dict, List, Union
from settings.vault import MODEL_API_URL, PREDICTIONS_ENDPOINT, ML_MODEL_TIMEOUT

import requests
import json


class ModelResponseError(Exception):
    """Custom exception for handling model API response errors"""
    def __init__(self, message: str, status_code: int = None, response: dict = None):
        self.message = message
        self.status_code = status_code
        self.response = response
        super().__init__(self.message)


class Predictor:
    def __init__(self):
        pass
    
    def response_validation(self, data):
        """
        Validates each type of data returned from the model API
        
        Args:
        -   data: Dict[str, Dict[str, float]]. The predictions received.
            Expected format:
            {
                "predictions": {
                    "cpu_usage_total": float,
                    "memory_usage": float
                }
            }
        Returns:
        -   bool: will return True if the response is valid
        Raises:
        -   ModelResponseError: if the response format is invalid
        """   
        if not isinstance(data, dict):
            raise ModelResponseError(
                message=f"Wrong data type of the response body. Got {type(data)}, needs to be a dictionary."
            )
        
        if "predictions" not in data:
            raise ModelResponseError(
                message="Missing 'predictions' key in response"
            )
            
        if not isinstance(data["predictions"], dict):
            raise ModelResponseError(
                message="'predictions' must be a dictionary"
            )
            
        required_metrics = ["cpu_usage_total", "memory_usage"]
        for metric in required_metrics:
            if metric not in data["predictions"]:
                raise ModelResponseError(
                    message=f"Missing required prediction for '{metric}'"
                )
            if not isinstance(data["predictions"][metric], (int, float)):
                raise ModelResponseError(
                    message=f"Prediction for '{metric}' must be a number"
                )

        return True

    def get_predictions(self, data: Dict[str, List[Union[str, float]]]) -> Dict:
        """
        Get the predictions for the given input data
        
        Args:
        -   data: Dict[str, List[Union[str, float]]]. It includes the last 10 min of the data from cpu
            usage and memory usage with intervals of 20s each. Also includes their datetimes of each taken.
                Example:
                {
                    "timestamp": [
                        "2025-02-16 23:50:00",
                        "2025-02-16 23:50:20",
                        "2025-02-16 23:50:40",
                        . . .
                    ],
                    "memory_usage": [
                        73738922.66666667,
                        58279253.333333336,
                        69585578.66666667,
                        . . .
                    ],
                    "cpu_usage_total": [
                        102542234.04773767,
                        162082993.39437494,
                        65213358.902418055,
                        . . .
                    ]
                }
        Returns:
        -   predictions: Dict[str, Dict[str, float]]
        Raises:
        -   ModelResponseError: if some error raises from the API, will be raise an error.
        """
        try:
            response = requests.post(
                url=MODEL_API_URL+PREDICTIONS_ENDPOINT,
                json=data,
                timeout=10
            )
            
            if response.status_code == 200:
                # First deserialization
                first_decode = json.loads(response.content)
                
                # Second deserialization
                if isinstance(first_decode, str):
                    predictions = json.loads(first_decode)
                else:
                    predictions = first_decode

                if self.response_validation(predictions):
                    return predictions

            else:
                error_message = f"API request failed with status code {response.status_code}"

                try:
                    error_response = response.json()
                    if isinstance(error_response, dict) and 'error' in error_response:
                        error_message = error_response['error']
            
                except json.JSONDecodeError:
                    error_response = response.text
                
                raise ModelResponseError(
                    message=error_message,
                    status_code=response.status_code,
                    response=error_response
                )
            
        except requests.Timeout:
            raise ModelResponseError(
                message=f"Request exceeded the time of response of {ML_MODEL_TIMEOUT}s",
                status_code=408  # Request Timeout status code
            )
            
        except requests.RequestException as e:
            raise ModelResponseError(
                message=f"Failed to connect to API: {str(e)}",
                status_code=getattr(e.response, 'status_code', None)
            )

        except json.JSONDecodeError as e:
            raise ModelResponseError(
                message=f"Failed to parse API response: {str(e)}",
                status_code=response.status_code,
                response=response.text
            )

        except Exception as e:
            error_message = str(e) if str(e) else "Unknown error occurred"
            raise ModelResponseError(
                message=f"Error in the response: {error_message}",
                status_code=getattr(e, 'status_code', None),
                response=getattr(e, 'response', None)
            ) from e
