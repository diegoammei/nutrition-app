class RecommendationService {
  static String generateRecommendation({
    required String pathology,
    required Map<String, List<String>> menu,
  }) {
    final allFoods = menu.values.expand((items) => items).join(' ').toLowerCase();

    switch (pathology) {
      case 'diabetes':
        return _diabetesRecommendation(allFoods);
      case 'hypertension':
        return _hypertensionRecommendation(allFoods);
      case 'dyslipidemia':
        return _dyslipidemiaRecommendation(allFoods);
      case 'gastritis':
        return _gastritisRecommendation(allFoods);
      case 'colitis':
        return _colitisRecommendation(allFoods);
      case 'anemia':
        return _anemiaRecommendation(allFoods);
      case 'muscle_gain':
        return _muscleGainRecommendation(allFoods);
      case 'malnutrition':
        return _malnutritionRecommendation(allFoods);
      default:
        return 'Mantener alimentación equilibrada, variada y adecuada a los objetivos del paciente.';
    }
  }

  static String _diabetesRecommendation(String foods) {
    final includesLegumes = foods.contains('frijol') || foods.contains('lenteja') || foods.contains('garbanzo');
    final includesOats = foods.contains('avena');
    final includesVegetables = foods.contains('brócoli') || foods.contains('nopal') || foods.contains('espinaca') || foods.contains('lechuga');

    final positives = <String>[];

    if (includesLegumes) positives.add('leguminosas');
    if (includesOats) positives.add('avena');
    if (includesVegetables) positives.add('verduras');

    if (positives.isEmpty) {
      return 'Distribuir los carbohidratos durante el día, priorizar cereales integrales, verduras y evitar bebidas azucaradas.';
    }

    return 'Este plan incluye ${positives.join(', ')}, que ayudan a mejorar la calidad de carbohidratos. Evitar bebidas azucaradas y azúcares refinados.';
  }

  static String _hypertensionRecommendation(String foods) {
    final includesFreshProtein = foods.contains('pollo') || foods.contains('pescado') || foods.contains('atún');
    final includesVegetables = foods.contains('pepino') || foods.contains('lechuga') || foods.contains('nopal') || foods.contains('brócoli');

    if (includesFreshProtein || includesVegetables) {
      return 'Este plan prioriza alimentos frescos como proteína magra y verduras. Evitar embutidos, consomé en polvo y productos altos en sodio.';
    }

    return 'Reducir sodio, evitar embutidos y preferir alimentos frescos preparados en casa.';
  }

  static String _dyslipidemiaRecommendation(String foods) {
    final includesHealthyFats = foods.contains('aguacate') || foods.contains('nuez') || foods.contains('almendra') || foods.contains('aceite de oliva');
    final includesFish = foods.contains('pescado') || foods.contains('atún');

    if (includesHealthyFats || includesFish) {
      return 'Este plan incluye grasas saludables y/o proteína magra. Limitar frituras, crema, mantequilla y embutidos.';
    }

    return 'Priorizar fibra, verduras, grasas saludables y limitar grasas saturadas.';
  }

  static String _gastritisRecommendation(String foods) {
    final includesSoftFoods = foods.contains('avena') || foods.contains('arroz') || foods.contains('papa') || foods.contains('pollo');

    if (includesSoftFoods) {
      return 'Este plan incluye alimentos suaves y de fácil tolerancia. Evitar picante, café, cítricos, alcohol y comidas muy grasosas.';
    }

    return 'Preferir preparaciones suaves, evitar irritantes y ajustar alimentos según tolerancia.';
  }

  static String _colitisRecommendation(String foods) {
    return 'Ajustar fibra según tolerancia individual. Evitar irritantes, exceso de grasa y alimentos que el paciente identifique como detonantes.';
  }

  static String _anemiaRecommendation(String foods) {
    final includesIron = foods.contains('lenteja') || foods.contains('frijol') || foods.contains('espinaca') || foods.contains('hígado');
    final includesVitaminC = foods.contains('guayaba') || foods.contains('naranja') || foods.contains('fresa');

    if (includesIron && includesVitaminC) {
      return 'Este plan combina alimentos fuente de hierro con vitamina C, lo cual puede favorecer la absorción del hierro.';
    }

    if (includesIron) {
      return 'Este plan incluye alimentos fuente de hierro. Se recomienda acompañarlos con una fuente de vitamina C.';
    }

    return 'Priorizar alimentos ricos en hierro y combinarlos con vitamina C.';
  }

  static String _muscleGainRecommendation(String foods) {
    final includesProtein = foods.contains('pollo') || foods.contains('huevo') || foods.contains('atún') || foods.contains('pescado') || foods.contains('yogurt');

    if (includesProtein) {
      return 'Este plan incluye fuentes de proteína útiles para apoyar aumento de masa muscular. Complementar con entrenamiento de fuerza.';
    }

    return 'Asegurar proteína suficiente, energía adecuada y entrenamiento de fuerza progresivo.';
  }

  static String _malnutritionRecommendation(String foods) {
    final includesEnergyDense = foods.contains('aguacate') || foods.contains('nuez') || foods.contains('almendra') || foods.contains('leche') || foods.contains('yogurt');

    if (includesEnergyDense) {
      return 'Este plan incluye alimentos con mayor densidad energética y proteica. Favorecer comidas pequeñas y frecuentes.';
    }

    return 'Aumentar densidad calórica y proteica con preparaciones tolerables y frecuentes.';
  }
}