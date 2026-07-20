import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(
            l.theme,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          RadioGroup<ThemeMode>(
            groupValue: themeMode,
            onChanged: (mode) {
              if (mode != null) {
                ref.read(themeModeProvider.notifier).setMode(mode);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  title: Text(l.themeSystem),
                  secondary: const Icon(Icons.brightness_auto_outlined),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  title: Text(l.themeLight),
                  secondary: const Icon(Icons.light_mode_outlined),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  title: Text(l.themeDark),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            l.language,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          RadioGroup<String>(
            groupValue: locale.languageCode,
            onChanged: (code) {
              if (code != null) {
                ref.read(localeProvider.notifier).setLanguageCode(code);
              }
            },
            child: Column(
              children: [
                RadioListTile<String>(
                  value: 'tr',
                  title: Text(l.languageTurkish),
                  contentPadding: EdgeInsets.zero,
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l.languageEnglish),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
