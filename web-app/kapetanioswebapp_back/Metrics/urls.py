from django.urls import path
from .views import Cpu, Memory, RxBytes, TxBytes

urlpatterns = [
    path('cpu', Cpu.as_view(), name="kapts"),
    path('memory', Memory.as_view(), name="kapts"),
    path('rxbytes', RxBytes.as_view(), name="kapts"),
    path('txbytes', TxBytes.as_view(), name="kapts"),
]
