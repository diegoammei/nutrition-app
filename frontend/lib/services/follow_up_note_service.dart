import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class FollowUpNoteService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/follow-up-notes/';

  static Future<List<dynamic>> getNotesByPatient(int patientId) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar notas de seguimiento');
    }
  }

  static Future<void> createNote({
    required int patientId,
    String? evolution,
    String? adherence,
    String? symptoms,
    String? observations,
    String? planChanges,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'patient': patientId,
        'evolution': evolution,
        'adherence': adherence,
        'symptoms': symptoms,
        'observations': observations,
        'plan_changes': planChanges,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al guardar nota de seguimiento');
    }
  }
}