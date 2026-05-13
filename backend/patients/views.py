from rest_framework import viewsets
from .models import (
    Patient,
    Anthropometry,
    NutritionPlan,
    Appointment,
    NutritionPlanMenuItem,
    Pathology,
    NutritionHistory,
    BiochemicalTest,
    FollowUpNote,
)
from .serializers import (
    PatientSerializer,
    AnthropometrySerializer,
    NutritionPlanSerializer,
    AppointmentSerializer,
    NutritionPlanMenuItemSerializer,
    PathologySerializer,
    NutritionHistorySerializer,
    BiochemicalTestSerializer,
    FollowUpNoteSerializer,
)


class PatientViewSet(viewsets.ModelViewSet):
    serializer_class = PatientSerializer

    def get_queryset(self):
        return Patient.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class AnthropometryViewSet(viewsets.ModelViewSet):
    serializer_class = AnthropometrySerializer

    def get_queryset(self):
        return Anthropometry.objects.filter(
            patient__user=self.request.user
        )


class NutritionPlanViewSet(viewsets.ModelViewSet):
    serializer_class = NutritionPlanSerializer

    def get_queryset(self):
        return NutritionPlan.objects.filter(
            patient__user=self.request.user
        )


class AppointmentViewSet(viewsets.ModelViewSet):
    serializer_class = AppointmentSerializer

    def get_queryset(self):
        return Appointment.objects.filter(
            patient__user=self.request.user
        ).order_by('-date')


class NutritionPlanMenuItemViewSet(viewsets.ModelViewSet):
    serializer_class = NutritionPlanMenuItemSerializer

    def get_queryset(self):
        return NutritionPlanMenuItem.objects.filter(
            nutrition_plan__patient__user=self.request.user
        )


class PathologyViewSet(viewsets.ModelViewSet):
    queryset = Pathology.objects.all()
    serializer_class = PathologySerializer


class NutritionHistoryViewSet(viewsets.ModelViewSet):
    serializer_class = NutritionHistorySerializer

    def get_queryset(self):
        return NutritionHistory.objects.filter(
            patient__user=self.request.user
        )


class BiochemicalTestViewSet(viewsets.ModelViewSet):
    serializer_class = BiochemicalTestSerializer

    def get_queryset(self):
        return BiochemicalTest.objects.filter(
            patient__user=self.request.user
        ).order_by('-date')


class FollowUpNoteViewSet(viewsets.ModelViewSet):
    serializer_class = FollowUpNoteSerializer

    def get_queryset(self):
        return FollowUpNote.objects.filter(
            patient__user=self.request.user
        ).order_by('-date')