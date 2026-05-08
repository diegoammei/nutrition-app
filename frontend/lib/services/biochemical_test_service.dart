import 'dart:convert';
import 'package:http/http.dart' as http;

class BiochemicalTestService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/biochemical-tests/';

  static Future<List<dynamic>> getTestsByPatient(
    int patientId,
  ) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .where((item) => item['patient'] == patientId)
          .toList();
    } else {
      throw Exception('Error al cargar estudios');
    }
  }

  static Future<void> createTest({
    required int patientId,
    required String date,
    required String testName,
    required String result,
    String? notes,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'patient': patientId,
        'date': date,
        'test_name': testName,
        'result': result,
        'notes': notes,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar estudio');
    }
  }
}