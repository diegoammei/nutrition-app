import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuItemService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/nutrition-plan-menu-items/';

  static Future<List<dynamic>> getMenuItemsByPlan(int nutritionPlanId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final items = data
          .where((item) => item['nutrition_plan'] == nutritionPlanId)
          .toList();

      items.sort((a, b) {
        final mealCompare = a['meal_time'].toString().compareTo(
          b['meal_time'].toString(),
        );

        if (mealCompare != 0) return mealCompare;

        return (a['order'] as int).compareTo(b['order'] as int);
      });

      return items;
    } else {
      throw Exception('Error al cargar menú guardado');
    }
  }

  static Future<void> saveMenu({
    required int nutritionPlanId,
    required Map<String, List<String>> menu,
  }) async {
    for (final entry in menu.entries) {
      final mealTime = entry.key;
      final items = entry.value;

      for (int i = 0; i < items.length; i++) {
        await createMenuItem(
          nutritionPlanId: nutritionPlanId,
          mealTime: mealTime,
          itemText: items[i],
          order: i,
        );
      }
    }
  }

  static Future<void> createMenuItem({
    required int nutritionPlanId,
    required String mealTime,
    required String itemText,
    required int order,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nutrition_plan': nutritionPlanId,
        'meal_time': mealTime,
        'item_text': itemText,
        'order': order,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear alimento del menú');
    }
  }

  static Future<void> updateMenuItem({
    required int id,
    required int nutritionPlanId,
    required String mealTime,
    required String itemText,
    required int order,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nutrition_plan': nutritionPlanId,
        'meal_time': mealTime,
        'item_text': itemText,
        'order': order,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar alimento del menú');
    }
  }

  static Future<void> deleteMenuItem(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl$id/'));

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar alimento del menú');
    }
  }
}