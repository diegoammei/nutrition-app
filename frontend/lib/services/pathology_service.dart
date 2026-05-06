import 'dart:convert';
import 'package:http/http.dart' as http;

class PathologyService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/pathologies/';

  static Future<List<dynamic>> getPathologies() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al cargar patologías');
    }
  }
}