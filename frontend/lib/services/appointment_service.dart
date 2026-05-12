import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class AppointmentService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/appointments/';

  static Future<List<dynamic>> getAppointmentsByPatient(int patientId) async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final appointments = data
          .where((item) => item['patient'] == patientId)
          .toList();

      appointments.sort((a, b) {
        final dateA = DateTime.tryParse(a['date'] ?? '');
        final dateB = DateTime.tryParse(b['date'] ?? '');

        if (dateA == null || dateB == null) return 0;

        return dateB.compareTo(dateA);
      });

      return appointments;
    } else {
      throw Exception('Error al cargar citas');
    }
  }

  static Future<void> createAppointment({
    required int patientId,
    required String date,
    String? notes,
    String status = 'pending',
    String consultationType = 'follow_up',
    double? currentWeight,
    String? nextAppointment,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'patient': patientId,
        'date': date,
        'notes': notes,
        'status': status,
        'consultation_type': consultationType,
        'current_weight': currentWeight,
        'next_appointment': nextAppointment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear cita');
    }
  }

  static Future<void> updateAppointment({
    required int appointmentId,
    required int patientId,
    required String date,
    String? notes,
    String status = 'pending',
    String consultationType = 'follow_up',
    double? currentWeight,
    String? nextAppointment,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$appointmentId/'),
      headers: await AuthService.getAuthHeaders(),
      body: jsonEncode({
        'patient': patientId,
        'date': date,
        'notes': notes,
        'status': status,
        'consultation_type': consultationType,
        'current_weight': currentWeight,
        'next_appointment': nextAppointment,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cita');
    }
  }

  static Future<void> deleteAppointment(int appointmentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$appointmentId/'),
      headers: await AuthService.getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar cita');
    }
  }
}