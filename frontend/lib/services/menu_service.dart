class MenuService {
  static Map<String, List<String>> generateMenu(double calories) {
    if (calories <= 1500) {
      return {
        'Desayuno': [
          '2 huevos revueltos',
          '2 tortillas de maíz',
          '1 porción de fruta',
          'Café o té sin azúcar',
        ],
        'Colación': [
          '1 yogurt natural sin azúcar',
          '10 almendras',
        ],
        'Comida': [
          '120 g de pechuga de pollo',
          '1 taza de arroz',
          'Ensalada verde',
          '1 tortilla de maíz',
        ],
        'Cena': [
          '1 lata de atún en agua',
          'Galletas saladas integrales',
          'Pepino o jícama',
        ],
      };
    } else if (calories <= 1800) {
      return {
        'Desayuno': [
          '2 huevos con verdura',
          '2 tortillas de maíz',
          '1 porción de fruta',
          '1 vaso de leche descremada',
        ],
        'Colación': [
          '1 yogurt griego natural',
          '15 nueces o almendras',
        ],
        'Comida': [
          '150 g de carne magra o pollo',
          '1 taza de arroz o pasta',
          'Ensalada',
          '2 tortillas',
        ],
        'Cena': [
          '2 tostadas horneadas con atún o pollo',
          'Verduras al gusto',
          '1 fruta pequeña',
        ],
      };
    } else if (calories <= 2200) {
      return {
        'Desayuno': [
          '3 huevos con verdura',
          '3 tortillas de maíz',
          '1 porción de fruta',
          '1 vaso de leche',
        ],
        'Colación': [
          '1 sandwich de pechuga de pavo',
          '1 fruta',
        ],
        'Comida': [
          '180 g de pollo, carne o pescado',
          '1.5 tazas de arroz, pasta o papa',
          'Ensalada grande',
          '2 tortillas',
        ],
        'Cena': [
          '2 quesadillas de maíz con panela',
          'Verduras',
          '1 yogurt natural',
        ],
      };
    } else {
      return {
        'Desayuno': [
          '4 claras + 2 huevos',
          '4 tortillas o 2 panes integrales',
          '1 fruta',
          '1 vaso de leche',
        ],
        'Colación': [
          '1 licuado de proteína o yogurt con avena',
          '1 plátano',
        ],
        'Comida': [
          '200 g de proteína magra',
          '2 tazas de arroz, pasta o papa',
          'Ensalada',
          '2-3 tortillas',
        ],
        'Cena': [
          'Sandwich integral de pollo o atún',
          'Fruta o yogurt',
        ],
      };
    }
  }
}