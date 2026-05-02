import 'package:flutter/material.dart';
import 'services/patient_service.dart';
import 'services/anthropometry_service.dart';
import 'services/nutrition_plan_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/pdf_service.dart';
import 'services/menu_service.dart';
import 'services/appointment_service.dart';
import 'services/equivalent_plan_service.dart';
import 'services/food_selection_service.dart';
import 'services/recommendation_service.dart';
import 'services/meal_builder_service.dart';
import 'services/menu_item_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Software Nutrición',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const PatientListScreen(),
    );
  }
}

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  late Future<List<dynamic>> _patientsFuture;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  void _loadPatients() {
    _patientsFuture = PatientService.getPatients();
  }

  Future<void> _openCreatePatientForm() async {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final heightController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String gender = 'female';
    String pathology = 'none';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar paciente'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.length < 2) {
                        return 'Nombre muy corto';
                      }
                      if (!RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]').hasMatch(value)) {
                        return 'Debe contener al menos una letra';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Edad'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Edad obligatoria';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Debe ser número';
                      }
                      if (age < 0 || age > 120) {
                        return 'Edad inválida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: heightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Estatura (cm)',
                    ),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estatura obligatoria';
                      }
                      final height = double.tryParse(value);
                      if (height == null) {
                        return 'Debe ser número';
                      }
                      if (height < 100 || height > 250) {
                        return 'Estatura inválida';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: const [
                      DropdownMenuItem(value: 'female', child: Text('Mujer')),
                      DropdownMenuItem(value: 'male', child: Text('Hombre')),
                    ],
                    onChanged: (value) {
                      gender = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Género'),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: pathology,
                    items: const [
                      DropdownMenuItem(value: 'none', child: Text('Ninguna')),
                      DropdownMenuItem(
                        value: 'diabetes',
                        child: Text('Diabetes'),
                      ),
                      DropdownMenuItem(
                        value: 'hypertension',
                        child: Text('Hipertensión'),
                      ),
                      DropdownMenuItem(value: 'cancer', child: Text('Cáncer')),
                      DropdownMenuItem(
                        value: 'malnutrition',
                        child: Text('Desnutrición'),
                      ),
                      DropdownMenuItem(value: 'anemia', child: Text('Anemia')),
                      DropdownMenuItem(
                        value: 'muscle_gain',
                        child: Text('Aumento masa muscular'),
                      ),
                      DropdownMenuItem(
                        value: 'dyslipidemia',
                        child: Text('Dislipidemia'),
                      ),
                      DropdownMenuItem(
                        value: 'gastritis',
                        child: Text('Gastritis'),
                      ),
                      DropdownMenuItem(
                        value: 'colitis',
                        child: Text('Colitis'),
                      ),
                    ],
                    onChanged: (value) {
                      pathology = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Patología'),
                  ),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Teléfono obligatorio';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Debe tener 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'Email'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email obligatorio';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  await PatientService.createPatient(
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    height: double.parse(heightController.text),
                    gender: gender,
                    phone: phoneController.text,
                    email: emailController.text,
                    pathology: pathology,
                  );

                  if (!mounted) return;
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Paciente creado correctamente'),
                    ),
                  );

                  setState(() {
                    _loadPatients();
                  });
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreatePatientForm,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _patientsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final patients = snapshot.data ?? [];

          if (patients.isEmpty) {
            return const Center(child: Text('No hay pacientes'));
          }

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(patient['name'] ?? ''),
                  subtitle: Text(patient['email'] ?? ''),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailScreen(patient: patient),
                      ),
                    );

                    setState(() {
                      _loadPatients();
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PatientDetailScreen extends StatefulWidget {
  final dynamic patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Future<List<dynamic>> _anthropometriesFuture;
  late Future<List<dynamic>> _nutritionPlansFuture;
  late Future<List<dynamic>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _getPathologyText(String? pathology) {
    switch (pathology) {
      case 'diabetes':
        return 'Diabetes';
      case 'hypertension':
        return 'Hipertensión';
      case 'cancer':
        return 'Cáncer';
      case 'malnutrition':
        return 'Desnutrición';
      case 'anemia':
        return 'Anemia';
      case 'muscle_gain':
        return 'Aumento masa muscular';
      case 'dyslipidemia':
        return 'Dislipidemia';
      case 'gastritis':
        return 'Gastritis';
      case 'colitis':
        return 'Colitis';
      default:
        return 'Ninguna';
    }
  }

  String _getPathologyRecommendation(String? pathology) {
    switch (pathology) {
      case 'diabetes':
        return 'Priorizar carbohidratos complejos, evitar bebidas azucaradas y distribuir carbohidratos durante el día.';
      case 'hypertension':
        return 'Reducir sodio, evitar embutidos y ultraprocesados.';
      case 'anemia':
        return 'Incluir hierro y vitamina C.';
      case 'muscle_gain':
        return 'Asegurar proteína suficiente y entrenamiento de fuerza.';
      case 'dyslipidemia':
        return 'Priorizar grasas saludables y limitar frituras.';
      case 'gastritis':
        return 'Evitar irritantes como picante, café y alcohol.';
      case 'colitis':
        return 'Ajustar fibra según tolerancia.';
      default:
        return 'Sin recomendaciones especiales.';
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Sin fecha';

    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatShortDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString).toLocal();
      return DateFormat('dd/MM').format(date);
    } catch (e) {
      return '';
    }
  }

  void _loadData() {
    _anthropometriesFuture = AnthropometryService.getAnthropometriesByPatient(
      widget.patient['id'],
    );
    _nutritionPlansFuture = NutritionPlanService.getNutritionPlansByPatient(
      widget.patient['id'],
    );
    _appointmentsFuture = AppointmentService.getAppointmentsByPatient(
      widget.patient['id'],
    );
  }

  Future<void> _openAnthropometryForm() async {
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    final waistController = TextEditingController();
    final hipController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar antropometría'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: weightController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Peso obligatorio';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null) {
                        return 'Debe ser número';
                      }
                      if (weight < 20 || weight > 300) {
                        return 'Peso fuera de rango';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: heightController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Estatura (cm)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estatura obligatoria';
                      }
                      final height = double.tryParse(value);
                      if (height == null) {
                        return 'Debe ser número';
                      }
                      if (height < 100 || height > 250) {
                        return 'Estatura inválida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: waistController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cintura (opcional)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final waist = double.tryParse(value);
                      if (waist == null) {
                        return 'Debe ser número';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: hipController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cadera (opcional)',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final hip = double.tryParse(value);
                      if (hip == null) {
                        return 'Debe ser número';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                try {
                  final weight = double.tryParse(weightController.text);
                  final height = double.tryParse(heightController.text);
                  final waist = waistController.text.isNotEmpty
                      ? double.tryParse(waistController.text)
                      : null;
                  final hip = hipController.text.isNotEmpty
                      ? double.tryParse(hipController.text)
                      : null;

                  if (weight == null || height == null) return;

                  await AnthropometryService.createAnthropometry(
                    patientId: widget.patient['id'],
                    weight: weight,
                    height: height,
                    waist: waist,
                    hip: hip,
                  );

                  if (!mounted) return;
                  Navigator.pop(context);

                  setState(() {
                    _loadData();
                  });
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openNutritionPlanForm() async {
    final latestAnthro = await AnthropometryService.getAnthropometriesByPatient(
      widget.patient['id'],
    );

    final last = latestAnthro.isNotEmpty ? latestAnthro.last : null;

    final weightController = TextEditingController(
      text: last != null ? last['weight'].toString() : '',
    );
    final ageController = TextEditingController(
      text: widget.patient['age'].toString(),
    );

    final formKey = GlobalKey<FormState>();

    final weightFocus = FocusNode();
    final ageFocus = FocusNode();
    final activityFocus = FocusNode();

    String gender = widget.patient['gender'] ?? 'female';
    String goal = 'deficit';

    double activity = 1.2;
    double? previewCalories;
    double? previewProtein;
    double? previewCarbs;
    double? previewFats;
    double? previewImc;
    String? previewImcCategory;

    void calculatePreview(StateSetter setModalState) {
      final weight = double.tryParse(weightController.text);
      final age = int.tryParse(ageController.text);
      final height = (widget.patient['height'] as num?)?.toDouble();
      final activityValue = activity;

      if (weight == null || height == null || age == null) {
        setModalState(() {
          previewCalories = null;
          previewProtein = null;
          previewCarbs = null;
          previewFats = null;
          previewImc = null;
          previewImcCategory = null;
        });
        return;
      }

      double bmr;
      if (gender == 'male') {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
      } else {
        bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
      }

      double calories = bmr * activityValue;

      if (goal == 'deficit') {
        calories *= 0.8;
      } else if (goal == 'superavit') {
        calories *= 1.2;
      }

      final protein = (calories * 0.20) / 4;
      final carbs = (calories * 0.50) / 4;
      final fats = (calories * 0.30) / 9;
      final heightMeters = height / 100;
      final imc = weight / (heightMeters * heightMeters);

      String imcCategory;

      if (imc < 18.5) {
        imcCategory = 'Bajo peso';
      } else if (imc < 25) {
        imcCategory = 'Normal';
      } else if (imc < 30) {
        imcCategory = 'Sobrepeso';
      } else {
        imcCategory = 'Obesidad';
      }

      setModalState(() {
        previewCalories = calories;
        previewProtein = protein;
        previewCarbs = carbs;
        previewFats = fats;
        previewImc = imc;
        previewImcCategory = imcCategory;
      });
    }

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Crear plan nutricional'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: weightController,
                        focusNode: weightFocus,
                        decoration: const InputDecoration(labelText: 'Peso'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(ageFocus);
                        },
                        onChanged: (_) => calculatePreview(setModalState),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Peso obligatorio';
                          }
                          final weight = double.tryParse(value);
                          if (weight == null) {
                            return 'Debe ser número';
                          }
                          if (weight < 20 || weight > 300) {
                            return 'Peso fuera de rango';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: ageController,
                        focusNode: ageFocus,
                        decoration: const InputDecoration(labelText: 'Edad'),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(activityFocus);
                        },
                        onChanged: (_) => calculatePreview(setModalState),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Edad obligatoria';
                          }
                          final age = int.tryParse(value);
                          if (age == null) {
                            return 'Debe ser número entero';
                          }
                          if (age < 0 || age > 120) {
                            return 'Edad inválida';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<double>(
                        value: activity,
                        items: const [
                          DropdownMenuItem(
                            value: 1.2,
                            child: Text('Sedentario (1.2)'),
                          ),
                          DropdownMenuItem(
                            value: 1.375,
                            child: Text('Ligero (1.375) - 1-3 días/semana'),
                          ),
                          DropdownMenuItem(
                            value: 1.55,
                            child: Text('Moderado (1.55) - 3-5 días/semana'),
                          ),
                          DropdownMenuItem(
                            value: 1.725,
                            child: Text('Intenso (1.725) - 6-7 días/semana'),
                          ),
                          DropdownMenuItem(
                            value: 1.9,
                            child: Text('Muy intenso (1.9) - atleta'),
                          ),
                        ],
                        onChanged: (value) {
                          activity = value!;
                          calculatePreview(setModalState);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Actividad',
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: goal,
                        items: const [
                          DropdownMenuItem(
                            value: 'deficit',
                            child: Text('Déficit'),
                          ),
                          DropdownMenuItem(
                            value: 'superavit',
                            child: Text('Superávit'),
                          ),
                          DropdownMenuItem(
                            value: 'maintain',
                            child: Text('Mantenimiento'),
                          ),
                        ],
                        onChanged: (value) {
                          goal = value!;
                          calculatePreview(setModalState);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Objetivo',
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (previewCalories != null)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vista previa del plan',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Calorías: ${previewCalories!.toStringAsFixed(2)} kcal',
                                ),
                                Text(
                                  'IMC: ${previewImc!.toStringAsFixed(2)} (${previewImcCategory ?? ''})',
                                ),
                                Text(
                                  'Proteína: ${previewProtein!.toStringAsFixed(2)} g',
                                ),
                                Text(
                                  'Carbohidratos: ${previewCarbs!.toStringAsFixed(2)} g',
                                ),
                                Text(
                                  'Grasas: ${previewFats!.toStringAsFixed(2)} g',
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    try {
                      final weight = double.tryParse(weightController.text)!;
                      final height = (widget.patient['height'] as num)
                          .toDouble();
                      final age = int.tryParse(ageController.text)!;
                      final activityValue = activity;

                      final plan =
                          await NutritionPlanService.createNutritionPlan(
                            patientId: widget.patient['id'],
                            weight: weight,
                            height: height,
                            age: age,
                            gender: gender,
                            activityFactor: activityValue,
                            goal: goal,
                          );

                      final calories =
                          (plan['total_calories'] as num?)?.toDouble() ?? 0;

                      final dailyEquivalents =
                          EquivalentPlanService.calculateDailyEquivalents(
                            calories: calories,
                            pathology: widget.patient['pathology'] ?? 'none',
                          );

                      final mealDistribution =
                          EquivalentPlanService.distributeByMeal(
                            dailyEquivalents: dailyEquivalents,
                          );

                      final equivalentMenu =
                          FoodSelectionService.generateFoodMenuFromDistribution(
                            mealDistribution: mealDistribution,
                            pathology: widget.patient['pathology'] ?? 'none',
                          );

                      await MenuItemService.saveMenu(
                        nutritionPlanId: plan['id'],
                        menu: equivalentMenu,
                      );

                      if (!mounted) return;
                      Navigator.pop(context);

                      setState(() {
                        _loadData();
                      });
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openAppointmentForm() async {
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    DateTime selectedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Agregar cita'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Fecha y hora'),
                        subtitle: Text(
                          _formatDate(selectedDate.toIso8601String()),
                        ),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 365),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365 * 5),
                            ),
                          );

                          if (pickedDate == null) return;

                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDate),
                          );

                          if (pickedTime == null) return;

                          setModalState(() {
                            selectedDate = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        },
                      ),
                      TextFormField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notas (opcional)',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await AppointmentService.createAppointment(
                        patientId: widget.patient['id'],
                        date: selectedDate.toIso8601String(),
                        notes: notesController.text.trim().isEmpty
                            ? null
                            : notesController.text.trim(),
                      );

                      if (!mounted) return;
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cita creada correctamente'),
                        ),
                      );

                      setState(() {
                        _loadData();
                      });
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _openEditPatientForm() async {
    final nameController = TextEditingController(text: widget.patient['name']);
    final ageController = TextEditingController(
      text: widget.patient['age'].toString(),
    );
    final heightController = TextEditingController(
      text: widget.patient['height']?.toString() ?? '',
    );
    final phoneController = TextEditingController(
      text: widget.patient['phone'],
    );
    final emailController = TextEditingController(
      text: widget.patient['email'],
    );
    final formKey = GlobalKey<FormState>();

    String gender = widget.patient['gender'] == 'M'
        ? 'male'
        : widget.patient['gender'] == 'F'
        ? 'female'
        : (widget.patient['gender'] ?? 'female');

    String pathology = widget.patient['pathology'] ?? 'none';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar paciente'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      if (value.length < 2) {
                        return 'Nombre muy corto';
                      }
                      if (!RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚñÑ]').hasMatch(value)) {
                        return 'Debe contener al menos una letra';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Edad'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Edad obligatoria';
                      }
                      final age = int.tryParse(value);
                      if (age == null) {
                        return 'Debe ser número';
                      }
                      if (age < 0 || age > 120) {
                        return 'Edad inválida';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: heightController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Estatura (cm)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estatura obligatoria';
                      }
                      final height = double.tryParse(value);
                      if (height == null) {
                        return 'Debe ser número';
                      }
                      if (height < 100 || height > 250) {
                        return 'Estatura inválida';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Hombre')),
                      DropdownMenuItem(value: 'female', child: Text('Mujer')),
                    ],
                    onChanged: (value) {
                      gender = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Género'),
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: pathology,
                    items: const [
                      DropdownMenuItem(value: 'none', child: Text('Ninguna')),
                      DropdownMenuItem(
                        value: 'diabetes',
                        child: Text('Diabetes'),
                      ),
                      DropdownMenuItem(
                        value: 'hypertension',
                        child: Text('Hipertensión'),
                      ),
                      DropdownMenuItem(value: 'cancer', child: Text('Cáncer')),
                      DropdownMenuItem(
                        value: 'malnutrition',
                        child: Text('Desnutrición'),
                      ),
                      DropdownMenuItem(value: 'anemia', child: Text('Anemia')),
                      DropdownMenuItem(
                        value: 'muscle_gain',
                        child: Text('Aumento masa muscular'),
                      ),
                      DropdownMenuItem(
                        value: 'dyslipidemia',
                        child: Text('Dislipidemia'),
                      ),
                      DropdownMenuItem(
                        value: 'gastritis',
                        child: Text('Gastritis'),
                      ),
                      DropdownMenuItem(
                        value: 'colitis',
                        child: Text('Colitis'),
                      ),
                    ],
                    onChanged: (value) {
                      pathology = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Patología'),
                  ),
                  TextFormField(
                    controller: phoneController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Teléfono obligatorio';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Debe tener 10 dígitos';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    maxLines: 1,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email obligatorio';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                try {
                  await PatientService.updatePatient(
                    id: widget.patient['id'],
                    name: nameController.text,
                    age: int.parse(ageController.text),
                    height: double.parse(heightController.text),
                    gender: gender,
                    phone: phoneController.text,
                    email: emailController.text,
                    pathology: pathology,
                  );

                  if (!mounted) return;
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Paciente actualizado')),
                  );

                  setState(() {
                    widget.patient['name'] = nameController.text;
                    widget.patient['age'] = int.parse(ageController.text);
                    widget.patient['height'] = double.parse(
                      heightController.text,
                    );
                    widget.patient['phone'] = phoneController.text;
                    widget.patient['email'] = emailController.text;
                    widget.patient['gender'] = gender;
                    widget.patient['pathology'] = pathology;
                  });
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openEditMenu(Map<String, dynamic> plan) async {
    final items = await MenuItemService.getMenuItemsByPlan(plan['id']);

    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in items) {
      final meal = item['meal_time'];

      if (!grouped.containsKey(meal)) {
        grouped[meal] = [];
      }

      grouped[meal]!.add(item);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Editar menú'),
              content: SizedBox(
                width: 400,
                height: 500,
                child: ListView(
                  children: grouped.entries.map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        ...entry.value.map((item) {
                          return Row(
                            children: [
                              Expanded(child: Text(item['item_text'])),

                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () async {
                                  final controller = TextEditingController(
                                    text: item['item_text'],
                                  );

                                  final result = await showDialog<String>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: const Text('Editar alimento'),
                                      content: TextField(
                                        controller: controller,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                            context,
                                            controller.text,
                                          ),
                                          child: const Text('Guardar'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (result != null) {
                                    await MenuItemService.updateMenuItem(
                                      id: item['id'],
                                      nutritionPlanId: plan['id'],
                                      mealTime: item['meal_time'],
                                      itemText: result,
                                      order: item['order'],
                                    );

                                    item['item_text'] = result;
                                    setModalState(() {});
                                  }
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await MenuItemService.deleteMenuItem(
                                    item['id'],
                                  );
                                  entry.value.remove(item);
                                  setModalState(() {});
                                },
                              ),
                            ],
                          );
                        }).toList(),

                        TextButton(
                          onPressed: () async {
                            final controller = TextEditingController();

                            final result = await showDialog<String>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Nuevo alimento'),
                                content: TextField(controller: controller),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, controller.text),
                                    child: const Text('Agregar'),
                                  ),
                                ],
                              ),
                            );

                            if (result != null && result.isNotEmpty) {
                              await MenuItemService.createMenuItem(
                                nutritionPlanId: plan['id'],
                                mealTime: entry.key,
                                itemText: result,
                                order: entry.value.length,
                              );

                              entry.value.add({
                                'item_text': result,
                                'meal_time': entry.key,
                                'order': entry.value.length,
                              });

                              setModalState(() {});
                            }
                          },
                          child: const Text('+ Agregar alimento'),
                        ),

                        const Divider(),
                      ],
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeletePatient() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar paciente'),
          content: const Text('¿Seguro que quieres eliminar este paciente?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await PatientService.deletePatient(widget.patient['id']);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Paciente eliminado correctamente')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patient['name'] ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _openEditPatientForm,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDeletePatient,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAnthropometryForm,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<List<dynamic>>>(
          future: Future.wait<List<dynamic>>([
            _anthropometriesFuture,
            _nutritionPlansFuture,
            _appointmentsFuture,
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final anthropometries = snapshot.data?[0] ?? [];
            final nutritionPlans = snapshot.data?[1] ?? [];
            final appointments = snapshot.data?[2] ?? [];

            final spots = anthropometries.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return FlSpot(
                index.toDouble(),
                (item['weight'] as num).toDouble(),
              );
            }).toList();

            final latestAnthro = anthropometries.isNotEmpty
                ? anthropometries.last
                : null;
            /*final latestPlan = nutritionPlans.isNotEmpty
                ? nutritionPlans.last
                : null;*/

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nombre: ${widget.patient['name'] ?? ''}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Email: ${widget.patient['email'] ?? ''}"),
                  const SizedBox(height: 10),
                  Text("Teléfono: ${widget.patient['phone'] ?? ''}"),
                  const SizedBox(height: 10),
                  Text("Edad: ${widget.patient['age']?.toString() ?? ''}"),
                  const SizedBox(height: 10),
                  Text(
                    "Género: ${widget.patient['gender'] == 'male' ? 'Hombre' : 'Mujer'}",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Estatura: ${widget.patient['height']?.toString() ?? 'N/A'} cm",
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Patología: ${_getPathologyText(widget.patient['pathology'])}",
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Antropometría",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (latestAnthro == null)
                    const Text("No hay registros antropométricos")
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Último peso: ${latestAnthro['weight']} kg"),
                        const SizedBox(height: 8),
                        Text("Última estatura: ${latestAnthro['height']} cm"),
                        const SizedBox(height: 8),
                        Text(
                          "Último IMC: ${latestAnthro['body_mass_index']?.toStringAsFixed(2) ?? 'N/A'}",
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Última cintura: ${latestAnthro['waist'] ?? 'N/A'}",
                        ),
                        const SizedBox(height: 8),
                        Text("Última cadera: ${latestAnthro['hip'] ?? 'N/A'}"),
                        const SizedBox(height: 20),
                        const Text(
                          "Historial",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...anthropometries.reversed.map((item) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: const Icon(Icons.monitor_weight),
                              title: Text("Peso: ${item['weight']} kg"),
                              subtitle: Text(
                                "IMC: ${item['body_mass_index']?.toStringAsFixed(2) ?? 'N/A'}\nFecha: ${_formatDate(item['created_at'])}",
                              ),
                              isThreeLine: true,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Text(
                    "Evolución de peso",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (spots.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();

                                  if (index < 0 ||
                                      index >= anthropometries.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final item = anthropometries[index];
                                  final dateText = _formatShortDate(
                                    item['created_at'],
                                  );

                                  return Text(
                                    dateText,
                                    style: const TextStyle(fontSize: 10),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              dotData: FlDotData(show: true),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    const Text("No hay datos para gráfica"),
                  const SizedBox(height: 24),
                  const Text(
                    "Plan nutricional",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _openNutritionPlanForm,
                    child: const Text('Crear plan nutricional'),
                  ),
                  const SizedBox(height: 12),
                  if (nutritionPlans.isEmpty)
                    const Text("No hay planes nutricionales")
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...nutritionPlans.reversed.toList().asMap().entries.map((
                          entry,
                        ) {
                          final index = entry.key;
                          final plan = entry.value;
                          final goalText = plan['goal'] == 'deficit'
                              ? 'Déficit'
                              : plan['goal'] == 'maintain'
                              ? 'Mantenimiento'
                              : plan['goal'] == 'superavit'
                              ? 'Superávit'
                              : (plan['goal'] ?? 'Sin objetivo');
                          final calories =
                              (plan['total_calories'] as num?)?.toDouble() ?? 0;

                          final dailyEquivalents =
                              EquivalentPlanService.calculateDailyEquivalents(
                                calories: calories,
                                pathology:
                                    widget.patient['pathology'] ?? 'none',
                              );

                          final mealDistribution =
                              EquivalentPlanService.distributeByMeal(
                                dailyEquivalents: dailyEquivalents,
                              );

                          final equivalentMenu =
                              FoodSelectionService.generateFoodMenuFromDistribution(
                                mealDistribution: mealDistribution,
                                pathology:
                                    widget.patient['pathology'] ?? 'none',
                              );

                          final readableMeals =
                              MealBuilderService.buildReadableMeals(
                                equivalentMenu,
                              );

                          final recommendation =
                              RecommendationService.generateRecommendation(
                                pathology:
                                    widget.patient['pathology'] ?? 'none',
                                menu: equivalentMenu,
                              );

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ExpansionTile(
                              initiallyExpanded: index == 0,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Objetivo: $goalText",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Patología considerada: ${_getPathologyText(widget.patient['pathology'])}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                "${((plan['total_calories'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} kcal • ${_formatDate(plan['created_at'])}",
                              ),
                              childrenPadding: const EdgeInsets.all(12),
                              children: [
                                Text(
                                  "Objetivo: $goalText",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Calorías totales: ${((plan['total_calories'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} kcal",
                                ),
                                Text(
                                  "Proteína: ${((plan['protein'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                                ),
                                Text(
                                  "Carbohidratos: ${((plan['carbs'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                                ),
                                Text(
                                  "Grasas: ${((plan['fats'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Fecha: ${_formatDate(plan['created_at'])}",
                                ),
                                const SizedBox(height: 12),

                                const SizedBox(height: 12),

                                const Text(
                                  'Equivalentes diarios',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 6),

                                ...dailyEquivalents.entries.map((entry) {
                                  return Text('${entry.key}: ${entry.value}');
                                }).toList(),

                                const SizedBox(height: 12),

                                const Text(
                                  'Distribución por horarios',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 6),

                                ...mealDistribution.entries.map((mealEntry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mealEntry.key,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ...mealEntry.value.entries
                                            .where((item) => item.value > 0)
                                            .map(
                                              (item) => Text(
                                                '${item.key}: ${item.value}',
                                              ),
                                            ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                                const Text(
                                  'Platillos sugeridos',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),

                                ...readableMeals.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text('${entry.key}: ${entry.value}'),
                                  );
                                }).toList(),

                                const SizedBox(height: 12),

                                const Text(
                                  'Menú sugerido',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                ElevatedButton(
                                  onPressed: () => _openEditMenu(
                                    Map<String, dynamic>.from(plan),
                                  ),
                                  child: const Text('Editar menú'),
                                ),
                                const SizedBox(height: 8),

                                ...equivalentMenu.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ...entry.value.map(
                                          (item) => Text('• $item'),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                                const SizedBox(height: 12),

                                const Text(
                                  'Recomendaciones',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 6),

                                Text(recommendation),

                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        final calories =
                                            (plan['total_calories'] as num?)
                                                ?.toDouble() ??
                                            0;
                                        final protein =
                                            (plan['protein'] as num?)
                                                ?.toDouble() ??
                                            0;
                                        final carbs =
                                            (plan['carbs'] as num?)
                                                ?.toDouble() ??
                                            0;
                                        final fats =
                                            (plan['fats'] as num?)
                                                ?.toDouble() ??
                                            0;

                                        final imc = latestAnthro != null
                                            ? (latestAnthro['body_mass_index']
                                                      as num?)
                                                  ?.toDouble()
                                            : null;

                                        final height =
                                            (widget.patient['height'] as num?)
                                                ?.toDouble();

                                        final weight = latestAnthro != null
                                            ? (latestAnthro['weight'] as num?)
                                                  ?.toDouble()
                                            : null;

                                        final age = widget.patient['age'] is int
                                            ? widget.patient['age'] as int
                                            : int.tryParse(
                                                widget.patient['age']
                                                        ?.toString() ??
                                                    '',
                                              );

                                        PdfService.generateNutritionPlanPdf(
                                          patientName:
                                              widget.patient['name']
                                                  ?.toString() ??
                                              'Paciente',
                                          goal: goalText,
                                          calories: calories,
                                          protein: protein,
                                          carbs: carbs,
                                          fats: fats,
                                          menu: equivalentMenu,
                                          readableMeals: readableMeals,
                                          recommendation: recommendation,
                                          imc: imc,
                                          gender:
                                              widget.patient['gender'] == 'male'
                                              ? 'Hombre'
                                              : 'Mujer',
                                          height: height,
                                          age: age,
                                          weight: weight,
                                        );
                                      },
                                      child: const Text('Generar PDF'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Eliminar plan nutricional',
                                              ),
                                              content: const Text(
                                                '¿Seguro que quieres eliminar este plan nutricional?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('Cancelar'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text('Eliminar'),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirmed != true) return;

                                        try {
                                          await NutritionPlanService.deleteNutritionPlan(
                                            plan['id'],
                                          );

                                          if (!mounted) return;

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Plan nutricional eliminado',
                                              ),
                                            ),
                                          );

                                          setState(() {
                                            _loadData();
                                          });
                                        } catch (e) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('Error: $e'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    "Citas",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _openAppointmentForm,
                    child: const Text('Agregar cita'),
                  ),
                  const SizedBox(height: 12),
                  if (appointments.isEmpty)
                    const Text("No hay citas registradas")
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...appointments.map((appointment) {
                          final statusText =
                              appointment['status'] == 'completed'
                              ? 'Completada'
                              : appointment['status'] == 'cancelled'
                              ? 'Cancelada'
                              : 'Pendiente';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(_formatDate(appointment['date'])),
                              subtitle: Text(
                                'Estado: $statusText'
                                '${appointment['notes'] != null && appointment['notes'].toString().isNotEmpty ? '\nNotas: ${appointment['notes']}' : ''}',
                              ),
                              isThreeLine:
                                  appointment['notes'] != null &&
                                  appointment['notes'].toString().isNotEmpty,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Eliminar cita'),
                                        content: const Text(
                                          '¿Seguro que quieres eliminar esta cita?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Eliminar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirmed != true) return;

                                  try {
                                    await AppointmentService.deleteAppointment(
                                      appointment['id'],
                                    );

                                    if (!mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cita eliminada'),
                                      ),
                                    );

                                    setState(() {
                                      _loadData();
                                    });
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error: $e')),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
