import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_template/l10n/app_localizations.dart';
import 'package:flutter_app_template/services/app_update_service.dart';

/// Place below MaterialApp so update notices use the active locale and theme.
class AppUpdateListener extends StatefulWidget {
  const AppUpdateListener({super.key, required this.child});
  final Widget child;

  @override
  State<AppUpdateListener> createState() => _AppUpdateListenerState();
}

class _AppUpdateListenerState extends State<AppUpdateListener> {
  final _updates = AppUpdateService();
  late final AppLifecycleListener _lifecycle;
  bool _noticeVisible = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _check);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _check();
    });
  }

  void _check() {
    if (!kReleaseMode ||
        kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android) {
      return;
    }
    unawaited(_updates.check(onDownloaded: _showNotice));
  }

  void _showNotice() {
    if (!mounted || _noticeVisible) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    _noticeVisible = true;
    messenger
        .showSnackBar(
          SnackBar(
            content: Text(l10n.updateReady),
            duration: const Duration(days: 1),
            action: SnackBarAction(
              label: l10n.updateRestart,
              onPressed: () async {
                final installed = await _updates.install();
                if (!installed && mounted) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.of(context).updateInstallFailed,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        )
        .closed
        .then((_) => _noticeVisible = false);
  }

  @override
  void dispose() {
    _updates.dispose();
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
