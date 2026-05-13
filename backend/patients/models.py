from django.db import models
from django.contrib.auth.models import User


class Pathology(models.Model):
    code = models.CharField(max_length=50, unique=True)
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class Patient(models.Model):
    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='patients'
    )

    name = models.CharField(max_length=255)
    age = models.IntegerField()
    gender = models.CharField(max_length=10)
    phone = models.CharField(max_length=20)
    height = models.FloatField(blank=True, null=True)
    email = models.EmailField()
    pathologies = models.ManyToManyField(Pathology, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class NutritionHistory(models.Model):
    APPETITE_CHOICES = [
        ('good', 'Bueno'),
        ('normal', 'Normal'),
        ('low', 'Poco'),
    ]

    patient = models.OneToOneField(
        'Patient',
        on_delete=models.CASCADE,
        related_name='nutrition_history'
    )

    consultation_reason = models.TextField(blank=True, null=True)

    family_diabetes = models.BooleanField(default=False)
    family_obesity = models.BooleanField(default=False)
    family_cancer = models.BooleanField(default=False)
    family_hypertension = models.BooleanField(default=False)
    family_thyroid = models.BooleanField(default=False)
    family_other = models.CharField(max_length=255, blank=True, null=True)

    previous_conditions = models.TextField(blank=True, null=True)
    current_condition = models.TextField(blank=True, null=True)
    diagnosis_date = models.DateField(blank=True, null=True)

    current_medications = models.TextField(blank=True, null=True)
    supplements = models.TextField(blank=True, null=True)

    appetite = models.CharField(
        max_length=20,
        choices=APPETITE_CHOICES,
        blank=True,
        null=True
    )

    meals_per_day = models.IntegerField(blank=True, null=True)
    regular_schedule = models.BooleanField(default=False)

    avoided_foods = models.TextField(blank=True, null=True)
    avoided_foods_reason = models.TextField(blank=True, null=True)
    food_allergies = models.TextField(blank=True, null=True)

    smokes = models.BooleanField(default=False)
    smoking_quantity = models.CharField(
        max_length=100,
        blank=True,
        null=True
    )

    drinks_alcohol = models.BooleanField(default=False)
    alcohol_quantity = models.CharField(
        max_length=100,
        blank=True,
        null=True
    )

    recall_breakfast = models.TextField(blank=True, null=True)
    recall_morning_snack = models.TextField(blank=True, null=True)
    recall_lunch = models.TextField(blank=True, null=True)
    recall_afternoon_snack = models.TextField(blank=True, null=True)
    recall_dinner = models.TextField(blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Historia nutricional - {self.patient.name}"
    
class BiochemicalTest(models.Model):
    patient = models.ForeignKey(
        'Patient',
        on_delete=models.CASCADE,
        related_name='biochemical_tests'
    )
    date = models.DateField()
    test_name = models.CharField(max_length=150)
    result = models.CharField(max_length=150)
    notes = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.patient.name} - {self.test_name} - {self.date}"
    
class FollowUpNote(models.Model):
    patient = models.ForeignKey(
        'Patient',
        on_delete=models.CASCADE,
        related_name='follow_up_notes'
    )

    appointment = models.ForeignKey(
        'Appointment',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='follow_up_notes'
    )

    date = models.DateTimeField(auto_now_add=True)

    evolution = models.TextField(blank=True, null=True)

    adherence = models.CharField(
        max_length=50,
        blank=True,
        null=True
    )

    symptoms = models.TextField(blank=True, null=True)

    observations = models.TextField(blank=True, null=True)

    plan_changes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.patient.name} - Seguimiento"

class Anthropometry(models.Model):
    patient = models.ForeignKey(
        'Patient',
        on_delete=models.CASCADE,
        related_name='anthropometries'
    )

    weight = models.FloatField()
    height = models.FloatField()
    body_mass_index = models.FloatField(blank=True, null=True)
    body_fat_percentage = models.FloatField(blank=True, null=True)
    muscle_percentage = models.FloatField(blank=True, null=True)
    metabolic_age = models.IntegerField(blank=True, null=True)
    visceral_fat = models.FloatField(blank=True, null=True)
    waist = models.FloatField(blank=True, null=True)
    hip = models.FloatField(blank=True, null=True)
    arm_circumference = models.FloatField(blank=True, null=True)
    bicipital_skinfold = models.FloatField(blank=True, null=True)
    tricipital_skinfold = models.FloatField(blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if self.weight and self.height:
            self.body_mass_index = (
                self.weight / ((self.height / 100) ** 2)
            )

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.patient.name} - {self.created_at.date()}"


class NutritionPlan(models.Model):
    GOAL_CHOICES = [
        ('deficit', 'Déficit'),
        ('maintain', 'Mantenimiento'),
        ('superavit', 'Superávit'),
    ]

    GENDER_CHOICES = [
        ('male', 'Masculino'),
        ('female', 'Femenino'),
    ]

    ACTIVITY_FACTOR_CHOICES = [
        (1.2, 'Sedentario'),
        (1.375, 'Ligera actividad'),
        (1.55, 'Moderada actividad'),
        (1.725, 'Alta actividad'),
        (1.9, 'Muy alta actividad'),
    ]

    patient = models.ForeignKey(
        'Patient',
        on_delete=models.CASCADE,
        related_name='nutrition_plans'
    )

    weight = models.FloatField()
    height = models.FloatField()
    age = models.IntegerField()

    gender = models.CharField(
        max_length=10,
        choices=GENDER_CHOICES
    )

    activity_factor = models.FloatField(
        choices=ACTIVITY_FACTOR_CHOICES
    )

    goal = models.CharField(
        max_length=20,
        choices=GOAL_CHOICES
    )

    total_calories = models.FloatField(blank=True, null=True)
    protein = models.FloatField(blank=True, null=True)
    carbs = models.FloatField(blank=True, null=True)
    fats = models.FloatField(blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if self.gender.lower() == 'male':
            bmr = (
                (10 * self.weight)
                + (6.25 * self.height)
                - (5 * self.age)
                + 5
            )
        else:
            bmr = (
                (10 * self.weight)
                + (6.25 * self.height)
                - (5 * self.age)
                - 161
            )

        total = bmr * self.activity_factor

        if self.goal == 'deficit':
            total *= 0.8
        elif self.goal == 'superavit':
            total *= 1.2

        protein_pct = 0.20
        carbs_pct = 0.50
        fat_pct = 0.30

        pathology_codes = set(
            self.patient.pathologies.values_list(
                'code',
                flat=True
            )
        )

        if 'diabetes' in pathology_codes:
            protein_pct = 0.25
            carbs_pct = 0.40
            fat_pct = 0.35

        if 'hypertension' in pathology_codes:
            carbs_pct = min(carbs_pct, 0.45)
            fat_pct = max(fat_pct, 0.35)

        if 'anemia' in pathology_codes:
            protein_pct = max(protein_pct, 0.25)

        if 'muscle_gain' in pathology_codes:
            protein_pct = 0.30
            carbs_pct = 0.45
            fat_pct = 0.25

        if (
            'obesity' in pathology_codes
            or 'overweight' in pathology_codes
        ):
            if self.goal == 'maintain':
                total *= 0.9

        if 'renal' in pathology_codes:
            protein_pct = min(protein_pct, 0.15)
            carbs_pct = 0.55
            fat_pct = 0.30

        self.total_calories = total
        self.protein = (total * protein_pct) / 4
        self.carbs = (total * carbs_pct) / 4
        self.fats = (total * fat_pct) / 9

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.patient.name} - {self.goal}"


class NutritionPlanMenuItem(models.Model):
    nutrition_plan = models.ForeignKey(
        NutritionPlan,
        on_delete=models.CASCADE,
        related_name='menu_items'
    )

    meal_time = models.CharField(max_length=50)
    item_text = models.CharField(max_length=255)
    order = models.IntegerField(default=0)
    option_number = models.IntegerField(default=1)
    active_menu_option = models.IntegerField(default=1)

    def __str__(self):
        return f"{self.meal_time} - {self.item_text}"


class Appointment(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pendiente'),
        ('completed', 'Completada'),
        ('cancelled', 'Cancelada'),
    ]

    patient = models.ForeignKey(
        'Patient',
        on_delete=models.CASCADE,
        related_name='appointments'
    )

    CONSULTATION_TYPE_CHOICES = [
    ('first_time', 'Primera vez'),
    ('follow_up', 'Seguimiento'),
    ('control', 'Control'),
]

    consultation_type = models.CharField(
    max_length=20,
    choices=CONSULTATION_TYPE_CHOICES,
    default='follow_up'
)

    current_weight = models.FloatField(blank=True, null=True)

    next_appointment = models.DateTimeField(blank=True, null=True)

    date = models.DateTimeField()
    notes = models.TextField(blank=True, null=True)

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.patient.name} - {self.date}"