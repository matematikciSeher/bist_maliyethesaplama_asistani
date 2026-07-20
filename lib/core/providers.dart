import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/calculation_repository.dart';
import 'utils/formatters.dart';

/// main() içinde override edilir.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('main() içinde override edilmeli'),
);

final calculationRepositoryProvider = Provider<CalculationRepository>(
  (ref) => CalculationRepository(ref.watch(sharedPreferencesProvider)),
);

/// Açık/koyu tema tercihi (cihazda saklanır).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_key);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await ref.read(sharedPreferencesProvider).setString(_key, value);
  }
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

/// Uygulama dili (cihazda saklanır).
class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'app_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_key);
    if (stored == 'tr' || stored == 'en') {
      return Locale(stored!);
    }
    final systemLang =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return Locale(systemLang == 'tr' ? 'tr' : 'en');
  }

  Future<void> setLanguageCode(String code) async {
    final locale = Locale(code == 'tr' ? 'tr' : 'en');
    final localeName = code == 'tr' ? 'tr_TR' : 'en_US';
    await initializeDateFormatting(localeName, null);
    Formatters.configure(localeName);
    state = locale;
    await ref.read(sharedPreferencesProvider).setString(_key, locale.languageCode);
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// SharedPreferences + sistem dilinden başlangıç locale'ini üretir.
Locale resolveInitialLocale(SharedPreferences prefs) {
  final stored = prefs.getString(LocaleNotifier._key);
  if (stored == 'tr' || stored == 'en') {
    return Locale(stored!);
  }
  final systemLang =
      WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  return Locale(systemLang == 'tr' ? 'tr' : 'en');
}
