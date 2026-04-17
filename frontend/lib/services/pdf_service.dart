import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> generateNutritionPlanPdf({
    required String patientName,
    required String goal,
    required double calories,
    required double protein,
    required double carbs,
    required double fats,
    required Map<String, List<String>> menu,

    double? imc,
    String? gender,
    double? height,
    int? age,
    double? weight,
  }) async {
    final pdf = pw.Document();
    final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Plan Nutricional',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
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
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
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
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text('Objetivo: $goal'),
              pw.Text('Fecha: $formattedDate'),

              pw.SizedBox(height: 16),

              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Concepto',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          'Valor',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _buildRow('Calorías', '${calories.toStringAsFixed(0)} kcal'),
                  _buildRow('Proteína', '${protein.toStringAsFixed(0)} g'),
                  _buildRow('Carbohidratos', '${carbs.toStringAsFixed(0)} g'),
                  _buildRow('Grasas', '${fats.toStringAsFixed(0)} g'),
                ],
              ),

              pw.SizedBox(height: 24),

              pw.SizedBox(height: 24),

              pw.Text(
                'Menú sugerido',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),

              ...menu.entries.map((entry) {
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
                      ...entry.value.map((item) => pw.Text('• $item')),
                    ],
                  ),
                );
              }).toList(),

              pw.Text(
                'Observaciones',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),

              pw.SizedBox(height: 10),
              pw.Text(
                'Este documento fue generado automáticamente por la aplicación. '
                'Las cantidades aquí mostradas corresponden al plan nutricional registrado.',
              ),

              pw.Spacer(),

              pw.Divider(),
              pw.Center(
                child: pw.Text(
                  'Documento generado automáticamente',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          );
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
}
