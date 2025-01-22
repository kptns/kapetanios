from django.shortcuts import render
from rest_framework.views import APIView
from Utils.ResponseUtils import CustomResponse

class Config(APIView):
    def get(self, request):
        # TODO: Configuraciones que debe saber el agente
        return CustomResponse.success(data="Todo bien")

class Report(APIView):
    def get(self, request):
        # TODO: Registrar acutalizaciones del agente
        return CustomResponse.success(data="Todo bien")