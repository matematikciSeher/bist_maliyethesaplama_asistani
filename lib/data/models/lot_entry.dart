import 'package:uuid/uuid.dart';

/// Tek bir alım işlemini temsil eder: belirli bir [price] fiyattan
/// [quantity] adet lot alınması.
class LotEntry {
  final String id;
  final double price;
  final double quantity;

  const LotEntry({
    required this.id,
    required this.price,
    required this.quantity,
  });

  /// Yeni boş bir satır üretir (UI'da "Satır Ekle" için).
  factory LotEntry.empty() =>
      LotEntry(id: const Uuid().v4(), price: 0, quantity: 0);

  /// Bu satırın toplam tutarı (fiyat × lot).
  double get amount => price * quantity;

  LotEntry copyWith({double? price, double? quantity}) => LotEntry(
        id: id,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'quantity': quantity,
      };

  factory LotEntry.fromJson(Map<String, dynamic> json) => LotEntry(
        id: json['id'] as String? ?? const Uuid().v4(),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      );
}
