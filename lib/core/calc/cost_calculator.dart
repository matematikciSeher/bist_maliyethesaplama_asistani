import '../../data/models/lot_entry.dart';

/// Maliyet hesabının sonucu.
class CostResult {
  /// Toplam lot adedi: Σ(adet)
  final double totalQuantity;

  /// Toplam yatırılan tutar: Σ(fiyat × adet)
  final double totalAmount;

  /// Ortalama birim maliyet: toplam tutar / toplam lot
  final double averageCost;

  const CostResult({
    required this.totalQuantity,
    required this.totalAmount,
    required this.averageCost,
  });

  static const empty =
      CostResult(totalQuantity: 0, totalAmount: 0, averageCost: 0);

  bool get isEmpty => totalQuantity == 0 && totalAmount == 0;
}

/// Saf (yan etkisiz) hesaplama motoru. UI'dan bağımsız olarak test edilebilir.
class CostCalculator {
  const CostCalculator();

  /// Verilen alım satırlarından ortalama maliyeti hesaplar.
  CostResult calculate(List<LotEntry> entries) {
    double quantity = 0;
    double amount = 0;
    for (final entry in entries) {
      // Geçersiz/negatif değerleri hesaba katma.
      if (entry.price <= 0 || entry.quantity <= 0) continue;
      quantity += entry.quantity;
      amount += entry.price * entry.quantity;
    }
    final average = quantity == 0 ? 0.0 : amount / quantity;
    return CostResult(
      totalQuantity: quantity,
      totalAmount: amount,
      averageCost: average,
    );
  }

  /// "Maliyet düşürme" yardımcısı: mevcut pozisyona [buyPrice] fiyattan
  /// kaç lot eklenirse ortalama maliyetin [targetAverage] olacağını döndürür.
  /// Hedef ulaşılamazsa null döner.
  double? lotsNeededForTargetAverage({
    required List<LotEntry> currentEntries,
    required double buyPrice,
    required double targetAverage,
  }) {
    final current = calculate(currentEntries);
    if (buyPrice <= 0 || targetAverage <= 0) return null;

    // (totalAmount + buyPrice * x) / (totalQty + x) = target
    // => x = (totalAmount - target * totalQty) / (target - buyPrice)
    final denominator = targetAverage - buyPrice;
    if (denominator == 0) return null;
    final x =
        (current.totalAmount - targetAverage * current.totalQuantity) /
            denominator;
    if (x <= 0) return null;
    return x;
  }
}
