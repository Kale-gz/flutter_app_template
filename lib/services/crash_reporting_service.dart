import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_template/firebase_options.dart';

/// Initializes Firebase on mobile; fresh, unconfigured copies remain runnable.
class CrashReportingService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized ||
        kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(kReleaseMode);
      final previousHandler = FlutterError.onError;
      FlutterError.onError = (details) {
        previousHandler?.call(details);
        if (kReleaseMode) {
          unawaited(_send(() => crashlytics.recordFlutterFatalError(details)));
        }
      };
      if (kReleaseMode) {
        PlatformDispatcher.instance.onError = (error, stack) {
          unawaited(
            _send(() => crashlytics.recordError(error, stack, fatal: true)),
          );
          return true;
        };
      }
      _initialized = true;
    } on UnsupportedError catch (error) {
      debugPrint('$error');
    } on FirebaseException catch (error) {
      debugPrint('Firebase initialization unavailable: ${error.code}');
    } on PlatformException catch (error) {
      debugPrint('Firebase initialization unavailable: ${error.code}');
    } on MissingPluginException {
      debugPrint('Firebase native plugins unavailable.');
    }
  }

  /// Records handled errors without allowing diagnostics to break app logic.
  static Future<void> report(Object error, StackTrace stack) async {
    if (!_initialized || !kReleaseMode) return;
    await _send(() => FirebaseCrashlytics.instance.recordError(error, stack));
  }

  static Future<void> _send(Future<void> Function() send) async {
    try {
      await send();
    } catch (error) {
      debugPrint('Crash report could not be sent: $error');
    }
  }
}
