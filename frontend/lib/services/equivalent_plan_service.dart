class EquivalentPlanService {
  static Map<String, int> calculateDailyEquivalents({
    required double calories,
    required List<String> pathologies,
  }) {
    Map<String, int> equivalents;

    if (calories <= 1500) {
      equivalents = {
        'Verduras': 4,
        'Frutas': 2,
        'Cereales': 5,
        'Leguminosas': 1,
        'AOA': 5,
        'Leche': 1,
        'Grasas S/P': 2,
        'Grasas C/P': 1,
      };
    } else if (calories <= 1800) {
      equivalents = {
        'Verduras': 5,
        'Frutas': 3,
        'Cereales': 6,
        'Leguminosas': 1,
        'AOA': 6,
        'Leche': 1,
        'Grasas S/P': 3,
        'Grasas C/P': 1,
      };
    } else if (calories <= 2200) {
      equivalents = {
        'Verduras': 5,
        'Frutas': 3,
        'Cereales': 8,
        'Leguminosas': 1,
        'AOA': 7,
        'Leche': 1,
        'Grasas S/P': 4,
        'Grasas C/P': 1,
      };
    } else {
      equivalents = {
        'Verduras': 6,
        'Frutas': 4,
        'Cereales': 10,
        'Leguminosas': 2,
        'AOA': 8,
        'Leche': 2,
        'Grasas S/P': 5,
        'Grasas C/P': 2,
      };
    }

    if (pathologies.contains('diabetes')) {
      equivalents['Frutas'] = (equivalents['Frutas']! - 1).clamp(1, 99);
      equivalents['Cereales'] = (equivalents['Cereales']! - 1).clamp(3, 99);
      equivalents['Verduras'] = equivalents['Verduras']! + 1;
    }

    if (pathologies.contains('hypertension')) {
      equivalents['Grasas S/P'] = (equivalents['Grasas S/P']! - 1).clamp(1, 99);
      equivalents['Verduras'] = equivalents['Verduras']! + 1;
    }

    if (pathologies.contains('dyslipidemia')) {
      equivalents['Grasas S/P'] = (equivalents['Grasas S/P']! - 1).clamp(1, 99);
      equivalents['Grasas C/P'] = (equivalents['Grasas C/P']! - 1).clamp(0, 99);
      equivalents['Verduras'] = equivalents['Verduras']! + 1;
    }

    if (pathologies.contains('gastritis') || pathologies.contains('colitis')) {
      equivalents['Grasas S/P'] = (equivalents['Grasas S/P']! - 1).clamp(1, 99);
      equivalents['Leguminosas'] = (equivalents['Leguminosas']! - 1).clamp(0, 99);
    }

    if (pathologies.contains('anemia')) {
      equivalents['AOA'] = equivalents['AOA']! + 1;
      equivalents['Verduras'] = equivalents['Verduras']! + 1;
    }

    if (pathologies.contains('muscle_gain')) {
      equivalents['AOA'] = equivalents['AOA']! + 2;
      equivalents['Cereales'] = equivalents['Cereales']! + 1;
    }

    if (pathologies.contains('obesity') || pathologies.contains('overweight')) {
      equivalents['Cereales'] = (equivalents['Cereales']! - 1).clamp(3, 99);
      equivalents['Grasas S/P'] = (equivalents['Grasas S/P']! - 1).clamp(1, 99);
      equivalents['Verduras'] = equivalents['Verduras']! + 1;
    }

    if (pathologies.contains('renal')) {
      equivalents['AOA'] = (equivalents['AOA']! - 2).clamp(2, 99);
      equivalents['Leguminosas'] = 0;
      equivalents['Leche'] = 0;
    }

    return equivalents;
  }

  static Map<String, Map<String, int>> distributeByMeal({
    required Map<String, int> dailyEquivalents,
  }) {
    return {
      'Desayuno': {
        'Frutas': dailyEquivalents['Frutas']! >= 1 ? 1 : 0,
        'Cereales': dailyEquivalents['Cereales']! >= 2 ? 2 : 1,
        'AOA': dailyEquivalents['AOA']! >= 1 ? 1 : 0,
        'Grasas S/P': dailyEquivalents['Grasas S/P']! >= 1 ? 1 : 0,
      },
      'Colación': {
        'Frutas': dailyEquivalents['Frutas']! > 2 ? 1 : 0,
        'Leche': dailyEquivalents['Leche']! >= 1 ? 1 : 0,
      },
      'Comida': {
        'Verduras': dailyEquivalents['Verduras']! >= 2 ? 2 : dailyEquivalents['Verduras']!,
        'Cereales': dailyEquivalents['Cereales']! >= 2 ? 2 : 1,
        'Leguminosas': dailyEquivalents['Leguminosas']! >= 1 ? 1 : 0,
        'AOA': dailyEquivalents['AOA']! >= 3 ? 3 : dailyEquivalents['AOA']!,
        'Grasas S/P': dailyEquivalents['Grasas S/P']! >= 1 ? 1 : 0,
      },
      'Cena': {
        'Verduras': dailyEquivalents['Verduras']! >= 2 ? 2 : dailyEquivalents['Verduras']!,
        'Cereales': dailyEquivalents['Cereales']! >= 1 ? 1 : 0,
        'AOA': dailyEquivalents['AOA']! >= 2 ? 2 : dailyEquivalents['AOA']!,
        'Grasas C/P': dailyEquivalents['Grasas C/P']! >= 1 ? 1 : 0,
      },
    };
  }
}