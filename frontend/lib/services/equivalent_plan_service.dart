class EquivalentPlanService {
  static Map<String, int> calculateDailyEquivalents({
    required double calories,
    String pathology = 'none',
  }) {
    if (calories <= 1500) {
      return {
        'Verduras': 4,
        'Frutas': 2,
        'Cereales': 5,
        'Leguminosas': 1,
        'AOA': 5,
        'Leche': 1,
        'Grasas': 3,
      };
    } else if (calories <= 1800) {
      return {
        'Verduras': 5,
        'Frutas': 3,
        'Cereales': 6,
        'Leguminosas': 1,
        'AOA': 6,
        'Leche': 1,
        'Grasas': 4,
      };
    } else if (calories <= 2200) {
      return {
        'Verduras': 5,
        'Frutas': 3,
        'Cereales': 8,
        'Leguminosas': 1,
        'AOA': 7,
        'Leche': 1,
        'Grasas': 5,
      };
    } else {
      return {
        'Verduras': 6,
        'Frutas': 4,
        'Cereales': 10,
        'Leguminosas': 2,
        'AOA': 8,
        'Leche': 2,
        'Grasas': 6,
      };
    }
  }

  static Map<String, Map<String, int>> distributeByMeal({
    required Map<String, int> dailyEquivalents,
  }) {
    return {
      'Desayuno': {
        'Frutas': 1,
        'Cereales': 2,
        'AOA': 1,
        'Grasas': 1,
      },
      'Colación': {
        'Frutas': dailyEquivalents['Frutas']! > 2 ? 1 : 0,
        'Leche': 1,
      },
      'Comida': {
        'Verduras': 2,
        'Cereales': 2,
        'Leguminosas': 1,
        'AOA': 3,
        'Grasas': 1,
      },
      'Cena': {
        'Verduras': 2,
        'Cereales': dailyEquivalents['Cereales']! >= 6 ? 2 : 1,
        'AOA': 2,
        'Grasas': 1,
      },
    };
  }
}