from django.urls import path
from .views import Config, Report

urlpatterns = [
    path('config', Config.as_view(), name="kapts2"),
    path('report', Report.as_view(), name="kapts"),
]
