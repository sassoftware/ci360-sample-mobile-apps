"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _reactNative = require("react-native");
// import React from 'react';

const ComponentName = 'InlineAdView';
const LINKING_ERROR = `The ${ComponentName} does not seem to be linked`;
const InlineAdView = _reactNative.UIManager.getViewManagerConfig(ComponentName) != null ? (0, _reactNative.requireNativeComponent)(ComponentName) : () => {
  throw new Error(LINKING_ERROR);
};
var _default = InlineAdView;
exports.default = _default;
//# sourceMappingURL=InlineAdView.js.map