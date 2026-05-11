import 'food_equivalents_service.dart';
import 'dart:math';

class FoodSelectionService {
  static final Random _random = Random();

  static const List<String> mealOrder = [
    'Desayuno',
    'Colación mañana',
    'Comida',
    'Colación tarde',
    'Cena',
  ];

  static List<String> selectFoodsForGroup({
    required String group,
    required int equivalents,
    required List<String> pathologies,
    Set<String>? usedFoodsInMenu,
    Set<String>? usedFoodsAcrossMenus,
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

      final alreadyUsedInMenu =
          usedFoodsInMenu != null && usedFoodsInMenu.contains(food.name);

      final alreadyUsedAcrossMenus =
          usedFoodsAcrossMenus != null && usedFoodsAcrossMenus.contains(food.name);

      if (!alreadyUsedInMenu && !alreadyUsedAcrossMenus) {
        selectedFoods.add(food);
        usedFoodsInMenu?.add(food.name);
        usedFoodsAcrossMenus?.add(food.name);
      }
    }

    if (selectedFoods.length < equivalents) {
      for (final food in prioritizedFoods) {
        if (selectedFoods.length >= equivalents) break;

        final alreadyUsedInMenu =
            usedFoodsInMenu != null && usedFoodsInMenu.contains(food.name);

        if (!alreadyUsedInMenu) {
          selectedFoods.add(food);
          usedFoodsInMenu?.add(food.name);
        }
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
    Set<String>? usedFoodsAcrossMenus,
  }) {
    final Map<String, List<String>> menu = {};
    final usedFoodsInMenu = <String>{};

    for (final meal in mealOrder) {
      final groups = mealDistribution[meal];

      if (groups == null) {
        menu[meal] = [];
        continue;
      }

      final List<String> mealFoods = [];

      groups.forEach((group, equivalents) {
        final foods = selectFoodsForGroup(
          group: group,
          equivalents: equivalents,
          pathologies: pathologies,
          usedFoodsInMenu: usedFoodsInMenu,
          usedFoodsAcrossMenus: usedFoodsAcrossMenus,
        );

        mealFoods.addAll(foods);
      });

      menu[meal] = mealFoods;
    }

    return menu;
  }

  static List<Map<String, List<String>>> generateMenuOptions({
    required Map<String, Map<String, int>> mealDistribution,
    required List<String> pathologies,
    int optionsCount = 3,
  }) {
    final usedFoodsAcrossMenus = <String>{};

    return List.generate(optionsCount, (_) {
      return generateFoodMenuFromDistribution(
        mealDistribution: mealDistribution,
        pathologies: pathologies,
        usedFoodsAcrossMenus: usedFoodsAcrossMenus,
      );
    });
  }
}
