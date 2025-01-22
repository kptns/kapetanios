from django.shortcuts import render
from rest_framework.views import APIView
from Utils.ResponseUtils import CustomResponse
import firebase_admin

class Update(APIView):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)  # Llama al constructor de la clase base
        cred = credentials.Certificate("path/to/your-service-account-file.json")

        # Inicializar la app de Firebase
        firebase_admin.initialize_app(cred)

    def get(self, request):
        # TODO: Configuraciones que debe saber el agente
        return CustomResponse.success(data="Todo bien")