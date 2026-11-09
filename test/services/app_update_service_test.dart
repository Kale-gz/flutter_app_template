import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/services/app_update_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('de.ffuf.in_app_update/methods');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late AppUpdateService service;
  late List<String> calls;
  late int status;
  late bool denied;

  setUp(() {
    service = AppUpdateService();
    calls = [];
    status = 0;
    denied = false;
    messenger.setMockMethodCallHandler(
      const MethodChannel('de.ffuf.in_app_update/stateEvents'),
      (_) async => null,
    );
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call.method);
      if (call.method == 'checkForUpdate') {
        return {
          'updateAvailability': 2,
          'immediateAllowed': true,
          'flexibleAllowed': true,
          'availableVersionCode': 11,
          'installStatus': status,
          'packageName': 'com.amefor.flutter_app_template',
          'updatePriority': 0,
        };
      }
      if (denied) throw PlatformException(code: 'USER_DENIED_UPDATE');
      return null;
    });
  });

  tearDown(() => service.dispose());

  test('declined download is not offered again during the session', () async {
    denied = true;
    var notices = 0;
    await service.check(onDownloaded: () => notices++);
    await service.check(onDownloaded: () => notices++);
    expect(calls.where((call) => call == 'startFlexibleUpdate'), hasLength(1));
    expect(notices, 0);
  });

  test(
    'recovers downloaded update without installing until requested',
    () async {
      status = 11;
      var notices = 0;
      await service.check(onDownloaded: () => notices++);
      expect(notices, 1);
      expect(calls, ['checkForUpdate']);
      expect(await service.install(), isTrue);
      expect(calls.last, 'completeFlexibleUpdate');
    },
  );

  test('unavailable Play does not escape into app startup', () async {
    messenger.setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'ERROR_API_NOT_AVAILABLE');
    });
    await service.check(onDownloaded: () => fail('Unexpected update'));
    expect(await service.install(), isFalse);
  });
}
