import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter_platform_interface.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMobileSdkFlutterPlatform 
    with MockPlatformInterfaceMixin
    implements MobileSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MobileSdkFlutterPlatform initialPlatform = MobileSdkFlutterPlatform.instance;

  test('$MethodChannelMobileSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMobileSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    MobileSdkFlutter mobileSdkFlutterPlugin = MobileSdkFlutter();
    MockMobileSdkFlutterPlatform fakePlatform = MockMobileSdkFlutterPlatform();
    MobileSdkFlutterPlatform.instance = fakePlatform;
  
    expect(await mobileSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
