# Flutter App Template

A reusable base for new apps: Flutter Material 3, English/Italian localization,
Firebase Crashlytics and Analytics, Google Play in-app updates, and launcher icons.
Android, iOS and web projects are included. No Firebase account is needed to run.

## Run and validate

Requires Flutter 3.47.7 (Dart 3.13.5) or a compatible newer stable SDK, Java 17+,
and Android SDK tools. The Dart constraint is ^3.11.4. On Windows enable
Developer Mode for Flutter plugin symlinks. iOS builds require macOS and Xcode.

```sh
flutter pub get
flutter gen-l10n
flutter run
```

```sh
dart format lib test tool
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --debug --no-pub
flutter build web --release --no-pub
```

Generated localization files are ignored; run generation after cloning and after
changing either ARB file. Commit pubspec.lock for reproducible app dependencies.
CI checks formatting, analysis, tests and a web build.

## Start your next app

1. Copy this repository into a new folder (or use GitHub's template feature after
   publishing it yourself). Start a new Git history; do not copy `.git`, `build`,
   `.dart_tool`, signing keys, or Firebase configuration from another app.
2. Set the package name in `pubspec.yaml` and replace
   `package:flutter_app_template/` in Dart imports.
3. Set your Android namespace and applicationId in
   `android/app/build.gradle.kts`. Move MainActivity.kt to the matching package
   path and change its package declaration. Replace
   `com.example.flutter_app_template` in the iOS Xcode project with your bundle
   ID (including the RunnerTests ID).
4. Set the app titles in both ARB files, the launcher labels in Android
   `res/values/strings.xml` and `res/values-it/strings.xml`, the iOS display name
   in `ios/Runner/Info.plist`, and the titles in `web/index.html` and
   `web/manifest.json`. iOS native display-name translations can be added with
   localized InfoPlist.strings files when needed.
5. Replace the placeholder icons and generate them as described below.
6. Connect the new app to its own Firebase project and configure release signing.
7. Start with version `1.0.0+1`, and increase the build number after `+` for each
   Google Play upload. Replace this README with your app's documentation.

The example home screen demonstrates runtime locale and theme changes. These
choices are intentionally in memory; add a preferences service if your app needs
to persist them. Unsupported device languages fall back to English.

## Firebase setup (per app)

The starter's `lib/firebase_options.dart` is an unconfigured placeholder.
Initialization skips telemetry without crashing when configuration is absent.
Android/iOS release builds enable collection after successful initialization;
debug/profile builds keep it disabled. Web runs without Firebase telemetry.

Install the Firebase CLI, sign in, and install FlutterFire CLI:

```sh
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --platforms=android,ios
```

Select or create the Firebase project for THIS app, using its final package and
bundle IDs. Enable Google Analytics in that project. Let the CLI replace
`lib/firebase_options.dart` and generate native configuration. Android expects
`android/app/google-services.json`; iOS expects
`ios/Runner/GoogleService-Info.plist` included in the Runner target. Firebase
configuration files are ignored by this template; provide them separately in CI.
The generated Dart options are application identifiers, not service-account
credentials, but keep them specific to the derived app.

Google Services and Crashlytics Gradle plugins are predeclared and applied when
Android's configuration file exists. There is no dependency on another app's
keystore. Rerun `flutterfire configure` after adding platforms or Firebase products.
On macOS, verify the Crashlytics upload-symbols build phase and its input files
in Xcode following the official Crashlytics guide; a Windows build cannot verify
iOS symbol upload. Preserve and upload Dart symbols if using obfuscation.

Crashlytics catches Flutter framework and uncaught asynchronous errors.
Use `CrashReportingService.report(error, stack)` for handled errors. Analytics
collects automatic events and uses `FirebaseAnalyticsObserver` for named routes;
give future routes stable non-sensitive names. Use
`AnalyticsService.logEvent('feature_used')` for your own events. Avoid personal
data in event names, parameters, route names and exceptions.

Native startup collection and advertising identifier collection are disabled.
Add any consent controls your particular app needs before enabling telemetry;
the starter does not implement a consent UI. Update each app's privacy policy and
store disclosures to reflect its actual collection.

Verify on a configured release build: trigger a temporary test crash, restart,
check Crashlytics, and confirm Analytics events in Firebase. Remove the crash
trigger before distribution. Tests here do not send data to a live Firebase
project.

Official guides: [Firebase setup](https://firebase.google.com/docs/flutter/setup),
[Crashlytics](https://firebase.google.com/docs/crashlytics/flutter/get-started).

## Google Play in-app updates

Matches the QuickSpend and Loan Calculator behavior: checks on launch and resume
in Android release builds, offers flexible downloads, allows continued app use,
and shows a localized Restart action once downloaded. Declining suppresses
repeat offers for that session. Downloaded updates are recovered on a later
launch; an interrupted immediate Play update is resumed. Missing Play services
and sideloaded installs do not prevent app use. iOS uses App Store updates; there
is no Play integration on iOS or web.

Test with a release build installed through Google Play/internal app sharing,
then make a higher version code available to the same account with matching
application ID and signing key. For internal app sharing, open the newer sharing
link without installing, then launch the old app. Check accept/decline,
background download, Restart, and recovery after reopening. Local unit tests
mock the platform channel and cannot validate an actual Play installation.
See [Google's testing guide](https://developer.android.com/guide/playcore/in-app-updates/test).

## Localization

Put every user-facing string in BOTH `lib/l10n/app_en.arb` and `app_it.arb`.
Run `flutter gen-l10n`, then access strings through
`AppLocalizations.of(context)`. Use ARB placeholders for sentences with values.
Use `intl` with `Localizations.localeOf(context).toString()` for dates and
numbers. Add ARB files for additional languages; Flutter generates the locale list.

## Launcher icons

`flutter_launcher_icons` is configured for Android (including adaptive/themed
icons), iOS, and web. Included PNGs are deliberately generic placeholders.

Replace `assets/icons/app_icon.png` with a 1024×1024 square icon,
`app_icon_foreground.png` with a transparent adaptive foreground, and
`app_icon_monochrome.png` with a transparent single-color silhouette. Keep the
important foreground content inside the adaptive safe area. Change the background
color in `pubspec.yaml` to match your branding.

```sh
dart run flutter_launcher_icons
```

To recreate the original placeholder assets:

```sh
dart run tool/create_placeholder_icons.dart
dart run flutter_launcher_icons
```

See [plugin documentation](https://pub.dev/packages/flutter_launcher_icons).

## Release signing

Debug builds work without signing files. For your own Android release keystore,
copy `android/key.properties.example` to ignored `android/key.properties` and
provide real values. Release builds deliberately fail without those settings,
preventing accidental distribution with the debug key. Never commit a keystore
or passwords. Configure iOS signing in Xcode on macOS.

```sh
flutter build appbundle --release
```

## Layout

- `lib/services/`: Firebase diagnostics, Analytics, Google Play update logic.
- `lib/widgets/`: lifecycle-aware update notification.
- `lib/pages/`: example home page, replace with your app's screens.
- `lib/l10n/`: English and Italian ARB translations.
- `assets/icons/` and `tool/`: placeholder artwork and icon regeneration.
- `test/`: localization, theme, startup fallback and update-state checks.
- `.github/workflows/checks.yml`: automatic validation for derived repositories.
