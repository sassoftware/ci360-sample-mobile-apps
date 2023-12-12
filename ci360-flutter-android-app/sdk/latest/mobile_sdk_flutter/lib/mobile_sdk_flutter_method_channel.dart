import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mobile_sdk_flutter_platform_interface.dart';

/// An implementation of [MobileSdkFlutterPlatform] that uses method channels.
class MethodChannelMobileSdkFlutter extends MobileSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('mobile_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> newPage(String uri) async {
    return await methodChannel.invokeMethod('newPage', {'uri': uri});
  }

  @override
  Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) async {
    return await methodChannel.invokeMethod(
        'addAppEvent', <String, dynamic>{'eventKey': eventKey, 'data': data});
  }

  @override
  Future<bool> identity(String value, String type) async {
    return await methodChannel
        .invokeMethod('identity', {'value': value, 'type': type});
  }

  @override
  Future<bool> detachIdentity() async {
    return await methodChannel.invokeMethod('detachIdentity');
  }

  @override
  Future<void> registerForMobileMessages(String token) async {
    return await methodChannel
        .invokeMethod('registerForMobileMessages', {'token': token});
  }

  @override
  Future<bool> handleMobileMessage(Map<String, dynamic> data) async {
    return await methodChannel
        .invokeMethod('handleMobileMessage', {'data': data});
  }

  @override
  Future<bool> isEnabled() async {
    return await methodChannel.invokeMethod('isEnabled');
  }

  @override
  Future<String> getSessionBindingParameter() async {
    return await methodChannel.invokeMethod('getSessionBindingParameter');
  }

  @override
  Future<void> resetDeviceId() async {
    return await methodChannel.invokeMethod('resetDeviceId');
  }

  @override
  Future<String> getDeviceId() async {
    return await methodChannel.invokeMethod('getDeviceId');
  }

  @override
  Future<String> getTenantId() async {
    return await methodChannel.invokeMethod('getTenantId');
  }

  @override
  Future<void> setTenantId(String tenantId) async {
    return await methodChannel
        .invokeMethod('setTenantIid', {'tenantId': tenantId});
  }
  
  @override
  Future<String> getTagServer() async {
    return await methodChannel.invokeMethod('getTagServer');
  }

  @override
  Future<void> setTagServer(String tagServer) async {
    return methodChannel.invokeMethod('setTagServer', {'tagServer': tagServer});
  }

  @override
  Future<void> startMonitoringLocation() async {
    return methodChannel.invokeMethod('startMonitoringLocation');
  }

  @override
  Future<void> disableLocationMonitoring() async {
    return methodChannel.invokeMethod('disableLocationMonitoring');
  }

  @override
  Future<void> shutdown() async {
    return methodChannel.invokeMethod('shutdown');
  }

  @override
  Future<String> getApplicationVersion() async {
    return await methodChannel.invokeMethod('getApplicationVersion');
  }

  @override
  Future<void> setApplicationVersion(String appVersion) async {
    return methodChannel.invokeMethod('setApplicationVersion');
  }

  @override
  Future<String> getSDKVersion() async {
    return await methodChannel.invokeMethod('getSDKVersion');
  }

  @override
  Future<bool> setTenant(
      String tenantId, String tagServer, String appId) async {
    return await methodChannel.invokeMethod('setTenant',
        {'tenantId': tenantId, 'tagServer': tagServer, 'appId': appId});
  }

  @override
  Future<void> setMobileMessagingDelegate2() async {
    return await methodChannel.invokeMethod('setMobileMessagingDelegate2');
  }
}
