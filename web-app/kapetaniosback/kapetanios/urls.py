from django.urls import path
from .views import Metrics

urlpatterns = [
    path('metrics/', Metrics.as_view(), name="kapts")
]
