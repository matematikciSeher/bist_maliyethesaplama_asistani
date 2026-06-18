import 'package:flutter/material.dart';

import '../../../core/calc/cost_calculator.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/formatters.dart';

/// Ortalama maliyet, toplam lot ve toplam tutarı gösteren özet kartı.
class ResultCard extends StatelessWidget {
  final CostResult result;
  final AppCurrency currency;

  const ResultCard({
    super.key,
    required this.result,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary,
            Color.alphaBlend(
              Colors.black.withValues(alpha: 0.15),
              scheme.primary,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ortalama Maliyetiniz',
            style: TextStyle(
              color: scheme.onPrimary.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            Formatters.money(result.averageCost, currency.symbol),
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Toplam Lot',
                  value: Formatters.quantity(result.totalQuantity),
                  color: scheme.onPrimary,
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: scheme.onPrimary.withValues(alpha: 0.25),
              ),
              Expanded(
                child: _MiniStat(
                  label: 'Toplam Tutar',
                  value: Formatters.money(result.totalAmount, currency.symbol),
                  color: scheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
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
