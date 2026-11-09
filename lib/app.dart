import 'package:flutter/material.dart';
import 'package:flutter_app_template/l10n/app_localizations.dart';
import 'package:flutter_app_template/pages/home_page.dart';
import 'package:flutter_app_template/services/analytics_service.dart';
import 'package:flutter_app_template/widgets/app_update_listener.dart';

class StarterApp extends StatefulWidget {
  const StarterApp({super.key});

  @override
  State<StarterApp> createState() => _StarterAppState();
}

class _StarterAppState extends State<StarterApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;
  final _analyticsObserver = AnalyticsService.observer;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2457C5),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF2457C5),
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      navigatorObservers: [if (_analyticsObserver != null) _analyticsObserver],
      home: AppUpdateListener(
        child: HomePage(
          locale: _locale,
          themeMode: _themeMode,
          onLocaleChanged: (value) => setState(() => _locale = value),
          onThemeChanged: (value) => setState(() => _themeMode = value),
        ),
      ),
    );
  }
}
