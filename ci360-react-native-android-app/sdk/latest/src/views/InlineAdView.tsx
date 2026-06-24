//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: constants.dart                                                                                   #
//# File Description: Defines global app-level constants and the AppState singleton for persisting login and tenant connection state across pages. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
// import React from 'react';
import { requireNativeComponent, UIManager, ViewStyle } from 'react-native';

type Props = {
  // useLocalResources?: boolean;
  // resourcePath?: string;
  spotId: string;
  viewId: string;
  notVisible: boolean;
  style: ViewStyle;
};

const ComponentName = 'InlineAdView';

const LINKING_ERROR = `The ${ComponentName} does not seem to be linked`;

const InlineAdView =
UIManager.getViewManagerConfig(ComponentName) != null
? requireNativeComponent<Props>(ComponentName)
: () => {
  throw new Error(LINKING_ERROR);
};

export default InlineAdView;
