class RecommendationService {
  static String generateRecommendation({
    required String pathology,
    required Map<String, List<String>> menu,
  }) {
    switch (pathology) {
      case 'diabetes':
        return _diabetesRecommendation(menu);
      case 'hypertension':
        return _hypertensionRecommendation(menu);
      case 'dyslipidemia':
        return _dyslipidemiaRecommendation(menu);
      case 'gastritis':
        return _gastritisRecommendation(menu);
      case 'colitis':
        return _colitisRecommendation(menu);
      case 'anemia':
        return _anemiaRecommendation(menu);
      case 'muscle_gain':
        return _muscleGainRecommendation(menu);
      case 'malnutrition':
        return _malnutritionRecommendation(menu);
      default:
        return 'Mantener alimentación equilibrada y variada.';
    }
  }

  static String _diabetesRecommendation(Map<String, List<String>> menu) {
    return 'Este plan prioriza alimentos con menor índice glucémico como verduras, leguminosas y cereales integrales. Evitar azúcares y refinados.';
  }

  static String _hypertensionRecommendation(Map<String, List<String>> menu) {
    return 'Se priorizan alimentos frescos y bajos en sodio. Evitar embutidos y productos procesados.';
  }

  static String _dyslipidemiaRecommendation(Map<String, List<String>> menu) {
    return 'Se favorecen alimentos bajos en grasa saturada. Evitar mantequilla, crema y alimentos fritos.';
  }

  static String _gastritisRecommendation(Map<String, List<String>> menu) {
    return 'Se incluyen alimentos suaves y de fácil digestión. Evitar irritantes, cítricos y picante.';
  }

  static String _colitisRecommendation(Map<String, List<String>> menu) {
    return 'Se seleccionan alimentos no irritantes y de fácil digestión. Ajustar según tolerancia individual.';
  }

  static String _anemiaRecommendation(Map<String, List<String>> menu) {
    return 'Se priorizan alimentos ricos en hierro como leguminosas y verduras verdes. Acompañar con vitamina C.';
  }

  static String _muscleGainRecommendation(Map<String, List<String>> menu) {
    return 'Se favorece el consumo de proteína y energía para apoyar el aumento de masa muscular.';
  }

  static String _malnutritionRecommendation(Map<String, List<String>> menu) {
    return 'Se incrementa la densidad calórica y proteica para mejorar el estado nutricional.';
  }
}