/// Temettü hesabının olası durumları.
enum DividendStatus {
  /// Geçerli bir sonuç üretildi.
  ok,

  /// Zorunlu alanların biri eksik veya geçersiz (<= 0).
  incompleteInput,
}

/// Temettü hesabının sonucu.
class DividendResult {
  final DividendStatus status;

  /// Vergi öncesi (brüt) toplam temettü: lot × hisse başına temettü.
  final double grossDividend;

  /// Stopaj sonrası (net) toplam temettü.
  final double netDividend;

  /// Uygulanan stopaj tutarı: brüt − net.
  final double taxAmount;

  /// Temettü verim oranı (%): hisse başına temettü / hisse fiyatı × 100.
  /// Hisse fiyatı girilmemişse 0 döner.
  final double yieldPercent;

  const DividendResult({
    required this.status,
    this.grossDividend = 0,
    this.netDividend = 0,
    this.taxAmount = 0,
    this.yieldPercent = 0,
  });

  bool get isOk => status == DividendStatus.ok;

  /// Verim oranı hesaplanabildi mi (hisse fiyatı girildi mi)?
  bool get hasYield => yieldPercent > 0;
}

/// Saf (yan etkisiz) temettü hesaplama motoru.
///
/// Kullanıcının elindeki lot adedi ve hisse başına dağıtılan brüt temettüden
/// yola çıkarak brüt/net temettü tutarını ve (fiyat verildiyse) verim oranını
/// hesaplar.
class DividendCalculator {
  const DividendCalculator();

  /// Türkiye'de pay sahiplerine dağıtılan temettü için güncel stopaj oranı.
  static const double defaultTaxRate = 0.15;

  /// [lots] adet hisse için, hisse başına [dividendPerShare] brüt temettü
  /// dağıtıldığında oluşan brüt/net temettüyü hesaplar.
  ///
  /// [taxRate] stopaj oranıdır (0–1 arası; örn. 0,15 = %15).
  /// [sharePrice] verilirse verim oranı (temettü / fiyat) hesaplanır.
  DividendResult calculate({
    required double lots,
    required double dividendPerShare,
    double taxRate = defaultTaxRate,
    double sharePrice = 0,
  }) {
    if (lots <= 0 || dividendPerShare <= 0) {
      return const DividendResult(status: DividendStatus.incompleteInput);
    }

    final clampedTax = taxRate.clamp(0.0, 1.0);
    final gross = lots * dividendPerShare;
    final tax = gross * clampedTax;
    final net = gross - tax;

    final yieldPercent =
        sharePrice > 0 ? (dividendPerShare / sharePrice) * 100 : 0.0;

    return DividendResult(
      status: DividendStatus.ok,
      grossDividend: gross,
      netDividend: net,
      taxAmount: tax,
      yieldPercent: yieldPercent,
    );
  }
}
