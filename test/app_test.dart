import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/app.dart';
import 'package:flutter_app_template/l10n/app_localizations.dart';

void main() {
  testWidgets('runs without Firebase and renders English', (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    expect(find.text('Your next app starts here'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('switches from English to Italian at runtime', (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Italiano').last);
    await tester.pumpAndSettle();
    expect(find.text('La tua prossima app inizia qui'), findsOneWidget);
    expect(find.text('Aspetto'), findsOneWidget);
  });

  testWidgets('unsupported device language falls back to English', (
    tester,
  ) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('fr');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    expect(find.text('Your next app starts here'), findsOneWidget);
  });

  testWidgets('theme choice changes the applied theme', (tester) async {
    tester.binding.platformDispatcher.localeTestValue = const Locale('en');
    addTearDown(tester.binding.platformDispatcher.clearLocaleTestValue);
    await tester.pumpWidget(const StarterApp());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  test('both locales provide update messages', () async {
    for (final language in ['en', 'it']) {
      final l10n = await AppLocalizations.delegate.load(Locale(language));
      expect(l10n.updateReady, isNotEmpty);
      expect(l10n.updateRestart, language == 'en' ? 'Restart' : 'Riavvia');
      expect(l10n.updateInstallFailed, isNotEmpty);
    }
  });
}
