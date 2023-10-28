import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter_method_channel.dart';

void main() {
  MethodChannelMobileSdkFlutter platform = MethodChannelMobileSdkFlutter();
  const MethodChannel channel = MethodChannel('mobile_sdk_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
