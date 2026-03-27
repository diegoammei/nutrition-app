import 'package:flutter/material.dart';
import 'services/patient_service.dart';
import 'services/anthropometry_service.dart';
import 'services/nutrition_plan_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String gender = 'female';

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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es obligatorio';
                      }

                      if (value.length < 2) {
                        return 'Nombre muy corto';
                      }

                      // Debe contener al menos una letra
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
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
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
                    gender: gender,
                    phone: phoneController.text,
                    email: emailController.text,
                  );

                  if (!mounted) return;
                  Navigator.pop(context);

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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientDetailScreen(patient: patient),
                      ),
                    );
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Sin fecha';

    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd/MM/yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatShortDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
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
  }

  Future<void> _openAnthropometryForm() async {
    final weightController = TextEditingController();
    final heightController = TextEditingController();
    final waistController = TextEditingController();
    final hipController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar antropometría'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                ),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Estatura (cm)'),
                ),
                TextField(
                  controller: waistController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cintura (opcional)',
                  ),
                ),
                TextField(
                  controller: hipController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Cadera (opcional)',
                  ),
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
                try {
                  await AnthropometryService.createAnthropometry(
                    patientId: widget.patient['id'],
                    weight: double.parse(weightController.text),
                    height: double.parse(heightController.text),
                    waist: waistController.text.isNotEmpty
                        ? double.parse(waistController.text)
                        : null,
                    hip: hipController.text.isNotEmpty
                        ? double.parse(hipController.text)
                        : null,
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

    final heightController = TextEditingController(
      text: last != null ? last['height'].toString() : '',
    );

    final ageController = TextEditingController(
      text: widget.patient['age'].toString(),
    );
    final activityController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    String gender = 'female';
    String goal = 'deficit';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear plan nutricional'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Peso'),
                  keyboardType: TextInputType.number,
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
                  decoration: const InputDecoration(labelText: 'Estatura'),
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
                TextFormField(
                  controller: ageController,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
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
                TextFormField(
                  controller: activityController,
                  decoration: const InputDecoration(
                    labelText: 'Factor actividad (ej: 1.2)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Factor de actividad obligatorio';
                    }
                    final activity = double.tryParse(value);
                    if (activity == null) {
                      return 'Debe ser número';
                    }
                    if (activity < 1.2 || activity > 2.5) {
                      return 'Factor inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: gender,
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Hombre')),
                    DropdownMenuItem(value: 'female', child: Text('Mujer')),
                  ],
                  onChanged: (value) {
                    gender = value!;
                  },
                  decoration: const InputDecoration(labelText: 'Género'),
                ),
                DropdownButtonFormField<String>(
                  value: goal,
                  items: const [
                    DropdownMenuItem(value: 'deficit', child: Text('Déficit')),
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
                  },
                  decoration: const InputDecoration(labelText: 'Objetivo'),
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
                if (!formKey.currentState!.validate()) return;
                try {
                  await NutritionPlanService.createNutritionPlan(
                    patientId: widget.patient['id'],
                    weight: double.parse(weightController.text),
                    height: double.parse(heightController.text),
                    age: int.parse(ageController.text),
                    gender: gender,
                    activityFactor: double.parse(activityController.text),
                    goal: goal,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.patient['name'] ?? '')),
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
            final latestPlan = nutritionPlans.isNotEmpty
                ? nutritionPlans.last
                : null;

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
                                "IMC: ${item['body_mass_index']?.toStringAsFixed(2) ?? 'N/A'}"
                                "\nFecha: ${_formatDate(item['created_at'])}",
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
                  if (latestPlan == null)
                    const Text("No hay planes nutricionales")
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Objetivo: ${latestPlan['goal']}"),
                        const SizedBox(height: 8),
                        Text(
                          "Calorías totales: ${latestPlan['total_calories']?.toStringAsFixed(2) ?? 'N/A'}",
                        ),
                        Text(
                          "Proteína: ${latestPlan['protein']?.toStringAsFixed(2) ?? 'N/A'} g",
                        ),
                        Text(
                          "Carbohidratos: ${latestPlan['carbs']?.toStringAsFixed(2) ?? 'N/A'} g",
                        ),
                        Text(
                          "Grasas: ${latestPlan['fats']?.toStringAsFixed(2) ?? 'N/A'} g",
                        ),
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
