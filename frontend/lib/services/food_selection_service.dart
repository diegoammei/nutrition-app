import 'food_equivalents_service.dart';

class FoodSelectionService {
  static List<String> selectFoodsForGroup({
    required String group,
    required int equivalents,
    String pathology = 'none',
  }) {
    if (equivalents <= 0) return [];

    final foods = FoodEquivalentsService.foods
        .where((food) => food.group == group)
        .toList();

    if (foods.isEmpty) {
      return ['$equivalents equivalente(s) de $group'];
    }

    return List.generate(equivalents, (index) {
      final food = foods[index % foods.length];
      return '${food.portion} de ${food.name}';
    });
  }

  static Map<String, List<String>> generateFoodMenuFromDistribution({
    required Map<String, Map<String, int>> mealDistribution,
    String pathology = 'none',
  }) {
    final Map<String, List<String>> menu = {};

    mealDistribution.forEach((meal, groups) {
      final List<String> mealFoods = [];

      groups.forEach((group, equivalents) {
        final foods = selectFoodsForGroup(
          group: group,
          equivalents: equivalents,
          pathology: pathology,
        );

        mealFoods.addAll(foods);
      });

      menu[meal] = mealFoods;
    });

    return menu;
  }
}