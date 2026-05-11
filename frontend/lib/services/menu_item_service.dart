import 'dart:convert';
import 'package:http/http.dart' as http;

class MenuItemService {
  static const String baseUrl =
      'http://127.0.0.1:8001/api/nutrition-plan-menu-items/';

  static const List<String> mealOrder = [
    'Desayuno',
    'Colación mañana',
    'Comida',
    'Colación tarde',
    'Cena',
  ];

  static int _mealIndex(String mealTime) {
    final index = mealOrder.indexOf(mealTime);
    return index == -1 ? 999 : index;
  }

  static Future<List<dynamic>> getMenuItemsByPlan(int nutritionPlanId) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final items = data
          .where((item) => item['nutrition_plan'] == nutritionPlanId)
          .toList();

      items.sort((a, b) {
        final optionA = (a['option_number'] as num?)?.toInt() ?? 1;
        final optionB = (b['option_number'] as num?)?.toInt() ?? 1;

        final optionCompare = optionA.compareTo(optionB);
        if (optionCompare != 0) return optionCompare;

        final mealCompare = _mealIndex(
          a['meal_time'].toString(),
        ).compareTo(_mealIndex(b['meal_time'].toString()));

        if (mealCompare != 0) return mealCompare;

        final orderA = (a['order'] as num?)?.toInt() ?? 0;
        final orderB = (b['order'] as num?)?.toInt() ?? 0;

        return orderA.compareTo(orderB);
      });

      return items;
    } else {
      throw Exception('Error al cargar menú guardado');
    }
  }

  static Future<void> saveMenu({
    required int nutritionPlanId,
    required Map<String, List<String>> menu,
    int optionNumber = 1,
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
          optionNumber: optionNumber,
        );
      }
    }
  }

  static Future<void> saveMenuOptions({
    required int nutritionPlanId,
    required List<Map<String, List<String>>> menus,
  }) async {
    for (int optionIndex = 0; optionIndex < menus.length; optionIndex++) {
      await saveMenu(
        nutritionPlanId: nutritionPlanId,
        menu: menus[optionIndex],
        optionNumber: optionIndex + 1,
      );
    }
  }

  static Future<void> createMenuItem({
    required int nutritionPlanId,
    required String mealTime,
    required String itemText,
    required int order,
    int optionNumber = 1,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nutrition_plan': nutritionPlanId,
        'meal_time': mealTime,
        'item_text': itemText,
        'order': order,
        'option_number': optionNumber,
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
    int optionNumber = 1,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$id/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nutrition_plan': nutritionPlanId,
        'meal_time': mealTime,
        'item_text': itemText,
        'order': order,
        'option_number': optionNumber,
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
