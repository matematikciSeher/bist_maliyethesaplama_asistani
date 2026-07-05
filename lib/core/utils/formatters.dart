import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Sayı, para ve tarih biçimlendirme yardımcıları.
///
/// Uygulama açılışında [configure] ile cihazın diline göre ayarlanır:
/// Türkçe için binlik "." / ondalık "," , İngilizce için binlik "," / ondalık "."
class Formatters {
  Formatters._();

  static bool _turkish = true;

  static NumberFormat _decimalFmt = NumberFormat('#,##0.##', 'tr_TR');
  static NumberFormat _moneyFmt = NumberFormat('#,##0.00', 'tr_TR');
  static NumberFormat _quantityFmt = NumberFormat('#,##0.####', 'tr_TR');
  static DateFormat _dateFmt = DateFormat('dd.MM.yyyy HH:mm', 'tr_TR');

  /// Uygulama açılışında bir kez çağrılır.
  static void configure(String localeName) {
    _turkish = localeName.startsWith('tr');
    _decimalFmt = NumberFormat('#,##0.##', localeName);
    _moneyFmt = NumberFormat('#,##0.00', localeName);
    _quantityFmt = NumberFormat('#,##0.####', localeName);
    _dateFmt = _turkish
        ? DateFormat('dd.MM.yyyy HH:mm', localeName)
        : DateFormat('MM/dd/yyyy HH:mm', localeName);
  }

  /// Girişte kullanılan ondalık ayırıcı (TR: "," / EN: ".").
  static String get decimalSeparator => _turkish ? ',' : '.';

  /// Girişte kullanılan binlik ayırıcı (TR: "." / EN: ",").
  static String get groupSeparator => _turkish ? '.' : ',';

  /// Para tutarını sembol ile biçimler: "1.234,56 ₺" / "1,234.56 $"
  static String money(double value, String symbol) =>
      '${_moneyFmt.format(value)} $symbol';

  /// Lot adedini biçimler (gereksiz sıfırları atar).
  static String quantity(double value) => _quantityFmt.format(value);

  /// Genel ondalık biçim.
  static String decimal(double value) => _decimalFmt.format(value);

  static String dateTime(DateTime value) => _dateFmt.format(value);

  /// Kullanıcı girişini güvenli şekilde double'a çevirir.
  /// Aktif dile göre binlik/ondalık ayırıcılarını dikkate alır; hem "12,5"
  /// hem "12.5" girişini kabul etmeye çalışır.
  static double? parseInput(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    final String normalized;
    if (_turkish) {
      // Binlik "." kaldır, ondalık "," -> "."
      normalized = text.replaceAll('.', '').replaceAll(',', '.');
    } else {
      // Binlik "," kaldır, ondalık "." zaten uygun.
      normalized = text.replaceAll(',', '');
    }
    return double.tryParse(normalized) ?? double.tryParse(text);
  }
}

/// Girilen sayıyı yazarken binlik basamakları ayıran formatter.
/// Aktif dile göre ayırıcıları [Formatters]'tan alır (TR: binlik "." ondalık "," ,
/// EN: binlik "," ondalık ".").
class ThousandsInputFormatter extends TextInputFormatter {
  /// Ondalık basamak sınırı. Negatif değer = sınırsız.
  final int decimalDigits;
  final String groupSep;
  final String decimalSep;

  ThousandsInputFormatter({
    this.decimalDigits = -1,
    String? groupSeparator,
    String? decimalSeparator,
  })  : groupSep = groupSeparator ?? Formatters.groupSeparator,
        decimalSep = decimalSeparator ?? Formatters.decimalSeparator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final decEsc = RegExp.escape(decimalSep);
    // Yalnızca rakam ve ondalık ayırıcıyı tut (binlik ayırıcılar kaldırılır).
    final keepAllowed = RegExp('[^0-9$decEsc]');
    final sigAllowed = RegExp('[0-9$decEsc]');
    final raw = newValue.text.replaceAll(keepAllowed, '');

    final sepIndex = raw.indexOf(decimalSep);
    final hasSep = sepIndex >= 0;

    String intPart;
    String decPart = '';
    if (hasSep) {
      intPart = raw.substring(0, sepIndex);
      decPart = raw.substring(sepIndex + 1).replaceAll(decimalSep, '');
      if (decimalDigits >= 0 && decPart.length > decimalDigits) {
        decPart = decPart.substring(0, decimalDigits);
      }
    } else {
      intPart = raw;
    }

    final grouped = _group(intPart);
    final result = hasSep ? '$grouped$decimalSep$decPart' : grouped;

    // İmleci, kullanıcının yazdığı konumdan önceki "anlamlı" karakter
    // (rakam/ondalık ayırıcı) sayısına göre yeniden konumla.
    final before = newValue.text.substring(0, newValue.selection.end);
    final sigBefore = before.replaceAll(keepAllowed, '').length;

    var offset = 0;
    var count = 0;
    while (offset < result.length && count < sigBefore) {
      if (sigAllowed.hasMatch(result[offset])) count++;
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
      if (i > 0 && (len - i) % 3 == 0) buffer.write(groupSep);
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
