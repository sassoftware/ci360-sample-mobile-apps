import { NativeModules, Platform } from 'react-native';
import * as Constants from './Constants';
import InlineAdView from './views/InlineAdView';
import InterstitialAdView from './views/InterstitialAdView';

const LINKING_ERROR =
  `The package 'mobile-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const MobileSdkReactNative = NativeModules.MobileSdkReactNative
  ? NativeModules.MobileSdkReactNative
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  return MobileSdkReactNative.multiply(a, b);
}
export function newPage(uri: string) {
  MobileSdkReactNative.newPage(uri);
}
export function addAppEvent(eventKey: string, data: Object) {
  MobileSdkReactNative.addAppEvent(eventKey, data);
}

export async function identity(value: string, type: string) {
  try {
    console.log('awaiting for identity in index', value, type);
    const isSuccess: boolean = await MobileSdkReactNative.identity(value, type);
    console.log('isSuccess for identity in index', isSuccess);
    return isSuccess;
  } catch (e: any) {
    console.log('error from identity in index', e);
    return false;
  }
}
export async function detachIdentity() {
  try {
    const isSuccess = await MobileSdkReactNative.detachIdentity();
    return isSuccess;
  } catch (e: any) {
    console.log(e);
    return false;
  }
}
export function startMonitoringLocation() {
  MobileSdkReactNative.startMonitoringLocation();
}
export function disableLocationMonitoring() {
  MobileSdkReactNative.disableLocationMonitoring();
}
export function getAppVersion(callback: (version: string) => void) {
  MobileSdkReactNative.getAppVersion((appVersion: string) => {
    callback(appVersion);
  });
}
export function getTenantID(callback: (id: string) => void) {
  MobileSdkReactNative.getTenantID((tenantID: string) => {
    callback(tenantID);
  });
}

export function getDeviceID(callback: (id: string) => void) {
  MobileSdkReactNative.getDeviceID((deviceID: string) => {
    callback(deviceID);
  });
}

export function getTagServer(callback: (id: string) => void) {
  MobileSdkReactNative.getTagServer((serverID: string) => {
    callback(serverID);
  });
}

export function getSessionId(callback: (sessionId: string) => void) {
  MobileSdkReactNative.getSessionId((sessionId: string) => {
    console.log('index :: ', sessionId);
    callback(sessionId);
  });
}

export function resetDeviceID() {
  MobileSdkReactNative.resetDeviceID();
}

export function registerForMobileMessage(token: string) {
  MobileSdkReactNative.registerForMobileMessage(token);
}

export function handleMobileMessage(
  data: Object,
  callback: (success: boolean) => void
) {
  MobileSdkReactNative.handleMobileMessage(data, (isSuccess: boolean) => {
    callback(isSuccess);
  });
}
export function defineAppId(appId: string) {
  MobileSdkReactNative.defineAppId(appId);
}

export function defineAppVersion(appVersion: string) {
  MobileSdkReactNative.defineAppVersion(appVersion);
}

export function defineTenantID(tenantID: string) {
  MobileSdkReactNative.defineTenantID(tenantID);
}

export function defineTagServer(tagServer: string) {
  MobileSdkReactNative.defineTagServer(tagServer);
}

export { InlineAdView, InterstitialAdView };
const SASMobileMessagingEvent = NativeModules.SASMobileMessagingEvent;
const AdDelegateEvent = NativeModules.AdDelegateEvent;
export { AdDelegateEvent, Constants, SASMobileMessagingEvent };
