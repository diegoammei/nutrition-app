class RecommendationService {
  static String generateRecommendation({
    required List<String> pathologies,
    required Map<String, List<String>> menu,
  }) {
    final recommendations = <String>[];

    if (pathologies.isEmpty) {
      recommendations.add(
        'Mantener una alimentación equilibrada, respetar horarios de comida y consumir suficiente agua durante el día.',
      );
    }

    if (pathologies.contains('diabetes')) {
      recommendations.add(
        'Diabetes: priorizar cereales integrales, verduras y frutas con moderación. Evitar bebidas azucaradas, postres, jugos y harinas refinadas.',
      );
    }

    if (pathologies.contains('hypertension')) {
      recommendations.add(
        'Hipertensión: reducir sal, embutidos, enlatados, sopas instantáneas, comida rápida y productos ultraprocesados.',
      );
    }

    if (pathologies.contains('dyslipidemia')) {
      recommendations.add(
        'Dislipidemia: preferir grasas saludables como aguacate, aceite de oliva, nueces y pescado. Evitar frituras, mantequilla, crema y carnes grasosas.',
      );
    }

    if (pathologies.contains('gastritis')) {
      recommendations.add(
        'Gastritis: evitar picante, café, alcohol, cítricos, irritantes y comidas muy grasosas.',
      );
    }

    if (pathologies.contains('colitis')) {
      recommendations.add(
        'Colitis: ajustar fibra según tolerancia, evitar irritantes, exceso de grasa, picante y alimentos que produzcan gases.',
      );
    }

    if (pathologies.contains('anemia')) {
      recommendations.add(
        'Anemia: incluir alimentos ricos en hierro como leguminosas, verduras verdes, carnes magras y combinarlos con vitamina C cuando sea tolerado.',
      );
    }

    if (pathologies.contains('obesity')) {
      recommendations.add(
        'Obesidad: cuidar porciones, priorizar verduras, proteínas magras y evitar bebidas azucaradas, pan dulce, frituras y exceso de cereales.',
      );
    }

    if (pathologies.contains('overweight')) {
      recommendations.add(
        'Sobrepeso: mantener déficit moderado, aumentar verduras y elegir preparaciones asadas, cocidas o al vapor.',
      );
    }

    if (pathologies.contains('renal')) {
      recommendations.add(
        'Insuficiencia renal: individualizar proteína, sodio, potasio y fósforo según indicación médica y estudios de laboratorio.',
      );
    }

    if (pathologies.contains('cancer')) {
      recommendations.add(
        'Cáncer: adaptar la alimentación a tolerancia, apetito, tratamiento y síntomas. Priorizar energía y proteína cuando sea necesario.',
      );
    }

    if (pathologies.contains('malnutrition')) {
      recommendations.add(
        'Desnutrición: aumentar densidad calórica y proteica con preparaciones pequeñas pero frecuentes.',
      );
    }

    if (pathologies.contains('muscle_gain')) {
      recommendations.add(
        'Aumento de masa muscular: asegurar suficiente proteína, energía total y acompañar con entrenamiento de fuerza.',
      );
    }

    return recommendations.join('\n\n');
  }
}