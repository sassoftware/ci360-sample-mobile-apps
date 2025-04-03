import { TurboModule, TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  multiply(a: number, b: number): number;
  setAppVersionAndInitSDK(appVersion: string): void;
  newPage(uri: string): void;
  addAppEvent(eventKey: string, data: Object | null): void;
  // identity(value: string, type: string): Promise<boolean>;
  identity(value: string, type: string): Promise<boolean>;
  detachIdentity(): Promise<boolean>;
  startMonitoringLocation(): void;
  disableLocationMonitoring(): void;
  getTenantID(callback: (id: string) => void): void;
  getDeviceID(callback: (id: string) => void): void;
  getTagServer(callback: (id: string) => void): void;
  getApplicationVersion(callback: (version: string) => void): void;
  setApplicationVersion(version: string): void;
  registerForMobileMessage(token: string): void;
  handleMobileMessage(data: Object, callback: (success: boolean) => void): void;
  loadSpotData(spotId: string, attributes: Object | null): Promise<string>;
  registerSpotViewable(spotId: string): void;
  registerSpotClicked(spotId: string): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('MobileSdkReactNative');
