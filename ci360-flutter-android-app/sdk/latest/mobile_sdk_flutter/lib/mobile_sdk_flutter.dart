import 'mobile_sdk_flutter_platform_interface.dart';

class MobileSdkFlutter {
  Future<String?> getPlatformVersion() {
    return MobileSdkFlutterPlatform.instance.getPlatformVersion();
  }

  Future<void> newPage(String uri) {
    return MobileSdkFlutterPlatform.instance.newPage(uri);
  }

  Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) {
    return MobileSdkFlutterPlatform.instance.addAppEvent(eventKey, data);
  }

  Future<bool> identity(String value, String type) {
    return MobileSdkFlutterPlatform.instance.identity(value, type);
  }

  Future<bool> detachIdentity() {
    return MobileSdkFlutterPlatform.instance.detachIdentity();
  }

  Future<void> registerForMobileMessages(String token) {
    return MobileSdkFlutterPlatform.instance.registerForMobileMessages(token);
  }

  Future<bool> handleMobileMessage(Map<String, dynamic> data) {
    return MobileSdkFlutterPlatform.instance.handleMobileMessage(data);
  }

  Future<bool> isEnabled() {
    return MobileSdkFlutterPlatform.instance.isEnabled();
  }

  Future<String> getSessionBindingParameter() {
    return MobileSdkFlutterPlatform.instance.getSessionBindingParameter();
  }

  Future<void> resetDeviceId() {
    return MobileSdkFlutterPlatform.instance.resetDeviceId();
  }

  Future<String> getDeviceId() {
    return MobileSdkFlutterPlatform.instance.getDeviceId();
  }

  Future<String> getTagServer() {
    return MobileSdkFlutterPlatform.instance.getTagServer();
  }

  Future<String> getTenantId() {
    return MobileSdkFlutterPlatform.instance.getTenantId();
  }

  Future<void> startMonitoringLocation() async {
    return MobileSdkFlutterPlatform.instance.startMonitoringLocation();
  }

  Future<void> disableLocationMonitoring() {
    return MobileSdkFlutterPlatform.instance.disableLocationMonitoring();
  }

  Future<void> shutdown() {
    return MobileSdkFlutterPlatform.instance.shutdown();
  }

  Future<String> getApplicationVersion() {
    return MobileSdkFlutterPlatform.instance.getApplicationVersion();
  }

  Future<void> setApplicationVersion(String appVersion) {
    return MobileSdkFlutterPlatform.instance.setApplicationVersion(appVersion);
  }

  Future<bool> setTenant(String tenantId, String tagServer, String appId) {
    return MobileSdkFlutterPlatform.instance
        .setTenant(tenantId, tagServer, appId);
  }
}
