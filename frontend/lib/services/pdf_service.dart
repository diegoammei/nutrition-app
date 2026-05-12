import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  static const PdfColor primaryPink = PdfColor.fromInt(0xFFD16BA5);
  static const PdfColor softPink = PdfColor.fromInt(0xFFF8D9EA);
  static const PdfColor lightPink = PdfColor.fromInt(0xFFFFF2F8);
  static Future<void> generateNutritionPlanPdf({
    required String patientName,
    required String goal,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required Map<String, List<String>> menu,
    required List<Map<String, List<String>>> menus,
    required Map<String, String> readableMeals,
    required String recommendation,
    double? imc,
    String? gender,
    double? height,
    int? age,
    double? weight,
  }) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: softPink,
                borderRadius: pw.BorderRadius.circular(18),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'Plan Nutricional',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryPink,
                    ),
                  ),

                  pw.SizedBox(height: 6),

                  pw.Text(
                    'Cindy López Ramírez',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700),
                  ),

                  pw.SizedBox(height: 2),

                  pw.Text(
                    'Nutrición Clínica',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text(
                'Software Nutrición',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text(
              'Datos del paciente',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Paciente: $patientName'),
            if (age != null) pw.Text('Edad: $age años'),
            if (gender != null) pw.Text('Género: $gender'),
            if (height != null)
              pw.Text('Estatura: ${height.toStringAsFixed(0)} cm'),
            if (weight != null)
              pw.Text('Peso actual: ${weight.toStringAsFixed(1)} kg'),
            if (imc != null) pw.Text('IMC: ${imc.toStringAsFixed(2)}'),

            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text(
              'Resumen del plan',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Objetivo: $goal'),
            pw.Text('Fecha: $formattedDate'),
            pw.SizedBox(height: 16),

            pw.Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _macroCard('Calorías', '${calories.toStringAsFixed(0)} kcal'),

                _macroCard('Proteína', '${protein.toStringAsFixed(0)} g'),

                _macroCard('Carbohidratos', '${carbs.toStringAsFixed(0)} g'),

                _macroCard('Grasas', '${fats.toStringAsFixed(0)} g'),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Platillos sugeridos',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            ...readableMeals.entries.map((entry) {
              return pw.Container(
                width: double.infinity,
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(14),

                decoration: pw.BoxDecoration(
                  color: lightPink,
                  borderRadius: pw.BorderRadius.circular(14),
                  border: pw.Border.all(color: softPink),
                ),

                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      entry.key,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: primaryPink,
                      ),
                    ),

                    pw.SizedBox(height: 8),

                    pw.Text(
                      entry.value,
                      style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
                    ),
                  ],
                ),
              );
            }).toList(),

            pw.SizedBox(height: 24),

            pw.Text(
              'Opciones de menú sugerido',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            ...menus.asMap().entries.expand((menuEntry) {
              final index = menuEntry.key;
              final currentMenu = menuEntry.value;

              return [
                pw.Text(
                  'Menú opción ${index + 1}',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),

                ...currentMenu.entries.map((entry) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          entry.key,
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 4),
                        ...entry.value.map((item) => pw.Text('- $item')),
                      ],
                    ),
                  );
                }).toList(),

                pw.SizedBox(height: 14),
              ];
            }).toList(),

            pw.SizedBox(height: 20),

            pw.Text(
              'Recomendaciones',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(recommendation),

            pw.SizedBox(height: 20),

            pw.Text(
              'Observaciones',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Este documento fue generado automáticamente por la aplicación. '
              'Las cantidades corresponden al plan nutricional calculado.',
            ),

            pw.SizedBox(height: 30),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                'Documento generado automáticamente',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> generateClinicalRecordPdf({
    required Map<String, dynamic> patient,
    required List<dynamic> anthropometries,
    required List<dynamic> nutritionPlans,
    required List<dynamic> biochemicalTests,
    required List<dynamic> followUpNotes,
    required Map<String, dynamic>? nutritionHistory,
  }) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        build: (context) {
          return [
            pw.Center(
              child: pw.Text(
                'Expediente Clínico Nutricional',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Center(child: pw.Text('Fecha de generación: $formattedDate')),
            pw.SizedBox(height: 20),
            pw.Divider(),

            pw.Text(
              'Datos del paciente',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),
            pw.Text('Nombre: ${patient['name'] ?? ''}'),
            pw.Text('Edad: ${patient['age'] ?? ''}'),
            pw.Text('Género: ${patient['gender'] ?? ''}'),
            pw.Text('Teléfono: ${patient['phone'] ?? ''}'),
            pw.Text('Email: ${patient['email'] ?? ''}'),
            pw.Text('Estatura: ${patient['height'] ?? ''} cm'),

            pw.SizedBox(height: 16),
            pw.Divider(),

            pw.Text(
              'Historia nutricional',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            if (nutritionHistory == null)
              pw.Text('Sin historia nutricional registrada')
            else ...[
              pw.Text(
                'Motivo de consulta: ${nutritionHistory['consultation_reason'] ?? ''}',
              ),
              pw.Text(
                'Padecimientos previos: ${nutritionHistory['previous_conditions'] ?? ''}',
              ),
              pw.Text(
                'Padecimiento actual: ${nutritionHistory['current_condition'] ?? ''}',
              ),
              pw.Text(
                'Medicamentos: ${nutritionHistory['current_medications'] ?? ''}',
              ),
              pw.Text('Suplementos: ${nutritionHistory['supplements'] ?? ''}'),
              pw.Text(
                'Alergias alimentarias: ${nutritionHistory['food_allergies'] ?? ''}',
              ),
              pw.Text(
                'Alimentos evitados: ${nutritionHistory['avoided_foods'] ?? ''}',
              ),
              pw.Text(
                'Motivo: ${nutritionHistory['avoided_foods_reason'] ?? ''}',
              ),
            ],

            pw.SizedBox(height: 16),

            pw.Text(
              'Recordatorio de 24 horas',
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),

            if (nutritionHistory != null) ...[
              pw.Text(
                'Desayuno: ${nutritionHistory['recall_breakfast'] ?? ''}',
              ),
              pw.Text(
                'Colación mañana: ${nutritionHistory['recall_morning_snack'] ?? ''}',
              ),
              pw.Text('Comida: ${nutritionHistory['recall_lunch'] ?? ''}'),
              pw.Text(
                'Colación tarde: ${nutritionHistory['recall_afternoon_snack'] ?? ''}',
              ),
              pw.Text('Cena: ${nutritionHistory['recall_dinner'] ?? ''}'),
            ],

            pw.SizedBox(height: 16),
            pw.Divider(),

            pw.Text(
              'Antropometría',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            if (anthropometries.isEmpty)
              pw.Text('Sin registros antropométricos')
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      _cell('Fecha', bold: true),
                      _cell('Peso', bold: true),
                      _cell('IMC', bold: true),
                      _cell('Cintura', bold: true),
                      _cell('Cadera', bold: true),
                    ],
                  ),
                  ...anthropometries.map((item) {
                    return pw.TableRow(
                      children: [
                        _cell(
                          item['created_at']?.toString().substring(0, 10) ?? '',
                        ),
                        _cell('${item['weight'] ?? ''}'),
                        _cell('${item['body_mass_index'] ?? ''}'),
                        _cell('${item['waist'] ?? ''}'),
                        _cell('${item['hip'] ?? ''}'),
                      ],
                    );
                  }).toList(),
                ],
              ),

            pw.SizedBox(height: 16),
            pw.Divider(),

            pw.Text(
              'Bioquímicos',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            if (biochemicalTests.isEmpty)
              pw.Text('Sin estudios bioquímicos')
            else
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      _cell('Fecha', bold: true),
                      _cell('Examen', bold: true),
                      _cell('Resultado', bold: true),
                      _cell('Notas', bold: true),
                    ],
                  ),
                  ...biochemicalTests.map((test) {
                    return pw.TableRow(
                      children: [
                        _cell('${test['date'] ?? ''}'),
                        _cell('${test['test_name'] ?? ''}'),
                        _cell('${test['result'] ?? ''}'),
                        _cell('${test['notes'] ?? ''}'),
                      ],
                    );
                  }).toList(),
                ],
              ),

            pw.SizedBox(height: 16),
            pw.Divider(),

            pw.Text(
              'Seguimiento clínico',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 8),

            if (followUpNotes.isEmpty)
              pw.Text('Sin notas de seguimiento')
            else
              ...followUpNotes.map((note) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 10),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Fecha: ${note['date'] ?? ''}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text('Evolución: ${note['evolution'] ?? ''}'),
                      pw.Text('Adherencia: ${note['adherence'] ?? ''}'),
                      pw.Text('Síntomas: ${note['symptoms'] ?? ''}'),
                      pw.Text('Observaciones: ${note['observations'] ?? ''}'),
                      pw.Text('Cambios al plan: ${note['plan_changes'] ?? ''}'),
                    ],
                  ),
                );
              }).toList(),

            pw.SizedBox(height: 20),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                'Documento generado automáticamente',
                style: const pw.TextStyle(fontSize: 10),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.TableRow _buildRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(label)),
        pw.Padding(padding: const pw.EdgeInsets.all(8), child: pw.Text(value)),
      ],
    );
  }

  static pw.Widget _macroCard(String title, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: lightPink,
        borderRadius: pw.BorderRadius.circular(14),
        border: pw.Border.all(color: softPink),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),

          pw.SizedBox(height: 6),

          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: primaryPink,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _cell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: bold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : null,
      ),
    );
  }
}
