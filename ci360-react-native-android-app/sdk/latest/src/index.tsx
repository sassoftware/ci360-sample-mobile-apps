import NativeMobileSdkReactNative from './NativeMobileSdkReactNative';
import { NativeModules } from 'react-native';
import InlineAdView from './views/InlineAdView';
import InlineAdViewWithLocalResources from './views/InlineAdViewWithLocalResources';
import InterstitialAdView from './views/InterstitialAdView';
import * as Constants from './Constants';

export function setAppVersionAndInitSDK(appVersion: string): void {
  NativeMobileSdkReactNative.setAppVersionAndInitSDK(appVersion);
}

export function newPage(uri: string): void {
  NativeMobileSdkReactNative.newPage(uri);
}

export function addAppEvent(eventKey: string, data: Object|null): void {
  NativeMobileSdkReactNative.addAppEvent(eventKey, data);
}

export async function identity(value: string, type: string): Promise<boolean> {
  try {
    const isSuccess: boolean = await NativeMobileSdkReactNative.identity(value, type);
    return isSuccess;
  } catch (e) {
    return false;
  }
}

export async function detachIdentity(): Promise<boolean> {
  try {
    const isSuccess = await NativeMobileSdkReactNative.detachIdentity();
    return isSuccess;
  } catch (e) {
    return false;
  }
}

export function startMonitoringLocation(): void {
  NativeMobileSdkReactNative.startMonitoringLocation();
}

export function disableLocationMonitoring(): void {
  NativeMobileSdkReactNative.disableLocationMonitoring();
}

export function getTenantID(callback: (id: string) => void): void {
  NativeMobileSdkReactNative.getTenantID((tenantID: string) => {
    callback(tenantID);
  });
}

export function getDeviceID(callback: (id: string) => void): void {
  NativeMobileSdkReactNative.getDeviceID((deviceID: string) => {
    callback(deviceID);
  });
}

export function getTagServer(callback: (id: string) => void): void {
  NativeMobileSdkReactNative.getTagServer((serverID: string) => {
    callback(serverID);
  });
}

export function getApplicationVersion(
  callback: (version: string) => void
): void {
  NativeMobileSdkReactNative.getApplicationVersion((appVersion: string) => {
    callback(appVersion);
  });
}

export function setApplicationVersion(version: string): void {
  NativeMobileSdkReactNative.setApplicationVersion(version);
}

export function registerForMobileMessage(token: string): void {
  NativeMobileSdkReactNative.registerForMobileMessage(token);
}

export function handleMobileMessage(
  data: Object,
  callback: (success: boolean) => void
): void {
  NativeMobileSdkReactNative.handleMobileMessage(data, (isSuccess: boolean) => {
    callback(isSuccess);
  });
}

export async function loadSpotData(
  spotId: string,
  attributes: Object | null
): Promise<string> {
  try {
    return await NativeMobileSdkReactNative.loadSpotData(spotId, attributes);
  } catch (e) {
    return e;
  }
}

export function registerSpotViewable(spotId: string): void {
  NativeMobileSdkReactNative.registerSpotViewable(spotId);
}

export function registerSpotClicked(spotId: string): void {
  NativeMobileSdkReactNative.registerSpotClicked(spotId);
}

export { InlineAdView };
export { InlineAdViewWithLocalResources };
export { InterstitialAdView };
const SASMobileMessagingEvent = NativeModules.SASMobileMessagingEvent;
const AdDelegateEvent = NativeModules.AdDelegateEvent;
export { SASMobileMessagingEvent, AdDelegateEvent };
export { Constants };
