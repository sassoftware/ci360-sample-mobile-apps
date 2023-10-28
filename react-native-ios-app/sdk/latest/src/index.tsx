import { NativeModules, Platform } from 'react-native';
import InlineAdView from './views/InlineAdView';
import InterstitialAdView from './views/InterstitialAdView';
import * as Constants from './Constants';

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

export function newPage(uri: string){
  return MobileSdkReactNative.newPage(uri);
}

export function getSessionID(callback: (id:string) => void){
  MobileSdkReactNative.getSessionID((sessionID: string) => {
    callback(sessionID);
  })
}

export function getSdkVersion(callback: (version: string) => void) {
  MobileSdkReactNative.getSdkVersion((sdkVersion: string) => {
    callback(sdkVersion);
  });
}

export function addAppEvent(eventKey: string, data: Object|null) {
  MobileSdkReactNative.addAppEvent(eventKey, data);
}

export async function identity(value: string, type: string) {
  try {
  const isSuccess: boolean = await MobileSdkReactNative.identity(value, type);
  return isSuccess;
  }catch(e) {
    return false;
  }
}

export async function detachIdentity() {
  const isSuccess = await MobileSdkReactNative.detachIdentity();
  return isSuccess;
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

export function getAppVersion(callback: (version: string) => void) {
  MobileSdkReactNative.getAppVersion((appVersion: string) => {
    callback(appVersion);
  });
}

export function registerForMobileMessage(token: string) {
  MobileSdkReactNative.registerForMobileMessage(token);
}

export function handleMobileMessage(data: Object, callback: (success: boolean) => void) {
  MobileSdkReactNative.handleMobileMessage(data, (isSuccess: boolean) => {
    callback(isSuccess);
  });
}

export {InlineAdView};
export {InterstitialAdView};
const SASMobileMessagingEvent = NativeModules.SASMobileMessagingEvent;
const AdDelegateEvent = NativeModules.AdDelegateEvent;
export {SASMobileMessagingEvent};
export {AdDelegateEvent};
export { Constants };
