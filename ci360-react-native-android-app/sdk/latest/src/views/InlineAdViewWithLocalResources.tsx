//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 React Native Demo Application                                                        #
//# File Name: InlineAdViewWithLocalResources.tsx                                                                #
//# File Description: React Native component for rendering inline ads with local resources.                     #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023       
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import { requireNativeComponent, UIManager, ViewStyle } from 'react-native';

type Props = {
  spotId: string;
  useLocResources: boolean;
  resourcePath: string;
  viewId: string;
  notVisible: boolean;
  style: ViewStyle;
};

const ComponentName = 'InlineAdViewWithLocalResources';

const LINKING_ERROR = `The ${ComponentName} does not seem to be linked`;

const InlineAdViewWithLocalResources =
UIManager.getViewManagerConfig(ComponentName) != null
? requireNativeComponent<Props>(ComponentName)
: () => {
  throw new Error(LINKING_ERROR);
};

export default InlineAdViewWithLocalResources;
