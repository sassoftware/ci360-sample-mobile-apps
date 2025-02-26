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
