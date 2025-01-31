from django.shortcuts import render
from rest_framework.views import APIView
from Utils.ResponseUtils import CustomResponse
import firebase_admin
from firebase_admin import credentials, firestore
from Utils.firebaseservice import FirebaseService
import os
import json

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))  # Directorio raíz del proyecto
credential_path = os.path.join(BASE_DIR, "Assets/firebase-keys.json")

firebaseService = FirebaseService(credential_path)

class Update(APIView):
    def post(self, request):
        datos = json.loads(request.body.decode('utf-8'))
        doc_id = firebaseService.insertar_documento("agentes", None, datos)
        return CustomResponse.success(data="Agente registrado con exito.")
    
    def get(self, request):
        doc_id = request.GET.get("id")
        documento = firebaseService.obtener_documento("agentes", doc_id)
        if documento:
            return CustomResponse.success(data=documento)
        return CustomResponse.error(message="Documento no encontrado")
    
    def delete(self, request):
        doc_id = request.GET.get("id")
        firebaseService.eliminar_documento("agentes", doc_id)
        return CustomResponse.success(data="Documento eliminado")
    
    def put(self, request):
        doc_id = request.POST.get("id")
        datos = {
            "nomCluster": request.POST.get("nomCluster"),
            "registryHost": request.POST.get("registryHost"),
            "kapsHost": request.POST.get("kapsHost"),
        }
        firebaseService.actualizar_documento("agentes", doc_id, datos)
        return CustomResponse.success(data="Documento actualizado")


