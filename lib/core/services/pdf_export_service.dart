import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/models/calculation.dart';
import '../../l10n/app_localizations.dart';
import '../calc/cost_calculator.dart';
import '../utils/currency.dart';
import '../utils/formatters.dart';

/// Kayıtlı hesaplardan PDF raporu üretir.
class PdfExportService {
  const PdfExportService();

  static const _calculator = CostCalculator();

  Future<Uint8List> buildReport({
    required List<Calculation> calculations,
    required AppLocalizations l,
  }) async {
    final base = await PdfGoogleFonts.notoSansRegular();
    final bold = await PdfGoogleFonts.notoSansBold();
    final theme = pw.ThemeData.withFont(base: base, bold: bold);

    final doc = pw.Document(theme: theme);
    final now = Formatters.dateTime(DateTime.now());

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            l.pdfReportTitle,
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            l.pdfGeneratedAt(now),
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 20),
          for (final calc in calculations) ...[
            _calculationBlock(calc, l),
            pw.SizedBox(height: 16),
          ],
        ],
      ),
    );

    return doc.save();
  }

  pw.Widget _calculationBlock(Calculation calc, AppLocalizations l) {
    final currency = AppCurrency.byCode(calc.currencyCode);
    final result = _calculator.calculate(calc.entries);
    final entries =
        calc.entries.where((e) => e.price > 0 && e.quantity > 0).toList();

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      padding: const pw.EdgeInsets.all(12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            calc.name,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            '${currency.code}  •  ${Formatters.dateTime(calc.updatedAt)}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              _stat(
                l.yourAverageCost,
                Formatters.money(result.averageCost, currency.symbol),
              ),
              _stat(l.totalLots, Formatters.quantity(result.totalQuantity)),
              _stat(
                l.totalAmount,
                Formatters.money(result.totalAmount, currency.symbol),
              ),
            ],
          ),
          if (entries.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: [l.price, l.lot, l.amount],
              data: [
                for (final e in entries)
                  [
                    Formatters.money(e.price, currency.symbol),
                    Formatters.quantity(e.quantity),
                    Formatters.money(e.amount, currency.symbol),
                  ],
              ],
              headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 10,
              ),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerRight,
                2: pw.Alignment.centerRight,
              },
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _stat(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
