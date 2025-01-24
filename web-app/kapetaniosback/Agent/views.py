from django.shortcuts import render
from rest_framework.views import APIView
from Utils.ResponseUtils import CustomResponse
from Utils.firebaseservice import FirebaseService
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # Directorio raíz del proyecto
credential_path = os.path.join(BASE_DIR, "Assets/firebase-keys.json")

firebaseService = FirebaseService(credential_path)

class Config(APIView):
    def get(self, request):
        doc_id = request.GET.get("id")
        documento = firebaseService.obtener_documento("agentes", doc_id)
        if documento:
            return CustomResponse.success(data=documento)
        return CustomResponse.error(message="Documento no encontrado")

class Report(APIView):
    def put(self, request):
        doc_id = request.POST.get("id")
        datos = {
            "nomCluster": request.POST.get("nomCluster"),
            "registryHost": request.POST.get("registryHost"),
            "kapsHost": request.POST.get("kapsHost"),
        }
        firebaseService.actualizar_documento("agentes", doc_id, datos)
        return CustomResponse.success(data="Documento actualizado")