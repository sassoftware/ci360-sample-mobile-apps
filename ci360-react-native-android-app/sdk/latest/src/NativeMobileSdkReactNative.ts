//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: NativeMobileSdkReactNative.ts                                                                    #
//# File Description: Defines the TurboModule specification for native mobile SDK integration with React Native. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
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
  setCi360Id(ci360Id: string): void;
  getCi360Id(callback: (id: string) => void): void;
  registerSpotViewable(spotId: string): void;
  registerSpotClicked(spotId: string): void;
  registerSpotViewableWithIds(
    spotId: string,
    taskId: string,
    creativeId: string,
    recGroup: string | null,
    requestId: string | null
  ): void;
  registerSpotClickedWithIds(
    spotId: string,
    taskId: string,
    creativeId: string,
    recGroup: string | null,
    requestId: string | null
  ): void;
  getSessionID(callback: (id: string) => void): void;
  getLoadID(callback: (id: string) => void): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('MobileSdkReactNative');
