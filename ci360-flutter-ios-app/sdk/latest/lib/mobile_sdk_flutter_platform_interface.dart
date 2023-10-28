import 'dart:ffi';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mobile_sdk_flutter_method_channel.dart';

abstract class MobileSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a MobileSdkFlutterPlatform.
  MobileSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static MobileSdkFlutterPlatform _instance = MethodChannelMobileSdkFlutter();

  /// The default instance of [MobileSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelMobileSdkFlutter].
  static MobileSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MobileSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(MobileSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> newPage(String uri) {
    throw UnimplementedError('newPage has not been implemented.');
  }

  Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) {
    throw UnimplementedError('addAppEvent is not implemented');
  }

  Future<bool> identity(String value, String type) {
    throw UnimplementedError('identity is not implemented');
  }

  Future<bool> detachIdentity() {
    throw UnimplementedError('detachIdentity is not implemented');
  }

  Future<void> registerForMobileMessages(String token) {
    throw UnimplementedError('registerForMobileMessages is not implemented');
  }

  Future<bool> handleMobileMessage(Map<String, dynamic> data) {
    throw UnimplementedError('handleMobileMessage is not implemented');
  }

  Future<bool> isEnabled() {
    throw UnimplementedError('isEnabled is not implemented');
  }

  Future<String> getSessionBindingParameter() {
    throw UnimplementedError('getSessionBindingParameter is not implemented');
  }

  Future<void> resetDeviceId() {
    throw UnimplementedError('resetDeviceId is not implemented');
  }

  Future<String> getDeviceId() {
    throw UnimplementedError('getDeviceId is not implemented');
  }

  Future<String> getTenantId() {
    throw UnimplementedError('getTenantId is not implemented');
  }

  Future<void> setTenantId(String tenantId) {
    throw UnimplementedError('setTenantId is not implemented');
  }

  Future<String> getTagServer() {
    throw UnimplementedError('getTagServer is not implemented');
  }

  Future<void> setTagServer(String tagServer) {
    throw UnimplementedError('setTagServer is not implemented');
  }

  Future<void> disableLocationMonitoring() {
    throw UnimplementedError('disableLocationMonitoring is not implemented');
  }

  Future<void> startMonitoringLocation() {
    throw UnimplementedError('startLocationMonitoring is not implemented');
  }

  Future<void> shutdown() {
    throw UnimplementedError('shutdown is not implemented');
  }

  Future<String> getApplicationVersion() {
    throw UnimplementedError('getApplicationVersion is not implemented');
  }

  Future<void> setApplicationVersion(String appVersion) {
    throw UnimplementedError('setApplicationVersion is not implemented');
  }

  Future<String> getSDKVersion() {
    throw UnimplementedError('getSDKVersion is not implemented');
  }

  Future<bool> setTenant(String tenantId, String tagServer, String appId) {
    throw UnimplementedError('setTenant is not implemented');
  }

  Future<void> setMobileMessagingDelegate2() {
    throw UnimplementedError('setMobileMessagingDelegate2 not implemented');
  }
}
