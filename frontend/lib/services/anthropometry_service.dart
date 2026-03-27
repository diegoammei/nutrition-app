import 'dart:convert';
import 'package:http/http.dart' as http;

class AnthropometryService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/anthropometries/';

  static Future<List<dynamic>> getAnthropometriesByPatient(int patientId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar antropometría');
    }
  }

  static Future<void> createAnthropometry({
    required int patientId,
    required double weight,
    required double height,
    double? waist,
    double? hip,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient': patientId,
        'weight': weight,
        'height': height,
        'waist': waist,
        'hip': hip,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar antropometría');
    }
  }
}