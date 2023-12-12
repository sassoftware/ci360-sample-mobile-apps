"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.default = void 0;
var _reactNative = require("react-native");
const ComponentName = 'InterstitialAdView';
const LINKING_ERROR = `The ${ComponentName} doesn't seem to be linked`;
const InterstitialAdView = _reactNative.UIManager.getViewManagerConfig(ComponentName) != null ? (0, _reactNative.requireNativeComponent)(ComponentName) : () => {
  throw new Error(LINKING_ERROR);
};
var _default = InterstitialAdView;
exports.default = _default;
//# sourceMappingURL=InterstitialAdView.js.map