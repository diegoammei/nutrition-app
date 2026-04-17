import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/appointments/';

  static Future<List<dynamic>> getAppointmentsByPatient(int patientId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.where((item) => item['patient'] == patientId).toList();
    } else {
      throw Exception('Error al cargar citas');
    }
  }

  static Future<void> createAppointment({
    required int patientId,
    required String date,
    String? notes,
    String status = 'pending',
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patient': patientId,
        'date': date,
        'notes': notes,
        'status': status,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear cita');
    }
  }

  static Future<void> deleteAppointment(int appointmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$appointmentId/'),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar cita');
    }
  }
}