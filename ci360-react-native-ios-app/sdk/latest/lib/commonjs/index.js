"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.Constants = exports.AdDelegateEvent = void 0;
Object.defineProperty(exports, "InlineAdView", {
  enumerable: true,
  get: function () {
    return _InlineAdView.default;
  }
});
Object.defineProperty(exports, "InterstitialAdView", {
  enumerable: true,
  get: function () {
    return _InterstitialAdView.default;
  }
});
exports.SASMobileMessagingEvent = void 0;
exports.addAppEvent = addAppEvent;
exports.detachIdentity = detachIdentity;
exports.getAppVersion = getAppVersion;
exports.getDeviceID = getDeviceID;
exports.getSdkVersion = getSdkVersion;
exports.getSessionID = getSessionID;
exports.getTagServer = getTagServer;
exports.getTenantID = getTenantID;
exports.handleMobileMessage = handleMobileMessage;
exports.identity = identity;
exports.multiply = multiply;
exports.newPage = newPage;
exports.registerForMobileMessage = registerForMobileMessage;
var _reactNative = require("react-native");
var _InlineAdView = _interopRequireDefault(require("./views/InlineAdView"));
var _InterstitialAdView = _interopRequireDefault(require("./views/InterstitialAdView"));
var Constants = _interopRequireWildcard(require("./Constants"));
exports.Constants = Constants;
function _getRequireWildcardCache(nodeInterop) { if (typeof WeakMap !== "function") return null; var cacheBabelInterop = new WeakMap(); var cacheNodeInterop = new WeakMap(); return (_getRequireWildcardCache = function (nodeInterop) { return nodeInterop ? cacheNodeInterop : cacheBabelInterop; })(nodeInterop); }
function _interopRequireWildcard(obj, nodeInterop) { if (!nodeInterop && obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { default: obj }; } var cache = _getRequireWildcardCache(nodeInterop); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (key !== "default" && Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj.default = obj; if (cache) { cache.set(obj, newObj); } return newObj; }
function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }
const LINKING_ERROR = `The package 'mobile-sdk-react-native' doesn't seem to be linked. Make sure: \n\n` + _reactNative.Platform.select({
  ios: "- You have run 'pod install'\n",
  default: ''
}) + '- You rebuilt the app after installing the package\n' + '- You are not using Expo Go\n';
const MobileSdkReactNative = _reactNative.NativeModules.MobileSdkReactNative ? _reactNative.NativeModules.MobileSdkReactNative : new Proxy({}, {
  get() {
    throw new Error(LINKING_ERROR);
  }
});
function multiply(a, b) {
  return MobileSdkReactNative.multiply(a, b);
}
function newPage(uri) {
  return MobileSdkReactNative.newPage(uri);
}
function getSessionID(callback) {
  MobileSdkReactNative.getSessionID(sessionID => {
    callback(sessionID);
  });
}
function getSdkVersion(callback) {
  MobileSdkReactNative.getSdkVersion(sdkVersion => {
    callback(sdkVersion);
  });
}
function addAppEvent(eventKey, data) {
  MobileSdkReactNative.addAppEvent(eventKey, data);
}
async function identity(value, type) {
  try {
    const isSuccess = await MobileSdkReactNative.identity(value, type);
    return isSuccess;
  } catch (e) {
    return false;
  }
}
async function detachIdentity() {
  const isSuccess = await MobileSdkReactNative.detachIdentity();
  return isSuccess;
}
function getTenantID(callback) {
  MobileSdkReactNative.getTenantID(tenantID => {
    callback(tenantID);
  });
}
function getDeviceID(callback) {
  MobileSdkReactNative.getDeviceID(deviceID => {
    callback(deviceID);
  });
}
function getTagServer(callback) {
  MobileSdkReactNative.getTagServer(serverID => {
    callback(serverID);
  });
}
function getAppVersion(callback) {
  MobileSdkReactNative.getAppVersion(appVersion => {
    callback(appVersion);
  });
}
function registerForMobileMessage(token) {
  MobileSdkReactNative.registerForMobileMessage(token);
}
function handleMobileMessage(data, callback) {
  MobileSdkReactNative.handleMobileMessage(data, isSuccess => {
    callback(isSuccess);
  });
}
const SASMobileMessagingEvent = _reactNative.NativeModules.SASMobileMessagingEvent;
exports.SASMobileMessagingEvent = SASMobileMessagingEvent;
const AdDelegateEvent = _reactNative.NativeModules.AdDelegateEvent;
exports.AdDelegateEvent = AdDelegateEvent;
//# sourceMappingURL=index.js.map