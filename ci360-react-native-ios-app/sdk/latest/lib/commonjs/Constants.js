"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.TYPE_INTERSTITIAL_AD = exports.TYPE_INLINE_AD = exports.MESSAGE_OPENED = exports.MESSAGE_NOTIFICATION_LINK_RECEIVED = exports.MESSAGE_DISMISSED = exports.IDENTITY_TYPE_LOGIN = exports.IDENTITY_TYPE_EMAIL = exports.IDENTITY_TYPE_CUSTOMER_ID = exports.AD_WILL_RESIZE = exports.AD_WILL_EXPAND = exports.AD_WILL_CLOSE = exports.AD_WILL_BEGIN_ACTION = exports.AD_RESIZE_FINISHED = exports.AD_LOAD_FAILED = exports.AD_LOADED = exports.AD_EXPAND_FINISHED = exports.AD_CLOSED = exports.AD_ACTION_FINISHED = void 0;
const TYPE_INLINE_AD = "InlineAd";
exports.TYPE_INLINE_AD = TYPE_INLINE_AD;
const TYPE_INTERSTITIAL_AD = "InterstitialAd";

//These are used in identity function.
exports.TYPE_INTERSTITIAL_AD = TYPE_INTERSTITIAL_AD;
const IDENTITY_TYPE_EMAIL = "email_id";
exports.IDENTITY_TYPE_EMAIL = IDENTITY_TYPE_EMAIL;
const IDENTITY_TYPE_LOGIN = "login_id";
exports.IDENTITY_TYPE_LOGIN = IDENTITY_TYPE_LOGIN;
const IDENTITY_TYPE_CUSTOMER_ID = "customer_id";

// These are used in inline/interstitial ad view's delegate methods
exports.IDENTITY_TYPE_CUSTOMER_ID = IDENTITY_TYPE_CUSTOMER_ID;
const AD_LOADED = "onAdLoaded";
exports.AD_LOADED = AD_LOADED;
const AD_LOAD_FAILED = "onAdLoadFailed";
exports.AD_LOAD_FAILED = AD_LOAD_FAILED;
const AD_WILL_BEGIN_ACTION = "onAdWillBeginAction";
exports.AD_WILL_BEGIN_ACTION = AD_WILL_BEGIN_ACTION;
const AD_ACTION_FINISHED = "onAdActionFinished";
exports.AD_ACTION_FINISHED = AD_ACTION_FINISHED;
const AD_WILL_RESIZE = "onAdWillResize";
exports.AD_WILL_RESIZE = AD_WILL_RESIZE;
const AD_RESIZE_FINISHED = "onAdResizeFinished";
exports.AD_RESIZE_FINISHED = AD_RESIZE_FINISHED;
const AD_WILL_EXPAND = "onAdWillExpand";
exports.AD_WILL_EXPAND = AD_WILL_EXPAND;
const AD_EXPAND_FINISHED = "onAdExpandFinished";
exports.AD_EXPAND_FINISHED = AD_EXPAND_FINISHED;
const AD_WILL_CLOSE = "onAdWillClose";
exports.AD_WILL_CLOSE = AD_WILL_CLOSE;
const AD_CLOSED = "onAdClosed";

// These are used in mobile message methods
exports.AD_CLOSED = AD_CLOSED;
const MESSAGE_OPENED = "onMessageOpened";
exports.MESSAGE_OPENED = MESSAGE_OPENED;
const MESSAGE_DISMISSED = "onMessageDismissed";
exports.MESSAGE_DISMISSED = MESSAGE_DISMISSED;
const MESSAGE_NOTIFICATION_LINK_RECEIVED = "onNotificationLinkReceived";
exports.MESSAGE_NOTIFICATION_LINK_RECEIVED = MESSAGE_NOTIFICATION_LINK_RECEIVED;
//# sourceMappingURL=Constants.js.map