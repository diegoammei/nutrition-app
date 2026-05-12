import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class NutritionPlanService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/nutrition-plans/';

  static Future<List<dynamic>> getNutritionPlansByPatient(int patientId) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar planes nutricionales');
    }
  }

  static Future<Map<String, dynamic>> createNutritionPlan({
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
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'patient': patientId,
        'weight': weight,
        'height': height,
        'age': age,
        'gender': gender,
        'activity_factor': activityFactor,
        'goal': goal,
        'active_menu_option': 1,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear plan nutricional');
    }

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updateActiveMenuOption({
    required int planId,
    required int activeMenuOption,
  }) async {
    final currentResponse = await http.get(
      Uri.parse('$baseUrl$planId/'),
      headers: await AuthService.getAuthHeaders(),
    );

    if (currentResponse.statusCode != 200) {
      throw Exception('Error al cargar plan nutricional');
    }

    final currentPlan = jsonDecode(currentResponse.body);

    final response = await http.put(
      Uri.parse('$baseUrl$planId/'),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        ...currentPlan,
        'active_menu_option': activeMenuOption,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar opción activa del menú');
    }

    return jsonDecode(response.body);
  }

  static Future<void> deleteNutritionPlan(int planId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$planId/'),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar plan nutricional');
    }
  }
}