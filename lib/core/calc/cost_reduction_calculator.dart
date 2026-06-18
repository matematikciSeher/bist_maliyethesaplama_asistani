/// "Akıllı Maliyet Düşürme" hesabının olası durumları.
enum CostReductionStatus {
  /// Geçerli bir sonuç üretildi.
  ok,

  /// Zorunlu alanların biri eksik veya geçersiz (<= 0).
  incompleteInput,

  /// Hedef maliyet mevcut ortalamadan düşük değil (düşürülecek bir şey yok).
  targetNotLower,

  /// Güncel fiyat hedefin altında değil; bu fiyattan alım hedefe ulaştıramaz.
  priceNotBelowTarget,
}

/// Maliyet düşürme hesabının sonucu.
class CostReductionResult {
  final CostReductionStatus status;

  /// Hedefe ulaşmak için bu fiyattan alınması gereken ek lot adedi.
  final double lotsToBuy;

  /// Ek alım için gereken tutar: lotsToBuy × güncel fiyat.
  final double additionalInvestment;

  /// Alım sonrası toplam lot: mevcut lot + lotsToBuy.
  final double newTotalLots;

  /// Hesaplamaya giren mevcut ortalama maliyet (mesajda gösterilir).
  final double startAverage;

  /// Alım sonrası ulaşılan ortalama maliyet (hedefe eşittir).
  final double newAverageCost;

  const CostReductionResult({
    required this.status,
    this.lotsToBuy = 0,
    this.additionalInvestment = 0,
    this.newTotalLots = 0,
    this.startAverage = 0,
    this.newAverageCost = 0,
  });

  bool get isOk => status == CostReductionStatus.ok;
}

/// Saf (yan etkisiz) maliyet düşürme motoru.
///
/// Kullanıcının elindeki pozisyona, güncel fiyattan kaç lot daha eklerse
/// ortalama maliyetinin istediği hedefe ineceğini hesaplar.
class CostReductionCalculator {
  const CostReductionCalculator();

  /// [currentLots] adet hisseyi [averageCost] ortalama maliyetle tutan bir
  /// yatırımcının, [currentPrice] fiyattan kaç lot daha alırsa ortalamasının
  /// [targetCost] olacağını hesaplar.
  ///
  /// Formül:
  ///   (lot×ort + x×fiyat) / (lot + x) = hedef
  ///   => x = lot × (hedef − ort) / (fiyat − hedef)
  CostReductionResult calculate({
    required double currentLots,
    required double averageCost,
    required double currentPrice,
    required double targetCost,
  }) {
    if (currentLots <= 0 ||
        averageCost <= 0 ||
        currentPrice <= 0 ||
        targetCost <= 0) {
      return const CostReductionResult(
        status: CostReductionStatus.incompleteInput,
      );
    }

    // Hedef, mevcut ortalamadan düşük olmalı (amaç maliyeti düşürmek).
    if (targetCost >= averageCost) {
      return const CostReductionResult(
        status: CostReductionStatus.targetNotLower,
      );
    }

    // Ortalamayı hedefin altına çekmek için, eklenen lotlar hedefin
    // altında bir fiyattan alınmalı. Aksi halde hedefe ulaşmak imkânsız.
    if (currentPrice >= targetCost) {
      return const CostReductionResult(
        status: CostReductionStatus.priceNotBelowTarget,
      );
    }

    final lotsToBuy =
        currentLots * (targetCost - averageCost) / (currentPrice - targetCost);
    final newTotalLots = currentLots + lotsToBuy;

    return CostReductionResult(
      status: CostReductionStatus.ok,
      lotsToBuy: lotsToBuy,
      additionalInvestment: lotsToBuy * currentPrice,
      newTotalLots: newTotalLots,
      startAverage: averageCost,
      newAverageCost: targetCost,
    );
  }
}
