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
    final remaining = Map<String, int>.from(dailyEquivalents);

    int take(String group, int amount) {
      final available = remaining[group] ?? 0;
      final selected = available >= amount ? amount : available;
      remaining[group] = available - selected;
      return selected;
    }

    final distribution = <String, Map<String, int>>{
      'Desayuno': {
        'Frutas': take('Frutas', 1),
        'Cereales': take('Cereales', 2),
        'AOA': take('AOA', 1),
        'Grasas S/P': take('Grasas S/P', 1),
      },
      'Colación mañana': {
        'Frutas': take('Frutas', 1),
        'Leche': take('Leche', 1),
      },
      'Comida': {
        'Verduras': take('Verduras', 2),
        'Cereales': take('Cereales', 2),
        'Leguminosas': take('Leguminosas', 1),
        'AOA': take('AOA', 3),
        'Grasas S/P': take('Grasas S/P', 1),
      },
      'Colación tarde': {
        'Frutas': take('Frutas', 1),
        'Cereales': take('Cereales', 1),
        'Grasas S/P': take('Grasas S/P', 1),
      },
      'Cena': {
        'Verduras': take('Verduras', 2),
        'Cereales': take('Cereales', 1),
        'AOA': take('AOA', 2),
        'Grasas C/P': take('Grasas C/P', 1),
      },
    };

    final leftoversToMeal = {
      'Verduras': 'Comida',
      'Frutas': 'Colación tarde',
      'Cereales': 'Cena',
      'Leguminosas': 'Comida',
      'AOA': 'Comida',
      'Leche': 'Colación mañana',
      'Grasas S/P': 'Cena',
      'Grasas C/P': 'Cena',
    };

    remaining.forEach((group, amount) {
      if (amount <= 0) return;

      final meal = leftoversToMeal[group] ?? 'Comida';
      distribution[meal]![group] = (distribution[meal]![group] ?? 0) + amount;
    });

    distribution.updateAll((meal, groups) {
      groups.removeWhere((group, amount) => amount <= 0);
      return groups;
    });

    return distribution;
  }
}
