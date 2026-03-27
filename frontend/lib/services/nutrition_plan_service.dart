import 'dart:convert';
import 'package:http/http.dart' as http;

class NutritionPlanService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/nutrition-plans/';

  // 👇 ESTE YA LO TENÍAS
  static Future<List<dynamic>> getNutritionPlansByPatient(int patientId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar planes nutricionales');
    }
  }

    static Future<void> createNutritionPlan({
    required int patientId,
    required double weight,
    required double height,
    required int age,
    required String gender,
    required double activityFactor,
    required String goal,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient': patientId,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'activity_factor': activityFactor,
        'goal': goal,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear plan nutricional');
    }
  }
}