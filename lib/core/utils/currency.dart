import '../../l10n/app_localizations.dart';

/// Uygulamada desteklenen para birimleri.
class AppCurrency {
  final String code;
  final String symbol;

  /// Yerelleştirme yokken (ör. testte) kullanılan yedek etiket.
  final String fallbackLabel;

  const AppCurrency(this.code, this.symbol, this.fallbackLabel);

  static const try_ = AppCurrency('TRY', '\u20BA', 'Türk Lirası');
  static const usd = AppCurrency('USD', '\$', 'ABD Doları');
  static const eur = AppCurrency('EUR', '\u20AC', 'Euro');

  static const all = [try_, usd, eur];

  static AppCurrency byCode(String code) =>
      all.firstWhere((c) => c.code == code, orElse: () => try_);

  /// Aktif dile göre para birimi adı.
  String label(AppLocalizations l) {
    switch (code) {
      case 'USD':
        return l.currencyUSDLabel;
      case 'EUR':
        return l.currencyEURLabel;
      case 'TRY':
      default:
        return l.currencyTRYLabel;
    }
  }
}
