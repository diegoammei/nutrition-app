class MealBuilderService {
  static Map<String, String> buildReadableMeals(
    Map<String, List<String>> menu,
  ) {
    final Map<String, String> readableMeals = {};

    menu.forEach((meal, foods) {
      final text = foods.join(' ').toLowerCase();

      if (text.contains('huevo') && text.contains('tortilla')) {
        readableMeals[meal] = 'Huevos con tortilla y acompañamiento de fruta o verdura';
      } else if (text.contains('pollo') && text.contains('arroz')) {
        readableMeals[meal] = 'Pollo con arroz y verduras';
      } else if (text.contains('pollo') && text.contains('tostada')) {
        readableMeals[meal] = 'Tostadas con pollo y verduras';
      } else if (text.contains('atún') && text.contains('tostada')) {
        readableMeals[meal] = 'Tostadas de atún con verduras';
      } else if (text.contains('frijol') && text.contains('tortilla')) {
        readableMeals[meal] = 'Tacos o tostadas con frijoles y verduras';
      } else if (text.contains('yogurt') && text.contains('avena')) {
        readableMeals[meal] = 'Yogurt con avena y fruta';
      } else if (text.contains('leche') && text.contains('avena')) {
        readableMeals[meal] = 'Avena preparada con leche';
      } else if (text.contains('pescado') && text.contains('verduras')) {
        readableMeals[meal] = 'Pescado con verduras';
      } else {
        readableMeals[meal] = foods.join(', ');
      }
    });

    return readableMeals;
  }
}