import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

/// Coordinates Play updates for one app session. Unavailable Play services and
/// sideloaded installs must never prevent the user from using the app.
class AppUpdateService {
  bool _busy = false;
  bool _prompted = false;
  bool _disposed = false;
  StreamSubscription<InstallStatus>? _subscription;

  Future<void> check({required VoidCallback onDownloaded}) async {
    if (_busy || _disposed) return;
    _busy = true;
    try {
      _subscription ??= InAppUpdate.installUpdateListener.listen(
        (status) {
          if (!_disposed && status == InstallStatus.downloaded) onDownloaded();
        },
        onError: (Object error) {
          debugPrint('Play update listener unavailable: $error');
        },
      );
      final info = await InAppUpdate.checkForUpdate();
      if (_disposed) return;
      if (info.installStatus == InstallStatus.downloaded) {
        onDownloaded();
      } else if (info.updateAvailability ==
          UpdateAvailability.developerTriggeredUpdateInProgress) {
        await InAppUpdate.performImmediateUpdate();
      } else if (!_prompted &&
          info.updateAvailability == UpdateAvailability.updateAvailable &&
          info.flexibleUpdateAllowed &&
          info.installStatus != InstallStatus.downloading &&
          info.installStatus != InstallStatus.pending) {
        _prompted = true;
        final result = await InAppUpdate.startFlexibleUpdate();
        if (!_disposed && result == AppUpdateResult.success) onDownloaded();
      }
    } on PlatformException catch (error) {
      debugPrint('Play update unavailable: ${error.code}');
    } on MissingPluginException {
      // Play updates are Android-only.
    } finally {
      _busy = false;
    }
  }

  Future<bool> install() async {
    try {
      await InAppUpdate.completeFlexibleUpdate();
      return true;
    } on PlatformException catch (error) {
      debugPrint('Play update installation failed: ${error.code}');
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  void dispose() {
    _disposed = true;
    unawaited(_subscription?.cancel());
  }
}
