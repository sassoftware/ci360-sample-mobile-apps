package com.mobilesdkreactnative;

import android.content.Context;

import com.facebook.react.ReactApplication;
import com.facebook.react.bridge.ReactContext;

public class UseReactContext {
  public static ReactContext getReactContext(Context context) {
    ReactApplication reactApp = (ReactApplication) context.getApplicationContext();
    ReactContext reactContext = reactApp.getReactNativeHost().getReactInstanceManager().getCurrentReactContext();
    return reactContext;
  }
}
