import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Automatic events and route tracking for configured mobile release builds.
class AnalyticsService {
  static bool _enabled = false;

  static FirebaseAnalyticsObserver? get observer => _enabled
      ? FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      : null;

  static Future<void> initialize() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS) ||
        Firebase.apps.isEmpty) {
      return;
    }
    try {
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(
        kReleaseMode,
      );
      _enabled = kReleaseMode;
    } on FirebaseException catch (error) {
      debugPrint('Analytics unavailable: ${error.code}');
    } on PlatformException catch (error) {
      debugPrint('Analytics unavailable: ${error.code}');
    } on MissingPluginException {
      debugPrint('Analytics native plugin unavailable.');
    }
  }

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    if (!_enabled) return;
    try {
      await FirebaseAnalytics.instance.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (error) {
      debugPrint('Analytics event could not be sent: $error');
    }
  }
}
