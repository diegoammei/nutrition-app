class MenuService {
  static Map<String, List<String>> generateMenu(
    double calories, {
    String pathology = 'none',
  }) {
    switch (pathology) {
      case 'diabetes':
        return _diabetesMenu(calories);
      case 'hypertension':
        return _hypertensionMenu(calories);
      case 'anemia':
        return _anemiaMenu(calories);
      case 'gastritis':
        return _gastritisMenu(calories);
      case 'colitis':
        return _colitisMenu(calories);
      case 'muscle_gain':
        return _muscleGainMenu(calories);
      case 'dyslipidemia':
        return _dyslipidemiaMenu(calories);
      case 'malnutrition':
        return _malnutritionMenu(calories);
      default:
        return _generalMenu(calories);
    }
  }

  static Map<String, List<String>> _generalMenu(double calories) {
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
    } else {
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
    }
  }

  static Map<String, List<String>> _diabetesMenu(double calories) {
    return {
      'Desayuno': [
        'Avena cocida sin azúcar',
        '1 huevo + claras con verduras',
        '1 porción pequeña de fruta con bajo índice glucémico',
      ],
      'Colación': [
        'Yogurt natural sin azúcar',
        'Nueces o almendras',
      ],
      'Comida': [
        'Pechuga de pollo o pescado',
        'Verduras cocidas o ensalada',
        'Frijoles o arroz integral en porción controlada',
        'Agua natural',
      ],
      'Cena': [
        'Tostadas horneadas con atún',
        'Verduras',
        'Evitar bebidas azucaradas',
      ],
    };
  }

  static Map<String, List<String>> _hypertensionMenu(double calories) {
    return {
      'Desayuno': [
        'Huevo con verduras sin exceso de sal',
        'Tortillas de maíz',
        'Fruta fresca',
      ],
      'Colación': [
        'Fruta',
        'Semillas naturales sin sal',
      ],
      'Comida': [
        'Pollo, pescado o carne magra',
        'Arroz o papa cocida',
        'Ensalada con limón',
        'Evitar embutidos y consomé en polvo',
      ],
      'Cena': [
        'Quesadillas con queso bajo en grasa',
        'Verduras cocidas',
        'Agua natural',
      ],
    };
  }

  static Map<String, List<String>> _anemiaMenu(double calories) {
    return {
      'Desayuno': [
        'Huevo con espinaca',
        'Tortillas de maíz',
        'Fruta rica en vitamina C',
      ],
      'Colación': [
        'Guayaba, naranja o mandarina',
        'Nueces o semillas',
      ],
      'Comida': [
        'Carne magra, pollo o lentejas',
        'Verduras verdes',
        'Limón o fruta cítrica para mejorar absorción de hierro',
      ],
      'Cena': [
        'Tostadas con frijoles o pollo',
        'Verduras',
        'Evitar té o café junto con comidas ricas en hierro',
      ],
    };
  }

  static Map<String, List<String>> _gastritisMenu(double calories) {
    return {
      'Desayuno': [
        'Avena cocida',
        'Plátano',
        'Té suave sin cafeína',
      ],
      'Colación': [
        'Yogurt natural si se tolera',
        'Pan tostado',
      ],
      'Comida': [
        'Pollo cocido o pescado',
        'Arroz blanco o papa cocida',
        'Verduras cocidas',
        'Evitar picante, café y alimentos muy grasosos',
      ],
      'Cena': [
        'Sopa de verduras',
        'Pollo deshebrado',
        'Tostada horneada o pan tostado',
      ],
    };
  }

  static Map<String, List<String>> _colitisMenu(double calories) {
    return {
      'Desayuno': [
        'Avena o pan tostado',
        'Huevo cocido',
        'Fruta tolerada sin cáscara',
      ],
      'Colación': [
        'Yogurt natural si se tolera',
        'Galletas simples',
      ],
      'Comida': [
        'Pollo o pescado',
        'Arroz o papa',
        'Verduras cocidas no irritantes',
        'Evitar irritantes y alimentos detonantes',
      ],
      'Cena': [
        'Caldo o sopa ligera',
        'Proteína magra',
        'Porción pequeña de carbohidrato',
      ],
    };
  }

  static Map<String, List<String>> _muscleGainMenu(double calories) {
    return {
      'Desayuno': [
        'Huevos con avena o tortillas',
        'Fruta',
        'Leche o yogurt',
      ],
      'Colación': [
        'Yogurt griego con avena',
        'Plátano o fruta',
      ],
      'Comida': [
        'Pollo, carne magra o pescado',
        'Arroz, pasta o papa',
        'Verduras',
        'Aguacate o aceite de oliva',
      ],
      'Cena': [
        'Atún, pollo o huevo',
        'Tortillas o pan integral',
        'Verduras',
      ],
    };
  }

  static Map<String, List<String>> _dyslipidemiaMenu(double calories) {
    return {
      'Desayuno': [
        'Avena',
        'Fruta',
        'Nueces o semillas',
      ],
      'Colación': [
        'Yogurt natural bajo en grasa',
        'Fruta',
      ],
      'Comida': [
        'Pescado, pollo sin piel o leguminosas',
        'Verduras',
        'Arroz integral o tortilla',
        'Evitar frituras y grasas saturadas',
      ],
      'Cena': [
        'Ensalada con proteína magra',
        'Tostadas horneadas',
        'Aguacate en porción moderada',
      ],
    };
  }

  static Map<String, List<String>> _malnutritionMenu(double calories) {
    return {
      'Desayuno': [
        'Huevo con tortilla',
        'Avena con leche',
        'Fruta',
      ],
      'Colación': [
        'Licuado con leche, plátano y avena',
        'Nueces o crema de cacahuate en porción adecuada',
      ],
      'Comida': [
        'Pollo, carne o pescado',
        'Arroz, pasta o papa',
        'Verduras',
        'Aceite de oliva o aguacate',
      ],
      'Cena': [
        'Quesadillas o sandwich con proteína',
        'Yogurt o leche',
        'Fruta',
      ],
    };
  }
}