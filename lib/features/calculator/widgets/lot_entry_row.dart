import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/utils/currency.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/app_localizations.dart';

/// Tek bir alım satırı: sıra no, fiyat, lot, hesaplanan tutar ve sil butonu.
class LotEntryRow extends StatefulWidget {
  final int index;
  final double initialPrice;
  final double initialQuantity;
  final AppCurrency currency;
  final void Function(double? price, double? quantity) onChanged;
  final VoidCallback onDelete;

  const LotEntryRow({
    super.key,
    required this.index,
    required this.initialPrice,
    required this.initialQuantity,
    required this.currency,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<LotEntryRow> createState() => _LotEntryRowState();
}

class _LotEntryRowState extends State<LotEntryRow> {
  late final TextEditingController _priceCtrl;
  late final TextEditingController _qtyCtrl;
  double _price = 0;
  double _qty = 0;

  @override
  void initState() {
    super.initState();
    _price = widget.initialPrice;
    _qty = widget.initialQuantity;
    _priceCtrl = TextEditingController(
      text: widget.initialPrice > 0
          ? Formatters.decimal(widget.initialPrice)
          : '',
    );
    _qtyCtrl = TextEditingController(
      text: widget.initialQuantity > 0
          ? Formatters.quantity(widget.initialQuantity)
          : '',
    );
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    _price = Formatters.parseInput(_priceCtrl.text) ?? 0;
    _qty = Formatters.parseInput(_qtyCtrl.text) ?? 0;
    setState(() {});
    widget.onChanged(_price, _qty);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final amount = _price * _qty;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                '${widget.index}',
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: TextField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ThousandsInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: l.price,
                  isDense: true,
                ),
                onChanged: (_) => _emit(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('×', style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 4,
              child: TextField(
                controller: _qtyCtrl,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ThousandsInputFormatter(),
                ],
                decoration: InputDecoration(
                  labelText: l.lot,
                  isDense: true,
                ),
                onChanged: (_) => _emit(),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.amount,
                      style: TextStyle(
                        fontSize: 11,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.money(amount, widget.currency.symbol),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close, size: 20, color: scheme.error),
              tooltip: l.deleteRow,
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
