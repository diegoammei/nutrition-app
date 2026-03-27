from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from patients.views import PatientViewSet, AnthropometryViewSet, NutritionPlanViewSet

router = DefaultRouter()
router.register(r'patients', PatientViewSet)
router.register(r'anthropometries', AnthropometryViewSet)
router.register(r'nutrition-plans', NutritionPlanViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
]