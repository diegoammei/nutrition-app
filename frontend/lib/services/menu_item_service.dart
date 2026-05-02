import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuItemService {
  static const String baseUrl = 'http://127.0.0.1:8001/api/nutrition-plan-menu-items/';

  static Future<void> saveMenu({
    required int nutritionPlanId,
    required Map<String, List<String>> menu,
  }) async {
    for (final entry in menu.entries) {
      final mealTime = entry.key;
      final items = entry.value;

      for (int i = 0; i < items.length; i++) {
        final response = await http.post(
          Uri.parse(baseUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nutrition_plan': nutritionPlanId,
            'meal_time': mealTime,
            'item_text': items[i],
            'order': i,
          }),
        );

        if (response.statusCode != 201) {
          throw Exception('Error guardando menú');
        }
      }
    }
  }
}