import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/pdf_export_service.dart';
import '../../core/utils/currency.dart';
import '../../l10n/app_localizations.dart';
import '../cost_reduction/cost_reduction_screen.dart';
import '../dividend/dividend_screen.dart';
import '../profit_loss/profit_loss_screen.dart';
import '../settings/settings_screen.dart';
import 'calculator_providers.dart';
import 'widgets/lot_entry_row.dart';
import 'widgets/result_card.dart';
import 'widgets/saved_calculations_sheet.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(l.appTitle, maxLines: 1, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      drawer: _AppDrawer(
        currency: state.currency,
        onSelectCurrency: notifier.setCurrency,
        onCostReduction: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => CostReductionScreen(currency: state.currency))),
        onDividend: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => DividendScreen(currency: state.currency))),
        onProfitLoss: () =>
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfitLossScreen(currency: state.currency))),
        onSettings: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
        onMenu: (value) => _onMenu(context, ref, value, messenger),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            ResultCard(result: state.result, currency: state.currency),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  l.yourPurchases,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (state.editingId != null)
                  Chip(
                    label: Text(state.name.isEmpty ? l.recordChip : state.name),
                    avatar: const Icon(Icons.bookmark, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            for (int i = 0; i < state.entries.length; i++)
              LotEntryRow(
                key: ValueKey(state.entries[i].id),
                index: i + 1,
                initialPrice: state.entries[i].price,
                initialQuantity: state.entries[i].quantity,
                currency: state.currency,
                onChanged: (price, qty) => notifier.updateEntry(state.entries[i].id, price: price, quantity: qty),
                onDelete: () => notifier.removeEntry(state.entries[i].id),
              ),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: notifier.addEntry,
              icon: const Icon(Icons.add),
              label: Text(l.addRow),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveFlow(context, ref, messenger),
        icon: const Icon(Icons.save),
        label: Text(l.save),
      ),
      // bottomNavigationBar: const BannerAdWidget(),
    );
  }

  Future<void> _onMenu(BuildContext context, WidgetRef ref, String value, ScaffoldMessengerState messenger) async {
    final l = AppLocalizations.of(context);
    switch (value) {
      case 'list':
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const SavedCalculationsSheet(),
        );
      case 'pdf':
        await _createPdf(ref, messenger, l);
    }
  }

  Future<void> _saveFlow(BuildContext context, WidgetRef ref, ScaffoldMessengerState messenger) async {
    final l = AppLocalizations.of(context);
    final state = ref.read(calculatorProvider);
    if (!state.hasUnsavedData) {
      messenger.showSnackBar(SnackBar(content: Text(l.enterAtLeastOnePurchase)));
      return;
    }
    final name = await _askName(context, state.name);
    if (name == null) return;
    final notifier = ref.read(calculatorProvider.notifier);
    final calc = notifier.toCalculation(name.trim());
    await ref.read(savedCalculationsProvider.notifier).save(calc);
    notifier.markSaved(calc.id);
    notifier.setName(calc.name);
    messenger.showSnackBar(SnackBar(content: Text(l.savedNamed(calc.name))));
  }

  Future<String?> _askName(BuildContext context, String initial) {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.saveCalculation),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(labelText: l.stockAccountName, hintText: l.stockAccountHint),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx, text.isEmpty ? l.unnamed : text);
            },
            child: Text(l.save),
          ),
        ],
      ),
    );
  }

  Future<void> _createPdf(WidgetRef ref, ScaffoldMessengerState messenger, AppLocalizations l) async {
    final saved = ref.read(savedCalculationsProvider);
    if (saved.isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.noRecordsForPdf)));
      return;
    }
    try {
      final bytes = await const PdfExportService().buildReport(
        calculations: saved,
        l: l,
      );
      final stamp = DateTime.now().toIso8601String().split('T').first;
      final path = await FilePicker.platform.saveFile(
        dialogTitle: l.savePdf,
        fileName: 'bist_maliyet_rapor_$stamp.pdf',
        bytes: bytes,
      );
      if (path != null) {
        messenger.showSnackBar(SnackBar(content: Text(l.pdfCreated)));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.pdfCreateFailed)));
    }
  }
}

class _AppDrawer extends StatelessWidget {
  final AppCurrency currency;
  final ValueChanged<String> onSelectCurrency;
  final VoidCallback onCostReduction;
  final VoidCallback onDividend;
  final VoidCallback onProfitLoss;
  final VoidCallback onSettings;
  final ValueChanged<String> onMenu;

  const _AppDrawer({
    required this.currency,
    required this.onSelectCurrency,
    required this.onCostReduction,
    required this.onDividend,
    required this.onProfitLoss,
    required this.onSettings,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.calculate_outlined, size: 36, color: theme.colorScheme.onPrimaryContainer),
                  const SizedBox(height: 8),
                  Text(
                    l.drawerTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    l.drawerSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.trending_down),
              title: Text(l.costReduction),
              onTap: () {
                Navigator.pop(context);
                onCostReduction();
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: Text(l.dividendCalculation),
              onTap: () {
                Navigator.pop(context);
                onDividend();
              },
            ),
            ListTile(
              leading: const Icon(Icons.query_stats),
              title: Text(l.profitLossSimulator),
              onTap: () {
                Navigator.pop(context);
                onProfitLoss();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: Text(l.savedCalculations),
              onTap: () {
                Navigator.pop(context);
                onMenu('list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: Text(l.createPdf),
              onTap: () {
                Navigator.pop(context);
                onMenu('pdf');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: Text(l.currencyLabel),
              subtitle: Text('${currency.symbol}  ${currency.code} — ${currency.label(l)}'),
              onTap: () => _pickCurrency(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: Text(l.settings),
              onTap: () {
                Navigator.pop(context);
                onSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in AppCurrency.all)
              ListTile(
                leading: Text(c.symbol, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                title: Text('${c.code} — ${c.label(l)}'),
                trailing: c.code == currency.code ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, c.code),
              ),
          ],
        ),
      ),
    );
    if (selected != null) {
      onSelectCurrency(selected);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
