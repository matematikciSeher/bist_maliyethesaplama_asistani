import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/calculation.dart';

/// Kaydedilmiş hesapları cihazda saklar (SharedPreferences) ve
/// JSON ile içe/dışa aktarma sağlar.
class CalculationRepository {
  static const _key = 'saved_calculations_v1';
  final SharedPreferences _prefs;

  CalculationRepository(this._prefs);

  List<Calculation> loadAll() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final items = list
          .map((e) => Calculation.fromJson(e as Map<String, dynamic>))
          .toList();
      items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return items;
    } catch (_) {
      return [];
    }
  }

  Future<void> _persist(List<Calculation> items) async {
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await _prefs.setString(_key, raw);
  }

  /// Var olan id ile günceller, yoksa ekler.
  Future<List<Calculation>> save(Calculation calculation) async {
    final items = loadAll();
    final index = items.indexWhere((e) => e.id == calculation.id);
    if (index >= 0) {
      items[index] = calculation;
    } else {
      items.add(calculation);
    }
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _persist(items);
    return items;
  }

  Future<List<Calculation>> delete(String id) async {
    final items = loadAll()..removeWhere((e) => e.id == id);
    await _persist(items);
    return items;
  }

  /// Tüm hesapları dışa aktarmak için JSON string üretir.
  String exportJson() {
    final items = loadAll();
    final payload = {
      'app': 'bist_maliyet_asistani',
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'calculations': items.map((e) => e.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// JSON içe aktarır. [merge] true ise mevcutlarla birleştirir,
  /// false ise üzerine yazar. Eklenen kayıt sayısını döndürür.
  Future<int> importJson(String jsonStr, {bool merge = true}) async {
    final decoded = jsonDecode(jsonStr);
    final List<dynamic> rawList;
    if (decoded is Map<String, dynamic>) {
      rawList = (decoded['calculations'] as List<dynamic>?) ?? [];
    } else if (decoded is List) {
      rawList = decoded;
    } else {
      throw const FormatException('Geçersiz dosya biçimi');
    }

    final imported = rawList
        .map((e) => Calculation.fromJson(e as Map<String, dynamic>))
        .toList();

    final current = merge ? loadAll() : <Calculation>[];
    final byId = {for (final c in current) c.id: c};
    for (final c in imported) {
      byId[c.id] = c;
    }
    final result = byId.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    await _persist(result);
    return imported.length;
  }
}
