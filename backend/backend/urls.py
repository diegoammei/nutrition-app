from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from patients.views import (
    PatientViewSet,
    AnthropometryViewSet,
    NutritionPlanViewSet,
    AppointmentViewSet,
    NutritionPlanMenuItemViewSet,
    PathologyViewSet,
    NutritionHistoryViewSet,
    BiochemicalTestViewSet,
    FollowUpNoteViewSet,
)

router = DefaultRouter()

router.register(
    r'patients',
    PatientViewSet,
    basename='patient'
)

router.register(
    r'anthropometries',
    AnthropometryViewSet,
    basename='anthropometry'
)

router.register(
    r'nutrition-plans',
    NutritionPlanViewSet,
    basename='nutrition-plan'
)

router.register(
    r'appointments',
    AppointmentViewSet,
    basename='appointment'
)

router.register(
    r'nutrition-plan-menu-items',
    NutritionPlanMenuItemViewSet,
    basename='nutrition-plan-menu-item'
)

router.register(
    r'pathologies',
    PathologyViewSet
)

router.register(
    r'nutrition-histories',
    NutritionHistoryViewSet,
    basename='nutrition-history'
)

router.register(
    r'biochemical-tests',
    BiochemicalTestViewSet,
    basename='biochemical-test'
)

router.register(
    r'follow-up-notes',
    FollowUpNoteViewSet,
    basename='follow-up-note'
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]