from rest_framework import viewsets
from .models import Patient, Anthropometry, NutritionPlan
from .serializers import PatientSerializer, AnthropometrySerializer, NutritionPlanSerializer

class PatientViewSet(viewsets.ModelViewSet):
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer


class AnthropometryViewSet(viewsets.ModelViewSet):
    queryset = Anthropometry.objects.all()
    serializer_class = AnthropometrySerializer


class NutritionPlanViewSet(viewsets.ModelViewSet):
    queryset = NutritionPlan.objects.all()
    serializer_class = NutritionPlanSerializer