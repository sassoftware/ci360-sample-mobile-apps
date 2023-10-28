package com.mobilesdkreactnative;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import androidx.annotation.NonNull;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.sas.mkt.mobile.sdk.SASCollector;
import java.util.HashMap;
import java.util.Map;
import androidx.annotation.NonNull;
import java.util.HashMap;
import java.util.Map;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.InternalSingleton;

@ReactModule(name = MobileSdkReactNativeModule.NAME)
public class MobileSdkReactNativeModule extends ReactContextBaseJavaModule {
  public static final String NAME = "MobileSdkReactNative";

  public MobileSdkReactNativeModule(ReactApplicationContext reactContext) {
    super(reactContext);
    if (!SASCollector.getInstance().isInitialized()) {
      SASCollector.getInstance().initialize(reactContext.getApplicationContext());
    }
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  @ReactMethod
  public void newPage(String uri) {
    SASCollector.getInstance().newPage(uri);
  }

  @ReactMethod
  public void addAppEvent(String eventKey, ReadableMap data) {
    if (data == null) {
      SASCollector.getInstance().addAppEvent(eventKey, null);
      return;
    }
    System.out.println(eventKey);
    HashMap<String, Object> rawData = data.toHashMap();
    // String rawData = data;
    HashMap<String, String> convertedData = new HashMap<>();
    // String convertedData = data;
    for (Map.Entry<String, Object> entry : rawData.entrySet()) {
      if (entry.getValue() instanceof String) {
        convertedData.put(
            entry.getKey(), (String) entry.getValue());
      }
    }
    System.out.println(eventKey);
    SASCollector.getInstance().addAppEvent(eventKey, convertedData);
  }

  @ReactMethod
  public void identity(
      String value, String type, Promise promise) {
    SASCollector.getInstance()
        .identity(value, type,
            new SASCollector.IdentityCallback() {
              @Override
              public void onComplete(boolean b) {
                Log.d("Identity", "Identity called with: "
                    + (b ? "success" : "failure"));
                new Handler(Looper.getMainLooper())
                    .post(new Runnable() {
                      @Override
                      public void run() {
                        promise.resolve(b);
                      }
                    });
              }
            });
  }

  @ReactMethod
  public void detachIdentity(Promise promise) {
    SASCollector.getInstance()
        .detachIdentity(new SASCollector.DetachIdentityCallback() {
          @Override
          public void onComplete(boolean b) {
            new Handler(Looper.getMainLooper())
                .post(new Runnable() {
                  @Override
                  public void run() {
                    promise.resolve(b);
                  }
                });
          }
        });
  }

  @ReactMethod
  public void startMonitoringLocation() {
    SASCollector.getInstance().startMonitoringLocation();
  }

  @ReactMethod
  public void disableLocationMonitoring() {
    SASCollector.getInstance().disableLocationMonitoring();
  }

  @ReactMethod
  public void resetDeviceID() {
    SASCollector.getInstance().resetDeviceID();
  }

  @ReactMethod
  public void getDeviceID(Callback callback) {
    callback.invoke(SASCollector.getInstance().getDeviceID());
  }

  @ReactMethod
  public void getTenantID(Callback callback) {
    callback.invoke(SASCollector.getInstance().getTenantID());
  }

  @ReactMethod
  public void getAppVersion(Callback callback) {
    callback.invoke(SASCollector.getInstance().getApplicationVersion());
  }

  @ReactMethod
  public void getTagServer(Callback callback) {
    callback.invoke(SASCollector.getInstance().getTagServer());
  }

  @ReactMethod
  public void registerForMobileMessage(String token) {
    SASCollector.getInstance().registerForMobileMessages(token);
  }

  @ReactMethod
  public void handleMobileMessage(Map<String, String> data) {
    SASCollector.getInstance().handleMobileMessage(data);
  }

  @ReactMethod
  public void defineAppId(String appID) {
    SASCollector.getInstance().setApplicationID(appID);
  }

  @ReactMethod
  public void defineAppVersion(String appVersion) {
    SASCollector.getInstance().setApplicationVersion(appVersion);
  }

  @ReactMethod
  public void defineTenantID(String tenantID) {
    SASCollector.getInstance().setTenantID(tenantID);
  }

  @ReactMethod
  public void defineTagServer(String tagServer) {
    SASCollector.getInstance().setTagServer(tagServer);
  }

  @ReactMethod
  public void getSessionId(Callback callback) {
    callback.invoke(InternalSingleton.get().getSessionData().getCurrentSessionId());
  }

}
