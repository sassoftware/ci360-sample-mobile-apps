import { NativeModules, Platform } from 'react-native';
import InlineAdView from './views/InlineAdView';
import InterstitialAdView from './views/InterstitialAdView';
import * as Constants from './Constants';
const LINKING_ERROR = `The package 'mobile-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` + Platform.select({
  ios: "- You have run 'pod install'\n",
  default: ''
}) + '- You rebuilt the app after installing the package\n' + '- You are not using Expo Go\n';
const MobileSdkReactNative = NativeModules.MobileSdkReactNative ? NativeModules.MobileSdkReactNative : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
export function multiply(a, b) {
  return MobileSdkReactNative.multiply(a, b);
}
export function newPage(uri) {
  return MobileSdkReactNative.newPage(uri);
}
export function getSessionID(callback) {
  MobileSdkReactNative.getSessionID(sessionID => {
    callback(sessionID);
  });
}
export function getSdkVersion(callback) {
  MobileSdkReactNative.getSdkVersion(sdkVersion => {
    callback(sdkVersion);
  });
}
export function addAppEvent(eventKey, data) {
  MobileSdkReactNative.addAppEvent(eventKey, data);
}
export async function identity(value, type) {
  try {
    const isSuccess = await MobileSdkReactNative.identity(value, type);
    return isSuccess;
  } catch (e) {
    return false;
  }
}
export async function detachIdentity() {
  const isSuccess = await MobileSdkReactNative.detachIdentity();
  return isSuccess;
}
export function getTenantID(callback) {
  MobileSdkReactNative.getTenantID(tenantID => {
    callback(tenantID);
  });
}
export function getDeviceID(callback) {
  MobileSdkReactNative.getDeviceID(deviceID => {
    callback(deviceID);
  });
}
export function getTagServer(callback) {
  MobileSdkReactNative.getTagServer(serverID => {
    callback(serverID);
  });
}
export function getAppVersion(callback) {
  MobileSdkReactNative.getAppVersion(appVersion => {
    callback(appVersion);
  });
}
export function registerForMobileMessage(token) {
  MobileSdkReactNative.registerForMobileMessage(token);
}
export function handleMobileMessage(data, callback) {
  MobileSdkReactNative.handleMobileMessage(data, isSuccess => {
    callback(isSuccess);
  });
}
export { InlineAdView };
export { InterstitialAdView };
const SASMobileMessagingEvent = NativeModules.SASMobileMessagingEvent;
const AdDelegateEvent = NativeModules.AdDelegateEvent;
export { SASMobileMessagingEvent };
export { AdDelegateEvent };
export { Constants };
//# sourceMappingURL=index.js.map