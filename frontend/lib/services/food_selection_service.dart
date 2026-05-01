import 'food_equivalents_service.dart';
import 'dart:math';

class FoodSelectionService {
  static List<String> selectFoodsForGroup({
    required String group,
    required int equivalents,
    String pathology = 'none',
  }) {
    if (equivalents <= 0) return [];

    final random = Random();
    final allFoods = FoodEquivalentsService.foods
        .where(
          (food) =>
              food.group == group &&
              !food.notRecommendedFor.contains(pathology),
        )
        .toList();

    final recommendedFoods =
        allFoods
            .where((food) => food.recommendedFor.contains(pathology))
            .toList()
          ..shuffle(random);

    final otherFoods =
        allFoods
            .where((food) => !food.recommendedFor.contains(pathology))
            .toList()
          ..shuffle(random);

    // Mezclar dando prioridad a recomendados
    final foods = [...recommendedFoods, ...otherFoods];

    if (foods.isEmpty) {
      return ['$equivalents equivalente(s) de $group'];
    }

    return foods
        .take(equivalents)
        .map((food) => '${food.portion} de ${food.name}')
        .toList();
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
