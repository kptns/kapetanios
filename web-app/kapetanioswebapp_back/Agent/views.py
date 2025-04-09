from django.shortcuts import render
from rest_framework.views import APIView
from Utils.ResponseUtils import CustomResponse
from Utils.firebaseservice import FirebaseService
import os
import json
import time
from rest_framework.response import Response
from rest_framework import status

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # Directorio raíz del proyecto
credential_path = os.path.join(BASE_DIR, "Assets/firebase-keys.json")

firebaseService = FirebaseService(credential_path)

class Config(APIView):
    def get(self, request):
        # doc_id = request.GET.get("id")
        # documento = firebaseService.obtener_documento("agentes", doc_id)
        # if documento:
        #     return CustomResponse.success(data=documento)
        # return CustomResponse.error(message="Documento no encontrado")
        data = {
            "timestamp": str(time.time()),
            "polling_interval": 5,
            "deployments": [
                {
                    "name": "kapetanios-sample-app",
                    "namespace": "default",
                    "model": "kptns-sample-app-",
                    "status": {
                        "enabled": True,
                        "min_replicas": 1,
                        "max_replicas": 6,
                        "cpu_usage_threshold": 0.85,
                        "memory_usage_threshold": 0.85,
                        "hpa": {
                            "available": False,
                            "hpa_name": "sample-hpa",
                            "target_spec_name": "kptns-other-app-1736220219"
                        }
                    }
                },
                {
                    "name": "other-app",
                    "namespace": "default",
                    "model": "kptns-other-app-1736220345",
                    "status": {
                        "enabled": False,
                        "min_replicas": 1,
                        "max_replicas": 3,
                        "cpu_usage_threshold": 0.85,
                        "memory_usage_threshold": 0.85,
                        "hpa": {
                            "available": True,
                            "hpa_name": "other-hpa",
                            "target_spec_name": "kptns-other-app-<timestamp>"
                        }
                    }
                }
            ]
        }

        return Response(data, status=status.HTTP_200_OK)

class Report(APIView):
    def put(self, request):
        doc_id = request.query_params["id"]
        datos = {
            "nomCluster": request.POST.get("nomCluster"),
            "registryHost": request.POST.get("registryHost"),
            "kapsHost": request.POST.get("kapsHost"),
        }
        firebaseService.actualizar_documento("agentes", doc_id, datos)
        return CustomResponse.success(data="Agente actualizado")
    
class Logs(APIView):
    def post(self, request):
        datos = json.loads(request.body.decode('utf-8'))
        doc_id = firebaseService.insertar_documento("Logs", None, datos)
        return CustomResponse.success(data="Log registrado con exito")
    
        
        
#  Regresar a firebase-key