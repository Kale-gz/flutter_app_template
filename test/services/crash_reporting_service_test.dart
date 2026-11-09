import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/services/crash_reporting_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('unsupported platforms preserve the existing error handler', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    final handler = FlutterError.onError;

    await CrashReportingService.initialize();

    expect(FlutterError.onError, same(handler));
  });

  test('unavailable native Firebase does not prevent startup', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final handler = FlutterError.onError;

    // No native Firebase channels are registered in this test environment.
    await CrashReportingService.initialize();

    expect(FlutterError.onError, same(handler));
  });
}
