from django.urls import path
from .views import Update

urlpatterns = [
    path('update', Update.as_view(), name="kapts2"),
]
