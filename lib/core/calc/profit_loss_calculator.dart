/// Kar/Zarar simülasyonunun tek bir fiyat noktasındaki sonucu.
class ProfitLossPoint {
  /// Senaryo fiyatı (hisse başına).
  final double price;

  /// Toplam kar/zarar tutarı: (fiyat − maliyet) × lot.
  final double profit;

  /// Maliyete göre yüzdesel değişim.
  final double profitPercent;

  const ProfitLossPoint({
    required this.price,
    required this.profit,
    required this.profitPercent,
  });

  bool get isProfit => profit > 0;
  bool get isLoss => profit < 0;
}

/// Kar/Zarar simülasyonunun tam sonucu.
class ProfitLossResult {
  /// Girişler geçerli mi (maliyet ve lot > 0).
  final bool isValid;

  /// Ortalama maliyet (hisse başına).
  final double cost;

  /// Lot adedi.
  final double lots;

  /// Seçili (kaydırıcıdaki) fiyat noktası.
  final ProfitLossPoint current;

  /// Toplam alış maliyeti: maliyet × lot.
  final double totalCost;

  /// Seçili fiyattaki toplam pozisyon değeri: fiyat × lot.
  final double totalValue;

  /// Grafiği çizmek için fiyat aralığındaki örnek noktalar.
  final List<ProfitLossPoint> curve;

  /// Kaydırıcı için önerilen minimum fiyat.
  final double minPrice;

  /// Kaydırıcı için önerilen maksimum fiyat.
  final double maxPrice;

  const ProfitLossResult({
    required this.isValid,
    required this.cost,
    required this.lots,
    required this.current,
    required this.totalCost,
    required this.totalValue,
    required this.curve,
    required this.minPrice,
    required this.maxPrice,
  });

  static const empty = ProfitLossResult(
    isValid: false,
    cost: 0,
    lots: 0,
    current: ProfitLossPoint(price: 0, profit: 0, profitPercent: 0),
    totalCost: 0,
    totalValue: 0,
    curve: [],
    minPrice: 0,
    maxPrice: 0,
  );
}

/// Saf (yan etkisiz) kar/zarar motoru.
///
/// Belirli bir maliyet ve lot ile tutulan pozisyonun, farklı satış
/// fiyatlarındaki kar/zararını hesaplar. Grafiği beslemek için fiyat
/// aralığı boyunca örnek noktalar üretir.
class ProfitLossCalculator {
  const ProfitLossCalculator();

  /// Tek bir fiyat için kar/zararı hesaplar.
  ProfitLossPoint pointFor({
    required double cost,
    required double lots,
    required double price,
  }) {
    final profit = (price - cost) * lots;
    final profitPercent = cost > 0 ? (price - cost) / cost * 100 : 0.0;
    return ProfitLossPoint(
      price: price,
      profit: profit,
      profitPercent: profitPercent,
    );
  }

  /// Kaydırıcı sınırlarını maliyete göre belirler.
  ///
  /// Aralık 0 ile maliyetin iki katı arasındadır; böylece başabaş noktası
  /// (maliyet) her zaman aralığın ortasında kalır.
  (double min, double max) priceBounds(double cost) {
    if (cost <= 0) return (0, 100);
    return (0, cost * 2);
  }

  /// Verilen pozisyon ve seçili fiyat için tam simülasyon sonucunu döndürür.
  ///
  /// [samples] grafik eğrisi için üretilecek nokta sayısıdır.
  ProfitLossResult simulate({
    required double cost,
    required double lots,
    required double price,
    int samples = 60,
  }) {
    if (cost <= 0 || lots <= 0) return ProfitLossResult.empty;

    final (minPrice, maxPrice) = priceBounds(cost);
    final clampedPrice = price.clamp(minPrice, maxPrice);
    final current =
        pointFor(cost: cost, lots: lots, price: clampedPrice);

    final curve = <ProfitLossPoint>[];
    final span = maxPrice - minPrice;
    for (var i = 0; i <= samples; i++) {
      final p = minPrice + span * (i / samples);
      curve.add(pointFor(cost: cost, lots: lots, price: p));
    }

    return ProfitLossResult(
      isValid: true,
      cost: cost,
      lots: lots,
      current: current,
      totalCost: cost * lots,
      totalValue: clampedPrice * lots,
      curve: curve,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
  }
}
