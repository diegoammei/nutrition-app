import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'services/pathology_service.dart';
import 'services/nutrition_history_service.dart';
import 'services/biochemical_test_service.dart';
import 'services/follow_up_note_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'NutriApp',

      theme: ThemeData(
        useMaterial3: true,

        scaffoldBackgroundColor: const Color(0xFFF6F3FB),

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F3FB),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),

        cardTheme: CardThemeData(
          elevation: 2,
          color: Colors.white,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 1,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
          ),
        ),

        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.deepPurple,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.deepPurple,
          dividerColor: Colors.transparent,
        ),
      ),

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
    List<int> selectedPathologies = [];
    final pathologies = await PathologyService.getPathologies();

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
                  const SizedBox(height: 12),

                  const Text(
                    'Patologías',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  ...pathologies.map((p) {
                    return StatefulBuilder(
                      builder: (context, setCheckboxState) {
                        return CheckboxListTile(
                          title: Text(p['name']),
                          value: selectedPathologies.contains(p['id']),
                          onChanged: (value) {
                            setCheckboxState(() {
                              if (value == true) {
                                selectedPathologies.add(p['id']);
                              } else {
                                selectedPathologies.remove(p['id']);
                              }
                            });
                          },
                        );
                      },
                    );
                  }).toList(),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Teléfono obligatorio';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Debe tener exactamente 10 dígitos';
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
                    pathologies: selectedPathologies,
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple.shade100,
                    child: Text(
                      (patient['name'] ?? 'P')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    patient['name'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(patient['email'] ?? ''),
                      if ((patient['phone'] ?? '').toString().isNotEmpty)
                        Text(patient['phone']),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),
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
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
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
              actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
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

                      final pathologyCodes =
                          (widget.patient['pathologies_detail']
                                      as List<dynamic>? ??
                                  [])
                              .map((p) => p['code'].toString())
                              .toList();

                      final dailyEquivalents =
                          EquivalentPlanService.calculateDailyEquivalents(
                            calories: calories,
                            pathologies: pathologyCodes,
                          );

                      final mealDistribution =
                          EquivalentPlanService.distributeByMeal(
                            dailyEquivalents: dailyEquivalents,
                          );

                      final equivalentMenu =
                          FoodSelectionService.generateFoodMenuFromDistribution(
                            mealDistribution: mealDistribution,
                            pathologies: pathologyCodes,
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

    final pathologies = await PathologyService.getPathologies();

    List<int> selectedPathologies =
        (widget.patient['pathologies'] as List<dynamic>?)
            ?.map((item) => item as int)
            .toList() ??
        [];

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

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

                  const SizedBox(height: 12),

                  const Text(
                    'Patologías',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  ...pathologies.map((p) {
                    return StatefulBuilder(
                      builder: (context, setCheckboxState) {
                        return CheckboxListTile(
                          title: Text(p['name']),
                          value: selectedPathologies.contains(p['id']),
                          onChanged: (value) {
                            setCheckboxState(() {
                              if (value == true) {
                                selectedPathologies.add(p['id']);
                              } else {
                                selectedPathologies.remove(p['id']);
                              }
                            });
                          },
                        );
                      },
                    );
                  }).toList(),
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Teléfono obligatorio';
                      }
                      if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Debe tener exactamente 10 dígitos';
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
                    pathologies: selectedPathologies,
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
                    widget.patient['pathologies'] = selectedPathologies;
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

  Future<void> _openNutritionHistoryDialog() async {
    final histories = await NutritionHistoryService.getHistoriesByPatient(
      widget.patient['id'],
    );

    final existingHistory = histories.isNotEmpty ? histories.first : null;

    final consultationReasonController = TextEditingController(
      text: existingHistory?['consultation_reason'] ?? '',
    );
    final previousConditionsController = TextEditingController(
      text: existingHistory?['previous_conditions'] ?? '',
    );
    final currentConditionController = TextEditingController(
      text: existingHistory?['current_condition'] ?? '',
    );

    final recallBreakfastController = TextEditingController(
      text: existingHistory?['recall_breakfast'] ?? '',
    );
    final recallMorningSnackController = TextEditingController(
      text: existingHistory?['recall_morning_snack'] ?? '',
    );
    final recallLunchController = TextEditingController(
      text: existingHistory?['recall_lunch'] ?? '',
    );
    final recallAfternoonSnackController = TextEditingController(
      text: existingHistory?['recall_afternoon_snack'] ?? '',
    );
    final recallDinnerController = TextEditingController(
      text: existingHistory?['recall_dinner'] ?? '',
    );

    final currentMedicationsController = TextEditingController(
      text: existingHistory?['current_medications'] ?? '',
    );

    final supplementsController = TextEditingController(
      text: existingHistory?['supplements'] ?? '',
    );

    final foodAllergiesController = TextEditingController(
      text: existingHistory?['food_allergies'] ?? '',
    );

    final avoidedFoodsController = TextEditingController(
      text: existingHistory?['avoided_foods'] ?? '',
    );

    final avoidedFoodsReasonController = TextEditingController(
      text: existingHistory?['avoided_foods_reason'] ?? '',
    );

    bool familyDiabetes = existingHistory?['family_diabetes'] ?? false;
    bool familyObesity = existingHistory?['family_obesity'] ?? false;
    bool familyCancer = existingHistory?['family_cancer'] ?? false;
    bool familyHypertension = existingHistory?['family_hypertension'] ?? false;
    bool familyThyroid = existingHistory?['family_thyroid'] ?? false;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(
                existingHistory == null
                    ? 'Historia nutricional'
                    : 'Editar historia nutricional',
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: consultationReasonController,
                      decoration: const InputDecoration(
                        labelText: 'Motivo de consulta',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 12),

                    CheckboxListTile(
                      value: familyDiabetes,
                      title: const Text('Diabetes familiar'),
                      onChanged: (value) {
                        setModalState(() {
                          familyDiabetes = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: familyObesity,
                      title: const Text('Obesidad familiar'),
                      onChanged: (value) {
                        setModalState(() {
                          familyObesity = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: familyCancer,
                      title: const Text('Cáncer familiar'),
                      onChanged: (value) {
                        setModalState(() {
                          familyCancer = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: familyHypertension,
                      title: const Text('Hipertensión familiar'),
                      onChanged: (value) {
                        setModalState(() {
                          familyHypertension = value ?? false;
                        });
                      },
                    ),

                    CheckboxListTile(
                      value: familyThyroid,
                      title: const Text('Problemas tiroideos familiares'),
                      onChanged: (value) {
                        setModalState(() {
                          familyThyroid = value ?? false;
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: previousConditionsController,
                      decoration: const InputDecoration(
                        labelText: 'Padecimientos previos',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: currentConditionController,
                      decoration: const InputDecoration(
                        labelText: 'Padecimiento actual',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Medicamentos y suplementos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: currentMedicationsController,
                      decoration: const InputDecoration(
                        labelText: 'Medicamentos actuales',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: supplementsController,
                      decoration: const InputDecoration(
                        labelText: 'Suplementos',
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Alergias y alimentos evitados',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: foodAllergiesController,
                      decoration: const InputDecoration(
                        labelText: 'Alergias alimentarias',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: avoidedFoodsController,
                      decoration: const InputDecoration(
                        labelText: 'Alimentos que evita',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: avoidedFoodsReasonController,
                      decoration: const InputDecoration(
                        labelText: 'Motivo por el que los evita',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      'Recordatorio de 24 horas',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: recallBreakfastController,
                      decoration: const InputDecoration(labelText: 'Desayuno'),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: recallMorningSnackController,
                      decoration: const InputDecoration(
                        labelText: 'Colación mañana',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: recallLunchController,
                      decoration: const InputDecoration(labelText: 'Comida'),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: recallAfternoonSnackController,
                      decoration: const InputDecoration(
                        labelText: 'Colación tarde',
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: recallDinnerController,
                      decoration: const InputDecoration(labelText: 'Cena'),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (existingHistory == null) {
                      await NutritionHistoryService.createHistory(
                        patientId: widget.patient['id'],
                        consultationReason: consultationReasonController.text,
                        familyDiabetes: familyDiabetes,
                        familyObesity: familyObesity,
                        familyCancer: familyCancer,
                        familyHypertension: familyHypertension,
                        familyThyroid: familyThyroid,
                        previousConditions: previousConditionsController.text,
                        currentCondition: currentConditionController.text,
                        currentMedications: currentMedicationsController.text,
                        supplements: supplementsController.text,
                        foodAllergies: foodAllergiesController.text,
                        avoidedFoods: avoidedFoodsController.text,
                        avoidedFoodsReason: avoidedFoodsReasonController.text,
                        recallBreakfast: recallBreakfastController.text,
                        recallMorningSnack: recallMorningSnackController.text,
                        recallLunch: recallLunchController.text,
                        recallAfternoonSnack:
                            recallAfternoonSnackController.text,
                        recallDinner: recallDinnerController.text,
                      );
                    } else {
                      await NutritionHistoryService.updateHistory(
                        id: existingHistory['id'],
                        patientId: widget.patient['id'],
                        consultationReason: consultationReasonController.text,
                        familyDiabetes: familyDiabetes,
                        familyObesity: familyObesity,
                        familyCancer: familyCancer,
                        familyHypertension: familyHypertension,
                        familyThyroid: familyThyroid,
                        previousConditions: previousConditionsController.text,
                        currentCondition: currentConditionController.text,
                        currentMedications: currentMedicationsController.text,
                        supplements: supplementsController.text,
                        foodAllergies: foodAllergiesController.text,
                        avoidedFoods: avoidedFoodsController.text,
                        avoidedFoodsReason: avoidedFoodsReasonController.text,
                        recallBreakfast: recallBreakfastController.text,
                        recallMorningSnack: recallMorningSnackController.text,
                        recallLunch: recallLunchController.text,
                        recallAfternoonSnack:
                            recallAfternoonSnackController.text,
                        recallDinner: recallDinnerController.text,
                      );
                    }

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Historia nutricional guardada'),
                      ),
                    );
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

  Future<void> _openBiochemicalTestsDialog() async {
    final tests = await BiochemicalTestService.getTestsByPatient(
      widget.patient['id'],
    );

    if (!mounted) return;

    final dateController = TextEditingController();
    final testNameController = TextEditingController();
    final resultController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Bioquímicos'),

              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Estudios registrados',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      ...tests.map((test) {
                        return Card(
                          child: ListTile(
                            title: Text(test['test_name'] ?? ''),
                            subtitle: Text(
                              'Resultado: ${test['result']}\n'
                              'Fecha: ${test['date']}',
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 16),

                      const Divider(),

                      const SizedBox(height: 8),

                      const Text(
                        'Agregar estudio',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: dateController,
                        decoration: const InputDecoration(
                          labelText: 'Fecha (YYYY-MM-DD)',
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: testNameController,
                        decoration: const InputDecoration(labelText: 'Examen'),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: resultController,
                        decoration: const InputDecoration(
                          labelText: 'Resultado',
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(labelText: 'Notas'),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await BiochemicalTestService.createTest(
                      patientId: widget.patient['id'],
                      date: dateController.text,
                      testName: testNameController.text,
                      result: resultController.text,
                      notes: notesController.text,
                    );

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Estudio guardado')),
                    );

                    setState(() {});
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

  Future<void> _openFollowUpNotesDialog() async {
    final notes = await FollowUpNoteService.getNotesByPatient(
      widget.patient['id'],
    );

    if (!mounted) return;

    final evolutionController = TextEditingController();
    final adherenceController = TextEditingController();
    final symptomsController = TextEditingController();
    final observationsController = TextEditingController();
    final planChangesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seguimiento clínico'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Notas registradas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  ...notes.map((note) {
                    return Card(
                      child: ListTile(
                        title: Text(note['adherence'] ?? 'Seguimiento'),
                        subtitle: Text(
                          'Evolución: ${note['evolution'] ?? ''}\n'
                          'Síntomas: ${note['symptoms'] ?? ''}\n'
                          'Observaciones: ${note['observations'] ?? ''}',
                        ),
                      ),
                    );
                  }),

                  const Divider(),

                  TextField(
                    controller: evolutionController,
                    decoration: const InputDecoration(labelText: 'Evolución'),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: adherenceController,
                    decoration: const InputDecoration(labelText: 'Adherencia'),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: symptomsController,
                    decoration: const InputDecoration(labelText: 'Síntomas'),
                    maxLines: 2,
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: observationsController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                    ),
                    maxLines: 3,
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: planChangesController,
                    decoration: const InputDecoration(
                      labelText: 'Cambios al plan',
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
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FollowUpNoteService.createNote(
                  patientId: widget.patient['id'],
                  evolution: evolutionController.text,
                  adherence: adherenceController.text,
                  symptoms: symptomsController.text,
                  observations: observationsController.text,
                  planChanges: planChangesController.text,
                );

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Seguimiento guardado')),
                );

                setState(() {});
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

  Widget _menuActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: 260,
        height: 44,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: const Color(0xFFF8F4FC),
            foregroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: onPressed,
          child: Text(text),
        ),
      ),
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepPurple.withOpacity(0.12),
              child: Icon(icon, size: 18, color: Colors.deepPurple),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _patientHeaderCard() {
    final name = widget.patient['name'] ?? 'Paciente';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'P';

    final gender = widget.patient['gender'] == 'male' ? 'Hombre' : 'Mujer';
    final age = widget.patient['age']?.toString() ?? 'N/A';
    final height = widget.patient['height']?.toString() ?? 'N/A';

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '$gender · $age años · $height cm',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    widget.patient['email'] ?? '',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenTab({
    required List<dynamic> anthropometries,
    required List<FlSpot> spots,
    required List<FlSpot> imcSpots,
    required dynamic latestAnthro,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _patientHeaderCard(),

          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 4.5,
            children: [
              _summaryCard(
                icon: Icons.email,
                title: 'Email',
                value: widget.patient['email'] ?? '',
              ),

              _summaryCard(
                icon: Icons.phone,
                title: 'Teléfono',
                value: widget.patient['phone'] ?? '',
              ),

              _summaryCard(
                icon: Icons.cake,
                title: 'Edad',
                value: '${widget.patient['age'] ?? ''} años',
              ),

              _summaryCard(
                icon: Icons.wc,
                title: 'Género',
                value: widget.patient['gender'] == 'male' ? 'Hombre' : 'Mujer',
              ),

              _summaryCard(
                icon: Icons.height,
                title: 'Estatura',
                value: '${widget.patient['height'] ?? 'N/A'} cm',
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Antropometría",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          if (latestAnthro == null)
            const Text("No hay registros antropométricos")
          else ...[
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 4.5,
              children: [
                _summaryCard(
                  icon: Icons.monitor_weight,
                  title: 'Peso',
                  value: '${latestAnthro['weight']} kg',
                ),

                _summaryCard(
                  icon: Icons.straighten,
                  title: 'IMC',
                  value:
                      '${latestAnthro['body_mass_index']?.toStringAsFixed(2) ?? 'N/A'}',
                ),

                _summaryCard(
                  icon: Icons.accessibility_new,
                  title: 'Cintura',
                  value: '${latestAnthro['waist'] ?? 'N/A'} cm',
                ),

                _summaryCard(
                  icon: Icons.accessibility,
                  title: 'Cadera',
                  value: '${latestAnthro['hip'] ?? 'N/A'} cm',
                ),
              ],
            ),

            const SizedBox(height: 20),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Evolución de peso",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (spots.isNotEmpty)
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,

                                color: Colors.deepPurple,

                                barWidth: 4,

                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.deepPurple.withOpacity(0.15),
                                ),

                                dotData: FlDotData(show: true),

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purpleAccent,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Text("No hay datos para gráfica"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Evolución de IMC",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (imcSpots.isNotEmpty)
                      SizedBox(
                        height: 220,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: imcSpots,
                                isCurved: true,

                                color: Colors.deepPurple,

                                barWidth: 4,

                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.deepPurple.withOpacity(0.15),
                                ),

                                dotData: FlDotData(show: true),

                                gradient: LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purpleAccent,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Text("No hay datos para gráfica"),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _openViewMenu(Map<String, dynamic> plan) async {
    final items = await MenuItemService.getMenuItemsByPlan(plan['id']);

    final Map<String, List<dynamic>> grouped = {};

    for (final item in items) {
      final meal = item['meal_time'] ?? 'Comida';
      grouped.putIfAbsent(meal, () => []);
      grouped[meal]!.add(item);
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Menú sugerido'),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: grouped.isEmpty
                  ? const Text('No hay menú registrado')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: grouped.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                [
                                      'Desayuno',
                                      'Colación mañana',
                                      'Comida',
                                      'Colación tarde',
                                      'Cena',
                                    ]
                                    .where((meal) => grouped.containsKey(meal))
                                    .map((meal) {
                                      final items = grouped[meal]!;

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 14,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meal,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            ...items.map(
                                              (item) => Text(
                                                '- ${item['item_text']}',
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                          ),
                        );
                      }).toList(),
                    ),
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
  }

  Widget _buildPlanesTab({required List<dynamic> nutritionPlans}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              children: nutritionPlans.reversed.toList().asMap().entries.map((
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

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(child: Icon(Icons.eco)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Plan $goalText",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: const Text('Activo'),
                              backgroundColor: Colors.green.shade50,
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "${((plan['total_calories'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} kcal/día",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Proteína\n${((plan['protein'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                            ),
                            Text(
                              "Carbs\n${((plan['carbs'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                            ),
                            Text(
                              "Grasas\n${((plan['fats'] as num?)?.toDouble().toStringAsFixed(0) ?? 'N/A')} g",
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        if (plan['menu'] != null) ...[
                          const Divider(),

                          const SizedBox(height: 12),

                          const Text(
                            'Menú sugerido',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            plan['menu'].toString(),
                            style: const TextStyle(height: 1.5),
                          ),
                        ],

                        const SizedBox(height: 18),

                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _openViewMenu(Map<String, dynamic>.from(plan));
                              },
                              child: const Text('Ver menú'),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () {
                                _openEditMenu(Map<String, dynamic>.from(plan));
                              },
                              child: const Text('Editar menú'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.patient['name'] ?? ''),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(14),
                ),

                labelColor: Colors.white,
                unselectedLabelColor: Colors.deepPurple,

                dividerColor: Colors.transparent,

                indicatorSize: TabBarIndicatorSize.tab,

                tabs: const [
                  Tab(text: 'Resumen'),
                  Tab(text: 'Historia'),
                  Tab(text: 'Planes'),
                  Tab(text: 'Seguimiento'),
                ],
              ),
            ),
          ),
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
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 4,

          onPressed: _openAnthropometryForm,

          icon: const Icon(Icons.add),

          label: const Text(
            'Antropometría',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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

              final imcSpots = anthropometries.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                final weight = double.tryParse(item['weight'].toString()) ?? 0;

                final height = double.tryParse(item['height'].toString()) ?? 0;

                double imc = 0;

                if (height > 0) {
                  imc = weight / ((height / 100) * (height / 100));
                }

                return FlSpot(index.toDouble(), imc);
              }).toList();

              final latestAnthro = anthropometries.isNotEmpty
                  ? anthropometries.last
                  : null;
              return TabBarView(
                children: [
                  _buildResumenTab(
                    anthropometries: anthropometries,
                    spots: spots,
                    imcSpots: imcSpots,
                    latestAnthro: latestAnthro,
                  ),

                  const Center(child: Text('Historia')),

                  _buildPlanesTab(nutritionPlans: nutritionPlans),

                  const Center(child: Text('Seguimiento')),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
