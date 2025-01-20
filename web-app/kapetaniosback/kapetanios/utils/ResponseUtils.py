from rest_framework.response import Response
from rest_framework import status

class CustomResponse:
    @staticmethod
    def success(data, message="Operación exitosa", status_code=status.HTTP_200_OK):
        return Response({
            "success": True,
            "message": message,
            "data": data
        }, status=status_code)

    @staticmethod
    def error(message="Ha ocurrido un error", status_code=status.HTTP_400_BAD_REQUEST):
        return Response({
            "success": False,
            "message": message,
            "data": None
        }, status=status_code)
