from django.urls import path
from .views import Config, Report, Logs

urlpatterns = [
    path('config', Config.as_view(), name="kapts2"),
    path('report', Report.as_view(), name="kapts"),
    path('logs', Logs.as_view(), name="kapts"),
]
