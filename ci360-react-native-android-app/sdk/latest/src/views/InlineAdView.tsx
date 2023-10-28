// import React from 'react';
import { requireNativeComponent, UIManager, } from "react-native";

type Props = {
  spotId: string;
  // style: ViewStyle;
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
