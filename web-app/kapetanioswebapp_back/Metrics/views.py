from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from Utils.ResponseUtils import CustomResponse
from datadog import initialize, api
import time
from random import *
import requests

prometheus_url = "http://164.90.255.142:9090/api/v1/query"  # URL base de Prometheu

class Cpu(APIView):
    def get(self, request):
        query = 'sum(rate(container_cpu_usage_seconds_total{namespace="default", pod=~"kapetanios-sample-app-.*"}[5m]))'
        url = f"{prometheus_url}?query={query}"
        response = requests.get(url)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200

        data = response.json()["data"]["result"][0]["value"]
        return CustomResponse.success(data=data)
    
class Memory(APIView):
    def get(self, request):
        query = 'sum(container_memory_working_set_bytes{namespace="default", pod=~"kapetanios-sample-app-.*"}) by (pod, container)'
        url = f"{prometheus_url}?query={query}"
        response = requests.get(url)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200
        data = response.json()["data"]["result"][0]["value"]
        return CustomResponse.success(data=data)
    
class RxBytes(APIView):
    def get(self, request):
        query = 'sum(rate(container_network_receive_bytes_total{namespace="default", pod=~"kapetanios-sample-app-.*"}[5m])) by (pod, container)'
        url = f"{prometheus_url}?query={query}"
        response = requests.get(url)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200

        data = response.json()["data"]["result"][0]["value"]
        return CustomResponse.success(data=data)
    
class TxBytes(APIView):
    def get(self, request):
        query = 'sum(rate(container_network_transmit_bytes_total{namespace="default", pod=~"kapetanios-sample-app-.*"}[5m])) by (pod, container)'
        url = f"{prometheus_url}?query={query}"
        response = requests.get(url)
        response.raise_for_status()  # Lanza una excepción si la respuesta no es 200

        data = response.json()["data"]["result"][0]["value"]
        return CustomResponse.success(data=data)