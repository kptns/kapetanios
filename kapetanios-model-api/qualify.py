from numpy import array
from pandas import read_pickle, DataFrame, date_range, to_datetime
from os.path import join
from os import environ
from json import dumps, loads
from datetime import datetime
environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow.compat.v1.logging import set_verbosity, FATAL
set_verbosity(FATAL)
from tensorflow.keras.models import load_model

def load_models(path):
    """
    Loads the CPU and memory models along with their respective scalers from the specified directory.

    Args:
        path (str): The directory path where the model and scaler files are located.

    Returns:
        tuple: A tuple containing the following elements:
            - cpu_scaler_x: The scaler for the CPU model input features.
            - cpu_scaler_y: The scaler for the CPU model output features.
            - cpu_model: The loaded CPU model.
            - memory_scaler_x: The scaler for the memory model input features.
            - memory_scaler_y: The scaler for the memory model output features.
            - memory_model: The loaded memory model.

    Raises:
        Exception: If there is an error while loading the model artifacts, an exception is raised with the error message.
    """
    try:
        make_path = lambda x: join(path, x)
        cpu_scaler_x = read_pickle(make_path("cpu_gru_scaler_x.pkl"))
        cpu_scaler_y = read_pickle(make_path("cpu_gru_scaler_y.pkl"))
        cpu_model = load_model(make_path("cpu_gru.keras"))
        memory_scaler_x = read_pickle(make_path("memory_gru_scaler_x.pkl"))
        memory_scaler_y = read_pickle(make_path("memory_gru_scaler_y.pkl"))
        memory_model = load_model(make_path("memory_gru.keras"))
        return cpu_scaler_x, cpu_scaler_y, cpu_model, memory_scaler_x, memory_scaler_y, memory_model
    except Exception as e:
        raise Exception(
            "An error occurred while loading model artifacts. Error: "+str(e))


def complete_series(df: DataFrame, time_column: str, frequency: str = "h"):
    """
    Completes a time series DataFrame by filling in missing time intervals.

    Parameters:
    df (DataFrame): The input DataFrame containing the time series data.
    time_column (str): The name of the column containing the time data.
    frequency (str, optional): The frequency of the time intervals to fill in. Defaults to "h" (hourly).

    Returns:
    DataFrame: A DataFrame with the time series completed, indexed by the specified frequency.
    """
    date_index = date_range(start=df[time_column].min(
    ), end=df[time_column].max(), freq=frequency)
    df = df.set_index(time_column).reindex(date_index)
    return df


def qualify(timestamp, memory_data, cpu_data, cpu_scaler_x, cpu_scaler_y, cpu_model, memory_scaler_x, memory_scaler_y, memory_model):
    """
    Predicts future memory and CPU usage based on provided data and models.

    Args:
        timestamp (list or array-like): List of timestamps corresponding to the data points.
        memory_data (list or array-like): Historical memory usage data.
        cpu_data (list or array-like): Historical CPU usage data.
        cpu_scaler_x (sklearn.preprocessing.StandardScaler): Scaler for CPU input data.
        cpu_scaler_y (sklearn.preprocessing.StandardScaler): Scaler for CPU output data.
        cpu_model (keras.Model): Trained model for predicting CPU usage.
        memory_scaler_x (sklearn.preprocessing.StandardScaler): Scaler for memory input data.
        memory_scaler_y (sklearn.preprocessing.StandardScaler): Scaler for memory output data.
        memory_model (keras.Model): Trained model for predicting memory usage.

    Returns:
        tuple: A tuple containing the predicted memory usage and CPU usage.

    Raises:
        Exception: If an error occurs during the prediction process for either memory or CPU usage.
    """
    # Qualification flow for memory
    try:
        memory_data = DataFrame(data=memory_data)
        memory_data["timestamp"] = to_datetime(timestamp)
        memory_data = complete_series(memory_data, "timestamp", "20S")
        memory_data = memory_data.resample("1min").mean()
        memory_data_raw = memory_data.values
        memory_data_raw = memory_data_raw.flatten()[1:]
        memory_data = memory_data.pct_change().dropna().values
        memory_data = memory_scaler_x.transform(memory_data)
        memory_data = memory_data.reshape(
            memory_data.shape[0], 1, memory_data.shape[1])
        memory_prediction = memory_model.predict(memory_data, verbose=False)
        memory_prediction = memory_scaler_y.inverse_transform(
            memory_prediction)
        memory_prediction = memory_prediction.flatten()
        memory_prediction = (
            memory_data_raw * memory_prediction) + memory_data_raw
        memory_prediction = memory_prediction[-1]
        memory_prediction = float(memory_prediction)
    except Exception as e:
        raise Exception(
            "An error occurred while predicting memory_usage. Error: "+str(e))
    # Qualification flow for CPU
    try:
        cpu_data_raw = cpu_data[:]
        cpu_data_raw = array(cpu_data[1:])
        cpu_data_raw = cpu_data_raw.flatten()
        cpu_data = DataFrame(cpu_data)
        cpu_data["timestamp"] = to_datetime(timestamp)
        cpu_data = complete_series(cpu_data, "timestamp", "20S")
        cpu_data = cpu_data.resample("1min").mean()
        cpu_data_raw = cpu_data.values
        cpu_data_raw = cpu_data_raw.flatten()[1:]
        cpu_data = cpu_data.pct_change().dropna().values
        cpu_data = cpu_scaler_x.transform(cpu_data)
        cpu_data = cpu_data.reshape(cpu_data.shape[0], 1, cpu_data.shape[1])
        cpu_prediction = cpu_model.predict(cpu_data, verbose=False)
        cpu_prediction = cpu_scaler_y.inverse_transform(cpu_prediction)
        cpu_prediction = cpu_prediction.flatten()
        cpu_prediction = (cpu_data_raw * cpu_prediction) + cpu_data_raw
        cpu_prediction = cpu_prediction[-1]
        cpu_prediction = float(cpu_prediction)
    except Exception as e:
        raise Exception(
            "An error occurred while predicting cpu_usage_total. Error: "+str(e))
    return memory_prediction, cpu_prediction


def main(data):
    """
    Main function to process the input data and generate predictions for memory and CPU usage.

    Args:
        data (dict): A dictionary containing the input data with the following keys:
            - "memory_usage": The memory usage data.
            - "cpu_usage_total": The total CPU usage data.

    Returns:
        tuple: A tuple containing the status code and the response message.
            - (200, str): If the processing is successful, returns a status code of 200 and a JSON string with the predictions.
            - (500, str): If an error occurs, returns a status code of 500 and an error message with a timestamp.
    """
    try:
        assert "memory_usage" in data
        memory_usage = data["memory_usage"]
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: 'memory_usage' is not on payload")
    try:
        assert "cpu_usage_total" in data
        cpu_usage_total = data["cpu_usage_total"]
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: 'cpu_usage_total' is not on payload")
    try:
        assert "timestamp" in data
        timestamp = data["timestamp"]
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: 'memory_usage' is not on payload")
    try:
        cpu_scaler_x, cpu_scaler_y, cpu_model, memory_scaler_x, memory_scaler_y, memory_model = load_models(
            "./models/")
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: " + str(e))
    try:
        memory_prediction, cpu_prediction = qualify(timestamp,
                                                    memory_usage, cpu_usage_total, cpu_scaler_x, cpu_scaler_y, cpu_model, memory_scaler_x, memory_scaler_y, memory_model)
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: " + str(e))
    try:
        dc_response = {}
        dc_response["predictions"] = {
            "memory_usage": memory_prediction, "cpu_usage_total": cpu_prediction}
        return (200, dumps(dc_response))
    except Exception as e:
        return (500, datetime.now().strftime("%Y-%m-%d %H:%M:%S") + " - Error: An error ocurred while making response. " + str(e))
