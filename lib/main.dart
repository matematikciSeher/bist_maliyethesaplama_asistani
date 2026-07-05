import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/formatters.dart';
import 'features/splash/splash_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Cihazın sistem dili Türkçe ise uygulama Türkçe, aksi halde İngilizce olur.
  final systemLocale = widgetsBinding.platformDispatcher.locale;
  final isTurkish = systemLocale.languageCode == 'tr';
  final localeName = isTurkish ? 'tr_TR' : 'en_US';
  final appLocale = Locale(isTurkish ? 'tr' : 'en');

  await initializeDateFormatting(localeName, null);
  Formatters.configure(localeName);

  final prefs = await SharedPreferences.getInstance();
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: BistMaliyetApp(locale: appLocale),
    ),
  );
}

class BistMaliyetApp extends ConsumerWidget {
  const BistMaliyetApp({super.key, required this.locale});

  final Locale locale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
