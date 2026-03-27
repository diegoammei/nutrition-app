from django.db import models


class Patient(models.Model):
    name = models.CharField(max_length=255)
    age = models.IntegerField()
    gender = models.CharField(max_length=10)
    phone = models.CharField(max_length=20)
    email = models.EmailField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name


class Anthropometry(models.Model):
    patient = models.ForeignKey('Patient', on_delete=models.CASCADE, related_name='anthropometries')
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
            self.body_mass_index = self.weight / ((self.height / 100) ** 2)
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

    patient = models.ForeignKey('Patient', on_delete=models.CASCADE, related_name='nutrition_plans')
    weight = models.FloatField()
    height = models.FloatField()
    age = models.IntegerField()
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES)
    activity_factor = models.FloatField(choices=ACTIVITY_FACTOR_CHOICES)
    goal = models.CharField(max_length=20, choices=GOAL_CHOICES)

    total_calories = models.FloatField(blank=True, null=True)
    protein = models.FloatField(blank=True, null=True)
    carbs = models.FloatField(blank=True, null=True)
    fats = models.FloatField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if self.gender.lower() == 'male':
            bmr = (10 * self.weight) + (6.25 * self.height) - (5 * self.age) + 5
        else:
            bmr = (10 * self.weight) + (6.25 * self.height) - (5 * self.age) - 161

        total = bmr * self.activity_factor

        if self.goal == 'deficit':
            total *= 0.8
        elif self.goal == 'superavit':
            total *= 1.2

        self.total_calories = total
        self.protein = (total * 0.20) / 4
        self.carbs = (total * 0.50) / 4
        self.fats = (total * 0.30) / 9

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.patient.name} - {self.goal}"