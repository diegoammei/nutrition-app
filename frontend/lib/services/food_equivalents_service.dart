class FoodRecommendationRules {
  static List<String> recommendedFor(String name, String group) {
    final food = name.toLowerCase();

    if (group == 'Verduras') {
      return ['diabetes', 'hypertension', 'dyslipidemia', 'obesity', 'overweight'];
    }

    if (food.contains('avena') ||
        food.contains('pan integral') ||
        food.contains('arroz integral') ||
        food.contains('quinoa') ||
        food.contains('amaranto')) {
      return ['diabetes', 'dyslipidemia', 'obesity', 'overweight'];
    }

    if (food.contains('manzana') ||
        food.contains('pera') ||
        food.contains('papaya') ||
        food.contains('melón') ||
        food.contains('fresa') ||
        food.contains('guayaba') ||
        food.contains('zarzamora') ||
        food.contains('frambuesa')) {
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
            recommendedFor ?? FoodRecommendationRules.recommendedFor(name, group);
}

class FoodEquivalentsService {
  static final List<FoodEquivalent> foods = [
    // CEREALES
    FoodEquivalent(name: 'Pan integral', group: 'Cereales', portion: '1 rebanada', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Tortilla de máquina (maíz)', group: 'Cereales', portion: '1 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Bolillo o telera', group: 'Cereales', portion: '1/3 de pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Cereal de caja sin azúcar', group: 'Cereales', portion: '1/2 taza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Pan dulce', group: 'Cereales', portion: '1/3 de pieza', carbs: 15, protein: 2, fat: 5, calories: 115, notRecommendedFor: ['diabetes', 'dyslipidemia', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Tortilla de harina', group: 'Cereales', portion: '1/2 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Pan para hot dog', group: 'Cereales', portion: '1/2 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Pan para hamburguesa chico', group: 'Cereales', portion: '1/2 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Hot cake mediano', group: 'Cereales', portion: '1 pieza', carbs: 15, protein: 2, fat: 0, calories: 70, notRecommendedFor: ['diabetes', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Granola natural', group: 'Cereales', portion: '3 cucharadas', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Papa cocida', group: 'Cereales', portion: '1/2 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Papa cambray', group: 'Cereales', portion: '5 piezas', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Arroz integral cocido', group: 'Cereales', portion: '1/2 taza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Quinoa cocida', group: 'Cereales', portion: '1/2 taza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Avena', group: 'Cereales', portion: '3 cucharadas', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Camote', group: 'Cereales', portion: '45 gramos', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Pan tostado integral', group: 'Cereales', portion: '1 rebanada', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Palomitas naturales sin sal', group: 'Cereales', portion: '3 tazas', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Camote de cerro', group: 'Cereales', portion: '75 gramos', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Tostada horneada', group: 'Cereales', portion: '1 pieza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Salmas horneadas', group: 'Cereales', portion: '1 paquete individual', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Elote desgranado', group: 'Cereales', portion: '1/2 taza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Amaranto tostado', group: 'Cereales', portion: '1/4 de taza', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Galletas habaneras', group: 'Cereales', portion: '5 piezas', carbs: 15, protein: 2, fat: 0, calories: 70),
    FoodEquivalent(name: 'Galletas Marías', group: 'Cereales', portion: '5 piezas', carbs: 15, protein: 2, fat: 0, calories: 70, notRecommendedFor: ['diabetes', 'obesity', 'overweight']),

    // AOA
    FoodEquivalent(name: 'Molida de res', group: 'AOA', portion: '30 gramos', carbs: 0, protein: 7, fat: 5, calories: 75, notRecommendedFor: ['dyslipidemia', 'gastritis']),
    FoodEquivalent(name: 'Cuete de res', group: 'AOA', portion: '50 gramos', carbs: 0, protein: 7, fat: 3, calories: 55),
    FoodEquivalent(name: 'Falda de res', group: 'AOA', portion: '40 gramos', carbs: 0, protein: 7, fat: 5, calories: 75, notRecommendedFor: ['dyslipidemia']),
    FoodEquivalent(name: 'Filete de pescado', group: 'AOA', portion: '40 gramos', carbs: 0, protein: 7, fat: 1, calories: 40),
    FoodEquivalent(name: 'Queso panela o fresco', group: 'AOA', portion: '40 gramos', carbs: 0, protein: 7, fat: 3, calories: 55),
    FoodEquivalent(name: 'Huevo', group: 'AOA', portion: '1 pieza', carbs: 0, protein: 6, fat: 5, calories: 70),
    FoodEquivalent(name: 'Claras de huevo', group: 'AOA', portion: '2 piezas', carbs: 0, protein: 7, fat: 0, calories: 35),
    FoodEquivalent(name: 'Bistec de res', group: 'AOA', portion: '35 gramos', carbs: 0, protein: 7, fat: 5, calories: 75, notRecommendedFor: ['dyslipidemia']),
    FoodEquivalent(name: 'Filete de pollo', group: 'AOA', portion: '60 gramos', carbs: 0, protein: 14, fat: 2, calories: 75),
    FoodEquivalent(name: 'Medallón de atún', group: 'AOA', portion: '35 gramos', carbs: 0, protein: 7, fat: 1, calories: 40),
    FoodEquivalent(name: 'Pechuga de pollo deshuesada', group: 'AOA', portion: '30 gramos', carbs: 0, protein: 7, fat: 1, calories: 40),
    FoodEquivalent(name: 'Pescado', group: 'AOA', portion: '70 gramos', carbs: 0, protein: 14, fat: 2, calories: 75),
    FoodEquivalent(name: 'Requesón', group: 'AOA', portion: '3 cucharadas', carbs: 0, protein: 7, fat: 3, calories: 55),
    FoodEquivalent(name: 'Pollo en pieza sin piel', group: 'AOA', portion: '120 gramos', carbs: 0, protein: 14, fat: 2, calories: 75),
    FoodEquivalent(name: 'Camarón', group: 'AOA', portion: '5 piezas', carbs: 0, protein: 7, fat: 1, calories: 40),
    FoodEquivalent(name: 'Jamón', group: 'AOA', portion: '2 rebanadas', carbs: 0, protein: 7, fat: 3, calories: 55, notRecommendedFor: ['hypertension', 'dyslipidemia', 'gastritis', 'colitis']),
    FoodEquivalent(name: 'Salchicha', group: 'AOA', portion: '1 pieza', carbs: 0, protein: 7, fat: 5, calories: 75, notRecommendedFor: ['hypertension', 'dyslipidemia', 'gastritis', 'colitis']),
    FoodEquivalent(name: 'Hígado de res', group: 'AOA', portion: '30 gramos', carbs: 0, protein: 7, fat: 3, calories: 55, recommendedFor: ['anemia']),
    FoodEquivalent(name: 'Arrachera de res', group: 'AOA', portion: '30 gramos', carbs: 0, protein: 7, fat: 5, calories: 75, notRecommendedFor: ['dyslipidemia']),

    // VERDURAS
    FoodEquivalent(name: 'Acelga cruda', group: 'Verduras', portion: '2 tazas', carbs: 4, protein: 2, fat: 0, calories: 25, recommendedFor: ['anemia', 'diabetes', 'hypertension', 'dyslipidemia', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Brócoli crudo', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Betabel', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Berro crudo', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Apio', group: 'Verduras', portion: '2 tazas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Calabacita alargada o redonda', group: 'Verduras', portion: '1 pieza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Cebolla rebanada', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis', 'colitis']),
    FoodEquivalent(name: 'Cebolla cambray', group: 'Verduras', portion: '3 piezas', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis', 'colitis']),
    FoodEquivalent(name: 'Champiñón natural rebanado', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Chayote', group: 'Verduras', portion: '1/2 pieza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Chile habanero, chile jalapeño', group: 'Verduras', portion: '6 piezas', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis', 'colitis']),
    FoodEquivalent(name: 'Chile poblano', group: 'Verduras', portion: '1/2 pieza', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis', 'colitis']),
    FoodEquivalent(name: 'Cilantro picado', group: 'Verduras', portion: '2 tazas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Coliflor cocida', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Ejotes picados', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Espinaca cruda', group: 'Verduras', portion: '2 tazas', carbs: 4, protein: 2, fat: 0, calories: 25, recommendedFor: ['anemia', 'diabetes', 'hypertension', 'dyslipidemia', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Espárragos crudos', group: 'Verduras', portion: '6 piezas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Nopal crudo', group: 'Verduras', portion: '2 piezas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Nopal cocido', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Pimiento morrón (verde, amarillo, rojo)', group: 'Verduras', portion: '1 pieza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Rábano', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Salsa mexicana, pico de gallo, taquera, roja o verde', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis', 'colitis']),
    FoodEquivalent(name: 'Pepinillos', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['hypertension', 'gastritis', 'colitis']),
    FoodEquivalent(name: 'Puré de tomate', group: 'Verduras', portion: '1/4 de taza', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Jitomate', group: 'Verduras', portion: '1 pieza o 100 gramos', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Lechuga', group: 'Verduras', portion: '3 tazas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Tomate', group: 'Verduras', portion: '5 piezas', carbs: 4, protein: 2, fat: 0, calories: 25, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Verdolagas', group: 'Verduras', portion: '1 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Zanahoria baby cruda', group: 'Verduras', portion: '3 piezas', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Zanahoria rayada o picada cruda', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Jícama picada', group: 'Verduras', portion: '1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25),
    FoodEquivalent(name: 'Pepino rebanado', group: 'Verduras', portion: '1 1/2 taza', carbs: 4, protein: 2, fat: 0, calories: 25),

    // GRASAS SIN PROTEINA
    FoodEquivalent(name: 'Aceite de oliva', group: 'Grasas S/P', portion: '1 cucharadita', carbs: 0, protein: 0, fat: 5, calories: 45),
    FoodEquivalent(name: 'Pepita sin cáscara', group: 'Grasas S/P', portion: '1 cucharada', carbs: 0, protein: 0, fat: 5, calories: 45),
    FoodEquivalent(name: 'Crema', group: 'Grasas S/P', portion: '1 cucharada', carbs: 0, protein: 0, fat: 5, calories: 45, notRecommendedFor: ['dyslipidemia', 'gastritis', 'colitis', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Mayonesa', group: 'Grasas S/P', portion: '1 cucharadita', carbs: 0, protein: 0, fat: 5, calories: 45, notRecommendedFor: ['hypertension', 'dyslipidemia', 'gastritis', 'colitis', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Mantequilla', group: 'Grasas S/P', portion: '1 1/2 cucharaditas', carbs: 0, protein: 0, fat: 5, calories: 45, notRecommendedFor: ['hypertension', 'dyslipidemia', 'gastritis', 'colitis', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Queso crema', group: 'Grasas S/P', portion: '1 cucharada', carbs: 0, protein: 0, fat: 5, calories: 45, notRecommendedFor: ['dyslipidemia', 'gastritis', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Aguacate', group: 'Grasas S/P', portion: '1/3 pieza', carbs: 0, protein: 0, fat: 5, calories: 45),

    // FRUTAS
    FoodEquivalent(name: 'Agua de coco', group: 'Frutas', portion: '1 1/2 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Arándano', group: 'Frutas', portion: '1/2 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Carambolo', group: 'Frutas', portion: '1 1/2 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Ciruela', group: 'Frutas', portion: '3 piezas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Ciruela pasa', group: 'Frutas', portion: '7 piezas', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['diabetes', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Frambuesa', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Kiwi', group: 'Frutas', portion: '1 1/2 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Lima', group: 'Frutas', portion: '3 piezas', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Limón', group: 'Frutas', portion: '4 piezas', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Mamey', group: 'Frutas', portion: '1/3 de pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Mandarina', group: 'Frutas', portion: '1 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Nance', group: 'Frutas', portion: '2 tazas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Plátano macho', group: 'Frutas', portion: '1/4 de pieza', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['diabetes', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Toronja', group: 'Frutas', portion: '1 pieza', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Tuna', group: 'Frutas', portion: '2 piezas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Manzana', group: 'Frutas', portion: '1 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Pera', group: 'Frutas', portion: '1/2 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Plátano', group: 'Frutas', portion: '1/2 pieza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Melón picado', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Papaya picada', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Piña', group: 'Frutas', portion: '1 rebanada', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Uvas', group: 'Frutas', portion: '15 piezas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Naranja', group: 'Frutas', portion: '2 piezas', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['gastritis']),
    FoodEquivalent(name: 'Durazno', group: 'Frutas', portion: '3 piezas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Guayaba', group: 'Frutas', portion: '3 piezas', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Sandía', group: 'Frutas', portion: '1 rebanada', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Mango picado', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60, notRecommendedFor: ['diabetes', 'obesity', 'overweight']),
    FoodEquivalent(name: 'Fresa rebanada', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60),
    FoodEquivalent(name: 'Zarzamora', group: 'Frutas', portion: '1 taza', carbs: 15, protein: 0, fat: 0, calories: 60),

    // LECHE
    FoodEquivalent(name: 'Leche descremada', group: 'Leche', portion: '1 taza', carbs: 12, protein: 8, fat: 0, calories: 90),
    FoodEquivalent(name: 'Yogurt griego natural chobani', group: 'Leche', portion: '1 pieza', carbs: 12, protein: 8, fat: 2, calories: 100),

    // LEGUMINOSAS
    FoodEquivalent(name: 'Frijoles cocidos', group: 'Leguminosas', portion: '1/2 taza', carbs: 20, protein: 8, fat: 1, calories: 120),
    FoodEquivalent(name: 'Frijoles molidos', group: 'Leguminosas', portion: '1/3 de taza', carbs: 20, protein: 8, fat: 1, calories: 120),
    FoodEquivalent(name: 'Lentejas cocidas', group: 'Leguminosas', portion: '1/2 taza', carbs: 20, protein: 9, fat: 1, calories: 120),
    FoodEquivalent(name: 'Garbanzos cocidos', group: 'Leguminosas', portion: '1/2 taza', carbs: 20, protein: 8, fat: 1, calories: 120),
    FoodEquivalent(name: 'Soya cocida', group: 'Leguminosas', portion: '1/3 taza', carbs: 20, protein: 8, fat: 1, calories: 120),
    FoodEquivalent(name: 'Soya texturizada seca', group: 'Leguminosas', portion: '35 gramos', carbs: 20, protein: 8, fat: 1, calories: 120),

    // GRASAS CON PROTEINA
    FoodEquivalent(name: 'Nuez', group: 'Grasas C/P', portion: '3 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
    FoodEquivalent(name: 'Almendra', group: 'Grasas C/P', portion: '10 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
    FoodEquivalent(name: 'Cacahuate natural', group: 'Grasas C/P', portion: '14 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
    FoodEquivalent(name: 'Pistaches', group: 'Grasas C/P', portion: '18 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
    FoodEquivalent(name: 'Nuez de la india', group: 'Grasas C/P', portion: '7 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
    FoodEquivalent(name: 'Aceitunas negras o verdes', group: 'Grasas C/P', portion: '6 piezas', carbs: 3, protein: 3, fat: 5, calories: 70),
  ];
}
