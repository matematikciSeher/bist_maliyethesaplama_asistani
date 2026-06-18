import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Sayı ve para biçimlendirme yardımcıları (Türkçe yerel ayar).
class Formatters {
  Formatters._();

  static final NumberFormat _decimal = NumberFormat('#,##0.##', 'tr_TR');
  static final NumberFormat _money = NumberFormat('#,##0.00', 'tr_TR');
  static final NumberFormat _quantity = NumberFormat('#,##0.####', 'tr_TR');

  /// Para tutarını sembol ile biçimler: "1.234,56 ₺"
  static String money(double value, String symbol) =>
      '${_money.format(value)} $symbol';

  /// Lot adedini biçimler (gereksiz sıfırları atar).
  static String quantity(double value) => _quantity.format(value);

  /// Genel ondalık biçim.
  static String decimal(double value) => _decimal.format(value);

  static final DateFormat _date = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');
  static String dateTime(DateTime value) => _date.format(value);

  /// Kullanıcı girişini güvenli şekilde double'a çevirir.
  /// Hem "12,5" hem "12.5" girişini kabul eder.
  static double? parseInput(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    // Türkçe ondalık ayırıcı virgülü noktaya çevir; binlik ayırıcıları kaldır.
    final normalized = text.replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(normalized) ?? double.tryParse(text);
    return value;
  }
}

/// Girilen sayıyı yazarken binlik basamakları "." ile ayıran formatter.
/// Türkçe formata uygundur: binlik "." , ondalık "," .
/// Örn: "1234567" -> "1.234.567", "1234,5" -> "1.234,5".
class ThousandsInputFormatter extends TextInputFormatter {
  /// Ondalık basamak sınırı. Negatif değer = sınırsız.
  final int decimalDigits;

  ThousandsInputFormatter({this.decimalDigits = -1});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // Yalnızca rakam ve virgülleri tut (eski "." ayırıcıları kaldırılır).
    final raw = newValue.text.replaceAll(RegExp(r'[^0-9,]'), '');

    final commaIndex = raw.indexOf(',');
    final hasComma = commaIndex >= 0;

    String intPart;
    String decPart = '';
    if (hasComma) {
      intPart = raw.substring(0, commaIndex);
      decPart = raw.substring(commaIndex + 1).replaceAll(',', '');
      if (decimalDigits >= 0 && decPart.length > decimalDigits) {
        decPart = decPart.substring(0, decimalDigits);
      }
    } else {
      intPart = raw;
    }

    final grouped = _group(intPart);
    final result = hasComma ? '$grouped,$decPart' : grouped;

    // İmleci, kullanıcının yazdığı konumdan önceki "anlamlı" karakter
    // (rakam/virgül) sayısına göre yeniden konumla.
    final before = newValue.text.substring(0, newValue.selection.end);
    final sigBefore = before.replaceAll(RegExp(r'[^0-9,]'), '').length;

    var offset = 0;
    var count = 0;
    while (offset < result.length && count < sigBefore) {
      if (RegExp(r'[0-9,]').hasMatch(result[offset])) count++;
      offset++;
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: offset),
    );
  }

  String _group(String digits) {
    if (digits.isEmpty) return '';
    final buffer = StringBuffer();
    final len = digits.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write('.');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
