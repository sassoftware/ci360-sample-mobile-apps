//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: RootNavigation.tsx                                                                                   #
//# File Description: Shared navigation reference helpers used to perform navigation actions outside screen components. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import { createNavigationContainerRef } from "@react-navigation/native";

export type RootTabParameterList = {
  Home: {
    screen?: 'HomeStack' | 'ProfileStack' | 'Notifications' | 'Content' | 'Search' | 'ServerSideContent' | 'ServerSideEvents';
    params?: any;
  };
  Profile: undefined;
  Settings: undefined;
  Config: undefined;
  Diagnostics?: { diagnosticLink: string };
};

export const navigationRef = createNavigationContainerRef<RootTabParameterList>();

export function navigate(name: keyof RootTabParameterList, params: any) {
  if (navigationRef.isReady()) {
    console.log(name, params);
    navigationRef.navigate(name, params);
  }
}