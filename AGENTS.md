# Flutter starter conventions

- Read README.md before changes. Android, iOS and web are scaffolded; Play updates
  run only in Android release builds, Firebase only on configured mobile builds.
- Use package imports and snake_case filenames. Keep integration logic in
  lib/services and reusable UI in lib/widgets.
- Add user-facing strings to BOTH lib/l10n/app_en.arb and app_it.arb. Run
  flutter gen-l10n; never edit generated localization files.
- Never add a shared Firebase project, signing keys or service accounts to the
  base template. Configure every derived app separately.
- Telemetry stays disabled in debug/profile builds and at native startup.
- Keep startup usable without Firebase configuration or Play services.
- Preserve session-level update prompt suppression and user-controlled restart.
- Run dart format lib test tool, flutter analyze and flutter test after changes.
- Keep pubspec.lock committed for reproducible app builds.
