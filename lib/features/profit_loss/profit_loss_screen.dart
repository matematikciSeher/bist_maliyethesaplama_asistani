import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/calc/profit_loss_calculator.dart';
import '../../core/utils/currency.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';

/// "Kar/Zarar Simülatörü" ekranı.
///
/// Kullanıcı maliyet ve lot girer; bir kaydırıcı ile satış fiyatını değiştirir
/// ve kar/zarar hem rakam hem de anlık güncellenen bir grafik olarak gösterilir.
class ProfitLossScreen extends StatefulWidget {
  /// Üst ekrandan seçili para birimi geçirilebilir (varsayılan: TRY).
  final AppCurrency currency;

  const ProfitLossScreen({super.key, this.currency = AppCurrency.try_});

  @override
  State<ProfitLossScreen> createState() => _ProfitLossScreenState();
}

class _ProfitLossScreenState extends State<ProfitLossScreen> {
  static const _calculator = ProfitLossCalculator();

  final _costCtrl = TextEditingController();
  final _lotsCtrl = TextEditingController();

  late AppCurrency _currency = widget.currency;

  /// Kaydırıcı ile seçilen güncel fiyat. null ise maliyete eşitlenir.
  double? _price;

  @override
  void dispose() {
    _costCtrl.dispose();
    _lotsCtrl.dispose();
    super.dispose();
  }

  double get _cost => Formatters.parseInput(_costCtrl.text) ?? 0;
  double get _lots => Formatters.parseInput(_lotsCtrl.text) ?? 0;

  ProfitLossResult get _result => _calculator.simulate(
        cost: _cost,
        lots: _lots,
        price: _price ?? _cost,
      );

  void _onInputChanged() {
    // Girişler değişince kaydırıcıyı başabaş (maliyet) noktasına sıfırla.
    setState(() => _price = null);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final result = _result;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.profitLossSimulator,
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
            if (result.isValid) ...[
              _ChartCard(result: result, currency: _currency),
              const SizedBox(height: 20),
              _PriceSlider(
                result: result,
                currency: _currency,
                onChanged: (value) => setState(() => _price = value),
              ),
              const SizedBox(height: 20),
            ],
            _SectionTitle(
              icon: Icons.tune,
              title: l.yourPositionInfo,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _costCtrl,
              label: l.cost,
              hint: l.hintDecimal35,
              icon: Icons.price_change_outlined,
              suffix: _currency.symbol,
              onChanged: _onInputChanged,
            ),
            const SizedBox(height: 12),
            _NumberField(
              controller: _lotsCtrl,
              label: l.lot,
              hint: l.hintThousand,
              icon: Icons.inventory_2_outlined,
              suffix: l.lotSuffix,
              allowDecimal: false,
              onChanged: _onInputChanged,
            ),
            const SizedBox(height: 20),
            const _InfoNote(),
          ],
        ),
      ),
    );
  }
}

/// Ana sonuç kartı. Kara yeşil, zarara kırmızı tonu uygular.
class _ResultCard extends StatelessWidget {
  final ProfitLossResult result;
  final AppCurrency currency;

  const _ResultCard({required this.result, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    if (!result.isValid) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: scheme.surfaceContainerHighest,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.edit_note,
                color: scheme.onSurface.withValues(alpha: 0.7), size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l.profitLossEmptyMessage,
                style: TextStyle(
                  color: scheme.onSurface.withValues(alpha: 0.9),
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final point = result.current;
    final isProfit = point.profit >= 0;
    final base = isProfit ? _green : _red;
    const onBase = Colors.white;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base,
            Color.alphaBlend(Colors.black.withValues(alpha: 0.18), base),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isProfit ? Icons.trending_up : Icons.trending_down,
                color: onBase,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isProfit ? l.profit : l.loss,
                style: TextStyle(
                  color: onBase.withValues(alpha: 0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: onBase.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${isProfit ? '+' : ''}'
                  '${l.percentValue(Formatters.decimal(point.profitPercent))}',
                  style: const TextStyle(
                    color: onBase,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${isProfit ? '+' : ''}'
            '${Formatters.money(point.profit, currency.symbol)}',
            style: const TextStyle(
              color: onBase,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: l.salePrice,
                  value: Formatters.money(point.price, currency.symbol),
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
                  label: l.costAmount,
                  value: Formatters.money(result.totalCost, currency.symbol),
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
                  label: l.positionValue,
                  value: Formatters.money(result.totalValue, currency.symbol),
                  color: onBase,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Anlık güncellenen kar/zarar grafiği.
class _ChartCard extends StatelessWidget {
  final ProfitLossResult result;
  final AppCurrency currency;

  const _ChartCard({required this.result, required this.currency});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.show_chart, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                l.profitLossChart,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.7,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: CustomPaint(
                key: ValueKey(
                  '${result.cost}-${result.lots}-${result.current.price}',
                ),
                painter: _ProfitLossChartPainter(
                  result: result,
                  profitColor: _green,
                  lossColor: _red,
                  axisColor: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  gridColor: scheme.outlineVariant.withValues(alpha: 0.35),
                  labelColor: scheme.onSurfaceVariant,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Formatters.money(result.minPrice, currency.symbol),
                style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                l.breakEven(Formatters.money(result.cost, currency.symbol)),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                Formatters.money(result.maxPrice, currency.symbol),
                style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Kar/zarar eğrisini çizen painter. Başabaş çizgisinin üstü yeşil,
/// altı kırmızı dolgu ile gösterilir; seçili fiyatta bir işaretçi vardır.
class _ProfitLossChartPainter extends CustomPainter {
  final ProfitLossResult result;
  final Color profitColor;
  final Color lossColor;
  final Color axisColor;
  final Color gridColor;
  final Color labelColor;

  _ProfitLossChartPainter({
    required this.result,
    required this.profitColor,
    required this.lossColor,
    required this.axisColor,
    required this.gridColor,
    required this.labelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final curve = result.curve;
    if (curve.length < 2) return;

    final minPrice = result.minPrice;
    final maxPrice = result.maxPrice;
    final priceSpan = (maxPrice - minPrice).abs() < 1e-9
        ? 1.0
        : (maxPrice - minPrice);

    var maxProfit = 0.0;
    var minProfit = 0.0;
    for (final p in curve) {
      if (p.profit > maxProfit) maxProfit = p.profit;
      if (p.profit < minProfit) minProfit = p.profit;
    }
    // Simetrik ve sıfırdan farklı bir eksen aralığı sağla.
    final magnitude =
        [maxProfit.abs(), minProfit.abs()].reduce((a, b) => a > b ? a : b);
    final bound = magnitude < 1e-9 ? 1.0 : magnitude * 1.1;
    maxProfit = bound;
    minProfit = -bound;

    double dx(double price) =>
        (price - minPrice) / priceSpan * size.width;
    double dy(double profit) =>
        size.height -
        (profit - minProfit) / (maxProfit - minProfit) * size.height;

    final zeroY = dy(0);

    // Yatay sıfır (başabaş) çizgisi.
    final zeroPaint = Paint()
      ..color = axisColor
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), zeroPaint);

    // Dikey başabaş çizgisi (maliyet konumu).
    final costX = dx(result.cost);
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    _drawDashedLine(
      canvas,
      Offset(costX, 0),
      Offset(costX, size.height),
      gridPaint,
    );

    // Eğri çizgisinin yolu.
    final linePath = Path();
    for (var i = 0; i < curve.length; i++) {
      final x = dx(curve[i].price);
      final y = dy(curve[i].profit);
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }

    // Kar bölgesi dolgusu (sıfırın üstü, yeşil).
    _fillRegion(
      canvas,
      size,
      curve,
      dx,
      dy,
      zeroY,
      profitColor,
      above: true,
    );
    // Zarar bölgesi dolgusu (sıfırın altı, kırmızı).
    _fillRegion(
      canvas,
      size,
      curve,
      dx,
      dy,
      zeroY,
      lossColor,
      above: false,
    );

    // Eğri çizgisi (kar tarafı yeşil, zarar tarafı kırmızı).
    for (var i = 1; i < curve.length; i++) {
      final prev = curve[i - 1];
      final cur = curve[i];
      final paint = Paint()
        ..color = cur.profit >= 0 ? profitColor : lossColor
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(dx(prev.price), dy(prev.profit)),
        Offset(dx(cur.price), dy(cur.profit)),
        paint,
      );
    }

    // Seçili fiyat işaretçisi.
    final cur = result.current;
    final markerX = dx(cur.price);
    final markerY = dy(cur.profit);
    final markerColor = cur.profit >= 0 ? profitColor : lossColor;

    final guidePaint = Paint()
      ..color = markerColor.withValues(alpha: 0.5)
      ..strokeWidth = 1;
    _drawDashedLine(
      canvas,
      Offset(markerX, markerY),
      Offset(markerX, zeroY),
      guidePaint,
    );

    canvas.drawCircle(
      Offset(markerX, markerY),
      6,
      Paint()..color = markerColor,
    );
    canvas.drawCircle(
      Offset(markerX, markerY),
      6,
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  void _fillRegion(
    Canvas canvas,
    Size size,
    List<ProfitLossPoint> curve,
    double Function(double) dx,
    double Function(double) dy,
    double zeroY,
    Color color, {
    required bool above,
  }) {
    final path = Path();
    var started = false;
    for (var i = 0; i < curve.length; i++) {
      final x = dx(curve[i].price);
      var y = dy(curve[i].profit);
      // İlgili bölgeye kırp: kar dolgusu sıfırın üstünde, zarar altında kalır.
      if (above) {
        y = y > zeroY ? zeroY : y;
      } else {
        y = y < zeroY ? zeroY : y;
      }
      if (!started) {
        path.moveTo(x, zeroY);
        path.lineTo(x, y);
        started = true;
      } else {
        path.lineTo(x, y);
      }
    }
    path.lineTo(dx(curve.last.price), zeroY);
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    final total = (to - from).distance;
    if (total == 0) return;
    final direction = (to - from) / total;
    var drawn = 0.0;
    while (drawn < total) {
      final start = from + direction * drawn;
      final endLen = (drawn + dashWidth) > total ? total : (drawn + dashWidth);
      final end = from + direction * endLen;
      canvas.drawLine(start, end, paint);
      drawn += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _ProfitLossChartPainter oldDelegate) {
    return oldDelegate.result != result;
  }
}

/// Fiyatı değiştiren kaydırıcı ve anlık fiyat etiketi.
class _PriceSlider extends StatelessWidget {
  final ProfitLossResult result;
  final AppCurrency currency;
  final ValueChanged<double> onChanged;

  const _PriceSlider({
    required this.result,
    required this.currency,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final price = result.current.price;
    final isProfit = result.current.profit >= 0;
    final activeColor = isProfit ? _green : _red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.swipe, size: 18, color: scheme.primary),
            const SizedBox(width: 8),
            Text(
              l.salePrice,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              Formatters.money(price, currency.symbol),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: activeColor,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            thumbColor: activeColor,
            overlayColor: activeColor.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: price.clamp(result.minPrice, result.maxPrice),
            min: result.minPrice,
            max: result.maxPrice,
            onChanged: onChanged,
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
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.8),
              fontSize: 11.5,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
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
              l.profitLossInfoNote,
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

const _green = Color(0xFF1B9E5A);
const _red = Color(0xFFD23B3B);
