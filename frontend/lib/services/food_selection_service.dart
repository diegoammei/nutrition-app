import 'food_equivalents_service.dart';
import 'dart:math';

class FoodSelectionService {
  static final Random _random = Random();

  static List<String> selectFoodsForGroup({
    required String group,
    required int equivalents,
    required List<String> pathologies,
    Set<String>? usedFoods,
  }) {
    if (equivalents <= 0) return [];

    final allFoods = FoodEquivalentsService.foods
        .where(
          (food) =>
              food.group == group &&
              !pathologies.any(
                (p) => food.notRecommendedFor.contains(p),
              ),
        )
        .toList();

    if (allFoods.isEmpty) {
      return ['$equivalents equivalente(s) de $group'];
    }

    final recommendedFoods = allFoods
        .where(
          (food) => pathologies.any(
            (p) => food.recommendedFor.contains(p),
          ),
        )
        .toList()
      ..shuffle(_random);

    final otherFoods = allFoods
        .where(
          (food) => !pathologies.any(
            (p) => food.recommendedFor.contains(p),
          ),
        )
        .toList()
      ..shuffle(_random);

    final prioritizedFoods = [...recommendedFoods, ...otherFoods];

    final selectedFoods = <FoodEquivalent>[];

    for (final food in prioritizedFoods) {
      if (selectedFoods.length >= equivalents) break;

      if (usedFoods == null || !usedFoods.contains(food.name)) {
        selectedFoods.add(food);
        usedFoods?.add(food.name);
      }
    }

    if (selectedFoods.length < equivalents) {
      for (final food in prioritizedFoods) {
        if (selectedFoods.length >= equivalents) break;

        selectedFoods.add(food);
      }
    }

    return selectedFoods
        .map((food) => '${food.portion} de ${food.name}')
        .toList();
  }

  static Map<String, List<String>> generateFoodMenuFromDistribution({
    required Map<String, Map<String, int>> mealDistribution,
    required List<String> pathologies,
  }) {
    final Map<String, List<String>> menu = {};
    final usedFoods = <String>{};

    mealDistribution.forEach((meal, groups) {
      final List<String> mealFoods = [];

      groups.forEach((group, equivalents) {
        final foods = selectFoodsForGroup(
          group: group,
          equivalents: equivalents,
          pathologies: pathologies,
          usedFoods: usedFoods,
        );

        mealFoods.addAll(foods);
      });

      menu[meal] = mealFoods;
    });

    return menu;
  }
}