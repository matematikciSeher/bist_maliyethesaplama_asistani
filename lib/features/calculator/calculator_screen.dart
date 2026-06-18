import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/utils/currency.dart';
import '../cost_reduction/cost_reduction_screen.dart';
import '../dividend/dividend_screen.dart';
import '../profit_loss/profit_loss_screen.dart';
import 'calculator_providers.dart';
import 'widgets/lot_entry_row.dart';
import 'widgets/result_card.dart';
import 'widgets/saved_calculations_sheet.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final notifier = ref.read(calculatorProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BİST Maliyet Hesaplama Asistanı',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: _AppDrawer(
        currency: state.currency,
        onSelectCurrency: notifier.setCurrency,
        onCostReduction: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CostReductionScreen(currency: state.currency),
          ),
        ),
        onDividend: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DividendScreen(currency: state.currency),
          ),
        ),
        onProfitLoss: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProfitLossScreen(currency: state.currency),
          ),
        ),
        isDark: ref.watch(themeModeProvider) == ThemeMode.dark,
        onToggleTheme: () => ref.read(themeModeProvider.notifier).toggle(),
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
                  'Alımlarınız',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (state.editingId != null)
                  Chip(
                    label: Text(state.name.isEmpty ? 'Kayıt' : state.name),
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
                onChanged: (price, qty) => notifier.updateEntry(
                  state.entries[i].id,
                  price: price,
                  quantity: qty,
                ),
                onDelete: () => notifier.removeEntry(state.entries[i].id),
              ),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: notifier.addEntry,
              icon: const Icon(Icons.add),
              label: const Text('Satır Ekle'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _saveFlow(context, ref, messenger),
        icon: const Icon(Icons.save),
        label: const Text('Kaydet'),
      ),
    );
  }

  Future<void> _onMenu(
    BuildContext context,
    WidgetRef ref,
    String value,
    ScaffoldMessengerState messenger,
  ) async {
    switch (value) {
      case 'save':
        await _saveFlow(context, ref, messenger);
      case 'list':
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (_) => const SavedCalculationsSheet(),
        );
      case 'new':
        ref.read(calculatorProvider.notifier).reset();
        messenger.showSnackBar(
          const SnackBar(content: Text('Yeni hesap başlatıldı')),
        );
      case 'export':
        await _export(ref, messenger);
      case 'import':
        await _import(ref, messenger);
    }
  }

  Future<void> _saveFlow(
    BuildContext context,
    WidgetRef ref,
    ScaffoldMessengerState messenger,
  ) async {
    final state = ref.read(calculatorProvider);
    if (!state.hasUnsavedData) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Önce en az bir geçerli alım girin')),
      );
      return;
    }
    final name = await _askName(context, state.name);
    if (name == null) return;
    final notifier = ref.read(calculatorProvider.notifier);
    final calc = notifier.toCalculation(name.trim());
    await ref.read(savedCalculationsProvider.notifier).save(calc);
    notifier.markSaved(calc.id);
    notifier.setName(calc.name);
    messenger.showSnackBar(
      SnackBar(content: Text('"${calc.name}" kaydedildi')),
    );
  }

  Future<String?> _askName(BuildContext context, String initial) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hesabı Kaydet'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Hisse / Hesap adı',
            hintText: 'Örn: THYAO',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx, text.isEmpty ? 'Adsız' : text);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  Future<void> _export(
    WidgetRef ref,
    ScaffoldMessengerState messenger,
  ) async {
    final saved = ref.read(savedCalculationsProvider);
    if (saved.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Dışa aktarılacak kayıt yok')),
      );
      return;
    }
    final json = ref.read(savedCalculationsProvider.notifier).export();
    final bytes = Uint8List.fromList(utf8.encode(json));
    final stamp = DateTime.now().toIso8601String().split('T').first;
    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Yedeği kaydet',
      fileName: 'bist_maliyet_yedek_$stamp.json',
      bytes: bytes,
    );
    if (path != null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Yedek dışa aktarıldı')),
      );
    }
  }

  Future<void> _import(
    WidgetRef ref,
    ScaffoldMessengerState messenger,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Yedek dosyası seç',
      type: FileType.custom,
      allowedExtensions: ['json'],
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) return;
    try {
      final json = utf8.decode(bytes);
      final count = await ref
          .read(savedCalculationsProvider.notifier)
          .import(json, merge: true);
      messenger.showSnackBar(
        SnackBar(content: Text('$count kayıt içe aktarıldı')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Dosya okunamadı veya geçersiz')),
      );
    }
  }
}

class _AppDrawer extends StatelessWidget {
  final AppCurrency currency;
  final ValueChanged<String> onSelectCurrency;
  final VoidCallback onCostReduction;
  final VoidCallback onDividend;
  final VoidCallback onProfitLoss;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final ValueChanged<String> onMenu;

  const _AppDrawer({
    required this.currency,
    required this.onSelectCurrency,
    required this.onCostReduction,
    required this.onDividend,
    required this.onProfitLoss,
    required this.isDark,
    required this.onToggleTheme,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.calculate_outlined,
                    size: 36,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BİST Maliyet',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Hesaplama Asistanı',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.trending_down),
              title: const Text('Maliyet Düşürme'),
              onTap: () {
                Navigator.pop(context);
                onCostReduction();
              },
            ),
            ListTile(
              leading: const Icon(Icons.savings_outlined),
              title: const Text('Temettü Hesaplama'),
              onTap: () {
                Navigator.pop(context);
                onDividend();
              },
            ),
            ListTile(
              leading: const Icon(Icons.query_stats),
              title: const Text('Kar/Zarar Simülatörü'),
              onTap: () {
                Navigator.pop(context);
                onProfitLoss();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.save_outlined),
              title: const Text('Kaydet'),
              onTap: () {
                Navigator.pop(context);
                onMenu('save');
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_open_outlined),
              title: const Text('Kayıtlı Hesaplar'),
              onTap: () {
                Navigator.pop(context);
                onMenu('list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.note_add_outlined),
              title: const Text('Yeni'),
              onTap: () {
                Navigator.pop(context);
                onMenu('new');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: const Text('Dışa Aktar'),
              onTap: () {
                Navigator.pop(context);
                onMenu('export');
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('İçe Aktar'),
              onTap: () {
                Navigator.pop(context);
                onMenu('import');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Para Birimi'),
              subtitle: Text('${currency.symbol}  ${currency.code} — ${currency.label}'),
              onTap: () => _pickCurrency(context),
            ),
            SwitchListTile(
              secondary: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              title: const Text('Koyu Tema'),
              value: isDark,
              onChanged: (_) => onToggleTheme(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickCurrency(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in AppCurrency.all)
              ListTile(
                leading: Text(
                  c.symbol,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                title: Text('${c.code} — ${c.label}'),
                trailing: c.code == currency.code
                    ? const Icon(Icons.check)
                    : null,
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
