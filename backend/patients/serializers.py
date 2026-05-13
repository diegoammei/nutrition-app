from rest_framework import serializers
from .models import (
    Patient,
    Anthropometry,
    Appointment,
    NutritionPlan,
    NutritionPlanMenuItem,
    Pathology,
    NutritionHistory,
    BiochemicalTest,
    FollowUpNote,
)


class PathologySerializer(serializers.ModelSerializer):
    class Meta:
        model = Pathology
        fields = '__all__'

class NutritionHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = NutritionHistory
        fields = '__all__'

class PatientSerializer(serializers.ModelSerializer):
    pathologies_detail = PathologySerializer(
        source='pathologies',
        many=True,
        read_only=True,
    )

    class Meta:
        model = Patient
        fields = '__all__'
        read_only_fields = ['user']


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


class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'


class NutritionPlanMenuItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = NutritionPlanMenuItem
        fields = '__all__'

class BiochemicalTestSerializer(serializers.ModelSerializer):
    class Meta:
        model = BiochemicalTest
        fields = '__all__'

class FollowUpNoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = FollowUpNote
        fields = '__all__'