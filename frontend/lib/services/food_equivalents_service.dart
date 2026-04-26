class FoodEquivalent {
  final String name;
  final String group;
  final String portion;
  final double carbs;
  final double protein;
  final double fat;
  final double calories;

  FoodEquivalent({
    required this.name,
    required this.group,
    required this.portion,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.calories,
  });
}

class FoodEquivalentsService {
  static List<FoodEquivalent> foods = [
    // FRUTAS
    FoodEquivalent(
      name: 'Plátano',
      group: 'Fruta',
      portion: '1/2 pieza',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),
    FoodEquivalent(
      name: 'Manzana',
      group: 'Fruta',
      portion: '1 pieza chica',
      carbs: 15,
      protein: 0,
      fat: 0,
      calories: 60,
    ),

    // CEREALES
    FoodEquivalent(
      name: 'Tortilla de maíz',
      group: 'Cereal',
      portion: '1 pieza',
      carbs: 15,
      protein: 2,
      fat: 1,
      calories: 70,
    ),
    FoodEquivalent(
      name: 'Arroz',
      group: 'Cereal',
      portion: '1/3 taza',
      carbs: 15,
      protein: 2,
      fat: 0,
      calories: 70,
    ),

    // PROTEÍNA (AOA)
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
      name: 'Huevo',
      group: 'AOA',
      portion: '1 pieza',
      carbs: 0,
      protein: 6,
      fat: 5,
      calories: 70,
    ),

    // GRASAS
    FoodEquivalent(
      name: 'Aceite de oliva',
      group: 'Grasa',
      portion: '1 cucharadita',
      carbs: 0,
      protein: 0,
      fat: 5,
      calories: 45,
    ),
    FoodEquivalent(
      name: 'Aguacate',
      group: 'Grasa',
      portion: '1/3 pieza',
      carbs: 5,
      protein: 1,
      fat: 10,
      calories: 100,
    ),
  ];
}