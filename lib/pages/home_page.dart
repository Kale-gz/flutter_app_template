import 'package:flutter/material.dart';
import 'package:flutter_app_template/l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.locale,
    required this.themeMode,
    required this.onLocaleChanged,
    required this.onThemeChanged,
  });

  final Locale? locale;
  final ThemeMode themeMode;
  final ValueChanged<Locale?> onLocaleChanged;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.auto_awesome_outlined, size: 64),
          const SizedBox(height: 24),
          Text(
            l10n.welcomeTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(l10n.welcomeBody),
          const SizedBox(height: 40),
          DropdownButtonFormField<String>(
            key: ValueKey(locale?.languageCode ?? 'system'),
            initialValue: locale?.languageCode ?? 'system',
            decoration: InputDecoration(labelText: l10n.language),
            items: [
              DropdownMenuItem(
                value: 'system',
                child: Text(l10n.languageSystem),
              ),
              DropdownMenuItem(value: 'en', child: Text(l10n.languageEnglish)),
              DropdownMenuItem(value: 'it', child: Text(l10n.languageItalian)),
            ],
            onChanged: (value) => onLocaleChanged(
              value == null || value == 'system' ? null : Locale(value),
            ),
          ),
          const SizedBox(height: 24),
          Text(l10n.appearance, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.themeSystem),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.themeLight),
              ),
              ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
            ],
            selected: {themeMode},
            onSelectionChanged: (value) => onThemeChanged(value.first),
          ),
        ],
      ),
    );
  }
}
