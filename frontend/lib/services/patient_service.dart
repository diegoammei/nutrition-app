import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class PatientService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/patients/';

  static Future<List<dynamic>> getPatients() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar pacientes');
    }
  }

  static Future<void> createPatient({
    required String name,
    required int age,
    required double height,
    required String gender,
    required String phone,
    required String email,
    required List<int> pathologies,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'name': name,
        'age': age,
        'height': height,
        'gender': gender,
        'phone': phone,
        'email': email,
        'pathology': pathologies,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear paciente');
    }
  }

  static Future<void> updatePatient({
    required int id,
    required String name,
    required int age,
    required double height,
    required String gender,
    required String phone,
    required String email,
    required List<int> pathologies,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'name': name,
        'age': age,
        'height': height,
        'gender': gender,
        'phone': phone,
        'email': email,
        'pathology': pathologies,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar paciente');
    }
  }

  static Future<void> deletePatient(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$id/'),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar paciente');
    }
  }
}