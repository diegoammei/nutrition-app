// Reglas generales por patología:
//
// diabetes: evitar azúcares y refinados
// hypertension: evitar sodio y procesados
// dyslipidemia: evitar grasas saturadas
// gastritis: evitar irritantes, cítricos y picante
// colitis: evitar irritantes y grasas pesadas
// anemia: priorizar hierro (no restringir)
// cancer: individualizar según tolerancia
// malnutrition: aumentar calorías
// muscle_gain: aumentar proteína y energía
// obesity: priorizar alimentos con mayor volumen y menor densidad energética
// overweight: priorizar alimentos con mayor volumen y menor densidad energética
// renal: individualizar según etapa, laboratorios y restricción médica

class FoodRecommendationRules {
  static List<String> recommendedFor(String name, String group) {
    final food = name.toLowerCase();

    if (group == 'Verduras') {
      return [
        'diabetes',
        'hypertension',
        'dyslipidemia',
        'obesity',
        'overweight',
      ];
    }

    if (food.contains('avena') || food.contains('pan integral')) {
      return ['diabetes', 'dyslipidemia', 'obesity', 'overweight'];
    }

    if (food.contains('manzana') ||
        food.contains('pera') ||
        food.contains('papaya') ||
        food.contains('melón') ||
        food.contains('fresa') ||
        food.contains('guayaba')) {
      return ['diabetes', 'obesity', 'overweight', 'anemia'];
    }

    if (food.contains('frijol') ||
        food.contains('lenteja') ||
        food.contains('garbanzo') ||
        food.contains('soya')) {
      return ['diabetes', 'dyslipidemia', 'anemia'];
    }

    if (food.contains('pescado') ||
        food.contains('atún') ||
        food.contains('camarón')) {
      return ['dyslipidemia', 'hypertension', 'obesity', 'overweight'];
    }

    if (food.contains('pollo') ||
        food.contains('claras') ||
        food.contains('huevo')) {
      return ['muscle_gain', 'obesity', 'overweight', 'anemia'];
    }

    if (food.contains('leche descremada') ||
        food.contains('yogurt natural') ||
        food.contains('yogurt griego')) {
      return ['muscle_gain', 'malnutrition'];
    }

    if (food.contains('aceite de oliva') ||
        food.contains('aguacate') ||
        food.contains('nuez') ||
        food.contains('almendra') ||
        food.contains('cacahuate') ||
        food.contains('pistache')) {
      return ['dyslipidemia', 'malnutrition'];
    }

    return [];
  }
}

class FoodEquivalent {
  final String name;
  final String group;
  final String portion;
  final double carbs;
  final double protein;
  final double fat;
  final double calories;

  final List<String> notRecommendedFor;
  final List<String> recommendedFor;

  FoodEquivalent({
    required this.name,
    required this.group,
    required this.portion,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.calories,
    this.notRecommendedFor = const [],
    List<String>? recommendedFor,
  }) : recommendedFor =
           recommendedFor ??
           FoodRecommendationRules.recommendedFor(name, group);
}

class FoodEquivalentsService {
  static final List<FoodEquivalent> foods = [
    // FRUTAS
    FoodEquivalent(
      name: 'Plátano',
      group: 'Frutas',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Plátano macho',
      group: 'Frutas',
      portion: '1/4 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['diabetes'],
    ),
    FoodEquivalent(
      name: 'Manzana',
      group: 'Frutas',
      portion: '1 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Ciruela pasa',
      group: 'Frutas',
      portion: '7 piezas',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['diabetes'],
    ),
    FoodEquivalent(
      name: 'Mango',
      group: 'Frutas',
      portion: '1 taza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['diabetes'],
    ),
    FoodEquivalent(
      name: 'Limón',
      group: 'Frutas',
      portion: '4 piezas',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['gastritis'],
    ),
    FoodEquivalent(
      name: 'Pera',
      group: 'Frutas',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Papaya',
      group: 'Frutas',
      portion: '1 taza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Melón',
      group: 'Frutas',
      portion: '1 taza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Piña',
      group: 'Frutas',
      portion: '1 rebanada',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Uvas',
      group: 'Frutas',
      portion: '15 piezas',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Naranja',
      group: 'Frutas',
      portion: '2 piezas',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['gastritis'],
    ),
    FoodEquivalent(
      name: 'Toronja',
      group: 'Frutas',
      portion: '1 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
      notRecommendedFor: ['gastritis'],
    ),
    FoodEquivalent(
      name: 'Guayaba',
      group: 'Frutas',
      portion: '3 piezas',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Fresa',
      group: 'Frutas',
      portion: '1 taza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),

    // CEREALES
    FoodEquivalent(
      name: 'Pasta cocida',
      group: 'Cereales',
      portion: '1/2 taza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),

    FoodEquivalent(
      name: 'Elote',
      group: 'Cereales',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Pan integral',
      group: 'Cereales',
      portion: '1 rebanada',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Pan dulce',
      group: 'Cereales',
      portion: '1/3 pieza',
      carbs: 15,
      protein: 2,
      fat: 5,
      calories: 115,
      notRecommendedFor: ['diabetes', 'dyslipidemia'],
    ),
    FoodEquivalent(
      name: 'Tortilla de maíz',
      group: 'Cereales',
      portion: '1 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Bolillo o telera',
      group: 'Cereales',
      portion: '1/3 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Cereal sin azúcar',
      group: 'Cereales',
      portion: '1/2 taza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
      notRecommendedFor: ['diabetes'],
    ),
    FoodEquivalent(
      name: 'Tortilla de harina',
      group: 'Cereales',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Arroz cocido',
      group: 'Cereales',
      portion: '1/2 taza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Avena',
      group: 'Cereales',
      portion: '3 cucharadas',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Papa cocida',
      group: 'Cereales',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Tostada horneada',
      group: 'Cereales',
      portion: '1 pieza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Salmas horneadas',
      group: 'Cereales',
      portion: '1 paquete',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),

    // VERDURAS
    FoodEquivalent(
      name: 'Brócoli',
      group: 'Verduras',
      portion: '1 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Calabacita',
      group: 'Verduras',
      portion: '1 pieza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Cebolla',
      group: 'Verduras',
      portion: '1/2 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Champiñón',
      group: 'Verduras',
      portion: '1 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Chayote',
      group: 'Verduras',
      portion: '1/2 pieza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Espinaca',
      group: 'Verduras',
      portion: '2 tazas',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Nopal cocido',
      group: 'Verduras',
      portion: '1 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Jitomate',
      group: 'Verduras',
      portion: '1 pieza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Chile habanero o jalapeño',
      group: 'Verduras',
      portion: '6 piezas',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
      notRecommendedFor: ['gastritis', 'colitis'],
    ),
    FoodEquivalent(
      name: 'Salsa mexicana',
      group: 'Verduras',
      portion: '1/2 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
      notRecommendedFor: ['gastritis', 'colitis'],
    ),
    FoodEquivalent(
      name: 'Lechuga',
      group: 'Verduras',
      portion: '3 tazas',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),
    FoodEquivalent(
      name: 'Puré de tomate',
      group: 'Verduras',
      portion: '1/4 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
      notRecommendedFor: ['gastritis'],
    ),
    FoodEquivalent(
      name: 'Pepino',
      group: 'Verduras',
      portion: '1 1/2 taza',
      carbs: 4,
      protein: 2,
      fat: 0,
      calories: 25,
    ),

    // LEGUMINOSAS
    FoodEquivalent(
      name: 'Frijoles negros',
      group: 'Leguminosas',
      portion: '1/2 taza',
      carbs: 20,
      protein: 8,
      fat: 1,
      calories: 120,
    ),
    FoodEquivalent(
      name: 'Frijoles cocidos',
      group: 'Leguminosas',
      portion: '1/2 taza',
      carbs: 20,
      protein: 8,
      fat: 1,
      calories: 120,
    ),
    FoodEquivalent(
      name: 'Frijoles molidos',
      group: 'Leguminosas',
      portion: '1/3 taza',
      carbs: 20,
      protein: 8,
      fat: 1,
      calories: 120,
    ),
    FoodEquivalent(
      name: 'Lentejas cocidas',
      group: 'Leguminosas',
      portion: '1/2 taza',
      carbs: 20,
      protein: 9,
      fat: 1,
      calories: 120,
    ),
    FoodEquivalent(
      name: 'Garbanzos cocidos',
      group: 'Leguminosas',
      portion: '1/2 taza',
      carbs: 20,
      protein: 8,
      fat: 1,
      calories: 120,
    ),
    FoodEquivalent(
      name: 'Soya cocida',
      group: 'Leguminosas',
      portion: '1/3 taza',
      carbs: 20,
      protein: 8,
      fat: 1,
      calories: 120,
    ),

    // AOA
    FoodEquivalent(
      name: 'Molida de res',
      group: 'AOA',
      portion: '30 g',
      carbs: 0,
      protein: 7,
      fat: 5,
      calories: 75,
      notRecommendedFor: ['dyslipidemia', 'gastritis'],
    ),
    FoodEquivalent(
      name: 'Jamón',
      group: 'AOA',
      portion: '2 rebanadas',
      carbs: 0,
      protein: 7,
      fat: 3,
      calories: 55,
      notRecommendedFor: [
        'hypertension',
        'dyslipidemia',
        'gastritis',
        'colitis',
      ],
    ),
    FoodEquivalent(
      name: 'Salchicha',
      group: 'AOA',
      portion: '1 pieza',
      carbs: 0,
      protein: 7,
      fat: 5,
      calories: 75,
      notRecommendedFor: [
        'hypertension',
        'dyslipidemia',
        'gastritis',
        'colitis',
      ],
    ),
    FoodEquivalent(
      name: 'Filete de pescado',
      group: 'AOA',
      portion: '40 g',
      carbs: 0,
      protein: 7,
      fat: 1,
      calories: 40,
    ),
    FoodEquivalent(
      name: 'Queso panela o fresco',
      group: 'AOA',
      portion: '40 g',
      carbs: 0,
      protein: 7,
      fat: 3,
      calories: 55,
    ),
    FoodEquivalent(
      name: 'Huevo',
      group: 'AOA',
      portion: '1 pieza',
      carbs: 0,
      protein: 6,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Claras de huevo',
      group: 'AOA',
      portion: '2 piezas',
      carbs: 0,
      protein: 7,
      fat: 0,
      calories: 35,
    ),
    FoodEquivalent(
      name: 'Filete de pollo',
      group: 'AOA',
      portion: '60 g',
      carbs: 0,
      protein: 14,
      fat: 2,
      calories: 75,
    ),
    FoodEquivalent(
      name: 'Pechuga de pollo',
      group: 'AOA',
      portion: '30 g',
      carbs: 0,
      protein: 7,
      fat: 1,
      calories: 40,
    ),
    FoodEquivalent(
      name: 'Atún',
      group: 'AOA',
      portion: '35 g',
      carbs: 0,
      protein: 7,
      fat: 1,
      calories: 40,
    ),
    FoodEquivalent(
      name: 'Requesón',
      group: 'AOA',
      portion: '3 cucharadas',
      carbs: 0,
      protein: 7,
      fat: 3,
      calories: 55,
    ),
    FoodEquivalent(
      name: 'Camarón',
      group: 'AOA',
      portion: '5 piezas',
      carbs: 0,
      protein: 7,
      fat: 1,
      calories: 40,
    ),

    // LECHE
    FoodEquivalent(
      name: 'Leche semidescremada',
      group: 'Leche',
      portion: '1 taza',
      carbs: 12,
      protein: 8,
      fat: 3,
      calories: 110,
    ),

    FoodEquivalent(
      name: 'Leche deslactosada',
      group: 'Leche',
      portion: '1 taza',
      carbs: 12,
      protein: 8,
      fat: 0,
      calories: 90,
    ),

    FoodEquivalent(
      name: 'Yogurt light',
      group: 'Leche',
      portion: '1 taza',
      carbs: 12,
      protein: 8,
      fat: 1,
      calories: 80,
    ),
    FoodEquivalent(
      name: 'Leche descremada',
      group: 'Leche',
      portion: '1 taza',
      carbs: 12,
      protein: 8,
      fat: 0,
      calories: 90,
    ),
    FoodEquivalent(
      name: 'Yogurt natural',
      group: 'Leche',
      portion: '1 taza',
      carbs: 12,
      protein: 8,
      fat: 2,
      calories: 100,
    ),
    FoodEquivalent(
      name: 'Yogurt griego natural',
      group: 'Leche',
      portion: '1 pieza',
      carbs: 12,
      protein: 8,
      fat: 2,
      calories: 100,
    ),

    // GRASAS SIN PROTEÍNA
    FoodEquivalent(
      name: 'Aceite de oliva',
      group: 'Grasas S/P',
      portion: '1 cucharadita',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
    ),
    FoodEquivalent(
      name: 'Crema',
      group: 'Grasas S/P',
      portion: '1 cucharada',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
      notRecommendedFor: ['dyslipidemia', 'gastritis', 'colitis'],
    ),
    FoodEquivalent(
      name: 'Mayonesa',
      group: 'Grasas S/P',
      portion: '1 cucharadita',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
      notRecommendedFor: [
        'hypertension',
        'dyslipidemia',
        'gastritis',
        'colitis',
      ],
    ),
    FoodEquivalent(
      name: 'Mantequilla',
      group: 'Grasas S/P',
      portion: '1 1/2 cucharaditas',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
      notRecommendedFor: [
        'hypertension',
        'dyslipidemia',
        'gastritis',
        'colitis',
      ],
    ),
    FoodEquivalent(
      name: 'Queso crema',
      group: 'Grasas S/P',
      portion: '1 cucharada',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
      notRecommendedFor: ['dyslipidemia', 'gastritis'],
    ),
    FoodEquivalent(
      name: 'Aguacate',
      group: 'Grasas S/P',
      portion: '1/3 pieza',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
    ),

    // GRASAS CON PROTEÍNA
    FoodEquivalent(
      name: 'Nuez',
      group: 'Grasas C/P',
      portion: '3 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Almendra',
      group: 'Grasas C/P',
      portion: '10 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Cacahuate natural',
      group: 'Grasas C/P',
      portion: '14 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Pistaches',
      group: 'Grasas C/P',
      portion: '18 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Nuez de la india',
      group: 'Grasas C/P',
      portion: '7 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Aceitunas',
      group: 'Grasas C/P',
      portion: '6 piezas',
      carbs: 3,
      protein: 3,
      fat: 5,
      calories: 70,
    ),
  ];
}
