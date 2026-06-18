import 'package:uuid/uuid.dart';

import 'lot_entry.dart';

/// Kaydedilebilir bir maliyet hesabı. Bir hisseye ait birden fazla
/// alım satırını ve para birimini taşır.
class Calculation {
  final String id;
  final String name;
  final String currencyCode;
  final List<LotEntry> entries;
  final DateTime updatedAt;

  const Calculation({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.entries,
    required this.updatedAt,
  });

  factory Calculation.create({
    required String name,
    required String currencyCode,
    required List<LotEntry> entries,
  }) =>
      Calculation(
        id: const Uuid().v4(),
        name: name,
        currencyCode: currencyCode,
        entries: entries,
        updatedAt: DateTime.now(),
      );

  Calculation copyWith({
    String? name,
    String? currencyCode,
    List<LotEntry>? entries,
    DateTime? updatedAt,
  }) =>
      Calculation(
        id: id,
        name: name ?? this.name,
        currencyCode: currencyCode ?? this.currencyCode,
        entries: entries ?? this.entries,
        updatedAt: updatedAt ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'currencyCode': currencyCode,
        'entries': entries.map((e) => e.toJson()).toList(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Calculation.fromJson(Map<String, dynamic> json) => Calculation(
        id: json['id'] as String? ?? const Uuid().v4(),
        name: json['name'] as String? ?? 'Adsız',
        currencyCode: json['currencyCode'] as String? ?? 'TRY',
        entries: (json['entries'] as List<dynamic>? ?? [])
            .map((e) => LotEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
      );
}
