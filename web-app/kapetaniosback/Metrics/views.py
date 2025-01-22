from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from Utils.ResponseUtils import CustomResponse
from datadog import initialize, api
import time

class Metrics(APIView):
    def get(self, request):
        responseData = {}
        ventana = int(request.GET.get('ventana', 60))
        options = {
            'api_key': "09ae75edc10ec7e8eb3356dd903dd9ba",
            'app_key': "e542b10fc533211c55d23b6cf5759f6a93076b60"
        }

        deployment_name = "kapetanios-sample-app"
        initialize(**options)
        metric_queries = [
            # CPU usage in cores
            f'kubernetes.cpu.usage.total{{kube_deployment:{deployment_name}}}',
            # Memory usage in bytes
            f'kubernetes.memory.usage{{kube_deployment:{deployment_name}}}',
            # Number of replicas
            f'kubernetes.pods.running{{kube_deployment:{deployment_name}}}',
            # Network traffic (in/out bytes)
            f'kubernetes.network.rx_bytes{{kube_deployment:{deployment_name}}}',
            f'kubernetes.network.tx_bytes{{kube_deployment:{deployment_name}}}'
        ]
        now = int(time.time())
        last_14_days = now - ventana

        for query in metric_queries:
            result = api.Metric.query(
                start=last_14_days,
                end=now,
                query=query
            )
            for series in result["series"]:
                responseData[series["metric"]] = series["pointlist"]

        return CustomResponse.success(data=responseData)