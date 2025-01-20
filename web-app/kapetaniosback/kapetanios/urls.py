from django.urls import path
from .views import Kapetanios

urlpatterns = [
    path('metrics/', Kapetanios.as_view(), name="kapts")
]
