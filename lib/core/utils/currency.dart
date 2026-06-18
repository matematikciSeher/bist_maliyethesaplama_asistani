/// Uygulamada desteklenen para birimleri.
class AppCurrency {
  final String code;
  final String symbol;
  final String label;

  const AppCurrency(this.code, this.symbol, this.label);

  static const try_ = AppCurrency('TRY', '\u20BA', 'Türk Lirası');
  static const usd = AppCurrency('USD', '\$', 'ABD Doları');
  static const eur = AppCurrency('EUR', '\u20AC', 'Euro');

  static const all = [try_, usd, eur];

  static AppCurrency byCode(String code) =>
      all.firstWhere((c) => c.code == code, orElse: () => try_);
}
