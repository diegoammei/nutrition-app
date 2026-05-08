import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionHistoryService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/nutrition-histories/';

  static Future<List<dynamic>> getHistoriesByPatient(int patientId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar historia nutricional');
    }
  }

  static Future<void> createHistory({
    required int patientId,
    String? consultationReason,
    bool familyDiabetes = false,
    bool familyObesity = false,
    bool familyCancer = false,
    bool familyHypertension = false,
    bool familyThyroid = false,
    String? familyOther,
    String? previousConditions,
    String? currentCondition,
    String? currentMedications,
    String? supplements,
    String? appetite,
    int? mealsPerDay,
    bool regularSchedule = false,
    String? avoidedFoods,
    String? avoidedFoodsReason,
    String? foodAllergies,
    bool smokes = false,
    String? smokingQuantity,
    bool drinksAlcohol = false,
    String? alcoholQuantity,
    String? recallBreakfast,
    String? recallMorningSnack,
    String? recallLunch,
    String? recallAfternoonSnack,
    String? recallDinner,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient': patientId,
        'consultation_reason': consultationReason,
        'family_diabetes': familyDiabetes,
        'family_obesity': familyObesity,
        'family_cancer': familyCancer,
        'family_hypertension': familyHypertension,
        'family_thyroid': familyThyroid,
        'family_other': familyOther,
        'previous_conditions': previousConditions,
        'current_condition': currentCondition,
        'current_medications': currentMedications,
        'supplements': supplements,
        'appetite': appetite,
        'meals_per_day': mealsPerDay,
        'regular_schedule': regularSchedule,
        'avoided_foods': avoidedFoods,
        'avoided_foods_reason': avoidedFoodsReason,
        'food_allergies': foodAllergies,
        'smokes': smokes,
        'smoking_quantity': smokingQuantity,
        'drinks_alcohol': drinksAlcohol,
        'alcohol_quantity': alcoholQuantity,
        'recall_breakfast': recallBreakfast,
        'recall_morning_snack': recallMorningSnack,
        'recall_lunch': recallLunch,
        'recall_afternoon_snack': recallAfternoonSnack,
        'recall_dinner': recallDinner,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar historia nutricional');
    }
  }

  static Future<void> updateHistory({
    required int id,
    required int patientId,
    String? consultationReason,
    bool familyDiabetes = false,
    bool familyObesity = false,
    bool familyCancer = false,
    bool familyHypertension = false,
    bool familyThyroid = false,
    String? previousConditions,
    String? currentCondition,
    String? recallBreakfast,
    String? recallMorningSnack,
    String? recallLunch,
    String? recallAfternoonSnack,
    String? recallDinner,
    String? currentMedications,
    String? supplements,
    String? foodAllergies,
    String? avoidedFoods,
    String? avoidedFoodsReason,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient': patientId,
        'consultation_reason': consultationReason,
        'family_diabetes': familyDiabetes,
        'family_obesity': familyObesity,
        'family_cancer': familyCancer,
        'family_hypertension': familyHypertension,
        'family_thyroid': familyThyroid,
        'previous_conditions': previousConditions,
        'current_condition': currentCondition,
        'recall_breakfast': recallBreakfast,
        'recall_morning_snack': recallMorningSnack,
        'recall_lunch': recallLunch,
        'recall_afternoon_snack': recallAfternoonSnack,
        'recall_dinner': recallDinner,
        'current_medications': currentMedications,
        'supplements': supplements,
        'food_allergies': foodAllergies,
        'avoided_foods': avoidedFoods,
        'avoided_foods_reason': avoidedFoodsReason,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar historia nutricional');
    }
  }
}
