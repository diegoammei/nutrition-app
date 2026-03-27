from rest_framework import serializers
from .models import Patient, Anthropometry, NutritionPlan


class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = '__all__'


class AnthropometrySerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='patient.name', read_only=True)

    class Meta:
        model = Anthropometry
        fields = '__all__'


class NutritionPlanSerializer(serializers.ModelSerializer):
    patient_name = serializers.CharField(source='patient.name', read_only=True)

    class Meta:
        model = NutritionPlan
        fields = '__all__'
        read_only_fields = ['total_calories', 'protein', 'carbs', 'fats']