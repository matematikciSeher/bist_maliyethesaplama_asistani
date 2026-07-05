import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/calc/dividend_calculator.dart';
import '../../core/utils/currency.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';

/// "Temettü Hesaplama" ekranı.
///
/// Kullanıcı lot sayısı ve hisse başına brüt temettüyü girer; uygulama brüt ve
/// net (stopaj sonrası) temettüyü, fiyat girilirse verim oranını hesaplar.
class DividendScreen extends StatefulWidget {
  /// Üst ekrandan seçili para birimi geçirilebilir (varsayılan: TRY).
  final AppCurrency currency;

  const DividendScreen({super.key, this.currency = AppCurrency.try_});

  @override
  State<DividendScreen> createState() => _DividendScreenState();
}

class _DividendScreenState extends State<DividendScreen> {
  static const _calculator = DividendCalculator();

  final _lotsCtrl = TextEditingController();
  final _dividendCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _taxCtrl = TextEditingController(text: '15');

  late AppCurrency _currency = widget.currency;

  @override
  void dispose() {
    _lotsCtrl.dispose();
    _dividendCtrl.dispose();
    _priceCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  double get _lots => Formatters.parseInput(_lotsCtrl.text) ?? 0;
  double get _dividend => Formatters.parseInput(_dividendCtrl.text) ?? 0;
  double get _price => Formatters.parseInput(_priceCtrl.text) ?? 0;
  double get _taxRate => (Formatters.parseInput(_taxCtrl.text) ?? 0) / 100;

  DividendResult get _result => _calculator.calculate(
        lots: _lots,
        dividendPerShare: _dividend,
        taxRate: _taxRate,
        sharePrice: _price,
      );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.dividendCalculation,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: l.currencyTooltip,
            onSelected: (code) =>
                setState(() => _currency = AppCurrency.byCode(code)),
            itemBuilder: (_) => [
              for (final c in AppCurrency.all)
                PopupMenuItem(
                  value: c.code,
                  child: Text('${c.symbol}  ${c.code} — ${c.label(l)}'),
                ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currency.symbol,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _ResultCard(result: result, currency: _currency),
            const SizedBox(height: 20),
            _SectionTitle(
              icon: Icons.tune,
              title: l.dividendInfoSection,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _lotsCtrl,
              label: l.numberOfLots,
              hint: l.hintThousand,
              icon: Icons.inventory_2_outlined,
              suffix: l.lotSuffix,
              allowDecimal: false,
              onChanged: _onChanged,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _dividendCtrl,
              label: l.dividendPerShareGross,
              hint: l.hintDecimal250,
              icon: Icons.payments_outlined,
              suffix: _currency.symbol,
              onChanged: _onChanged,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _taxCtrl,
              label: l.withholdingRate,
              hint: l.hint15,
              icon: Icons.percent,
              suffix: '%',
              onChanged: _onChanged,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _priceCtrl,
              label: l.sharePriceForYield,
              hint: l.hintDecimal32,
              icon: Icons.show_chart,
              suffix: _currency.symbol,
              onChanged: _onChanged,
            ),
            const SizedBox(height: 20),
            const _InfoNote(),
          ],
        ),
      ),
    );
  }

  void _onChanged() => setState(() {});
}

/// Ana sonuç kartı. Gradient stilini diğer ekranlarla uyumlu tutar.
class _ResultCard extends StatelessWidget {
  final DividendResult result;
  final AppCurrency currency;

  const _ResultCard({required this.result, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final ok = result.isOk;
    final base = ok ? scheme.primary : scheme.surfaceContainerHighest;
    final onBase = ok ? scheme.onPrimary : scheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: ok
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  base,
                  Color.alphaBlend(
                    Colors.black.withValues(alpha: 0.15),
                    base,
                  ),
                ],
              )
            : null,
        color: ok ? null : base,
      ),
      child: ok ? _buildOk(l, onBase) : _buildMessage(l, onBase),
    );
  }

  Widget _buildOk(AppLocalizations l, Color onBase) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.savings_outlined, color: onBase, size: 20),
            const SizedBox(width: 8),
            Text(
              l.netDividend,
              style: TextStyle(
                color: onBase.withValues(alpha: 0.85),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          Formatters.money(result.netDividend, currency.symbol),
          style: TextStyle(
            color: onBase,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _MiniStat(
                label: l.grossDividend,
                value: Formatters.money(result.grossDividend, currency.symbol),
                color: onBase,
              ),
            ),
            Container(
              width: 1,
              height: 36,
              color: onBase.withValues(alpha: 0.25),
            ),
            Expanded(
              child: _MiniStat(
                label: l.withholdingDeduction,
                value: Formatters.money(result.taxAmount, currency.symbol),
                color: onBase,
              ),
            ),
            if (result.hasYield) ...[
              Container(
                width: 1,
                height: 36,
                color: onBase.withValues(alpha: 0.25),
              ),
              Expanded(
                child: _MiniStat(
                  label: l.yieldRate,
                  value: l.percentValue(Formatters.decimal(result.yieldPercent)),
                  color: onBase,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMessage(AppLocalizations l, Color onBase) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.edit_note, color: onBase.withValues(alpha: 0.7), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            l.dividendEmptyMessage,
            style: TextStyle(
              color: onBase.withValues(alpha: 0.9),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String suffix;
  final bool allowDecimal;
  final VoidCallback onChanged;

  const _NumberField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.suffix,
    required this.onChanged,
    this.allowDecimal = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ThousandsInputFormatter(decimalDigits: allowDecimal ? -1 : 0),
      ],
      onChanged: (_) => onChanged(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixText: suffix,
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline,
              size: 18, color: scheme.onSurfaceVariant),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l.dividendInfoNote,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.4,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
