import 'dart:convert';
import 'package:http/http.dart' as http;

class PatientService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/patients/';

  static Future<List<dynamic>> getPatients() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar pacientes');
    }
  }

  static Future<void> createPatient({
    required String name,
    required int age,
    required String gender,
    required String phone,
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'age': age,
        'gender': gender,
        'phone': phone,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear paciente');
    }
  }
}