package com.mobilesdkreactnative;

import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.graphics.Color;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;
import com.google.firebase.messaging.FirebaseMessaging;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;


import java.util.HashMap;
import java.util.Map;

@ReactModule(name = MobileSdkReactNativeModule.NAME)
public class MobileSdkReactNativeModule extends ReactContextBaseJavaModule {
    public static final String NAME = "MobileSdkReactNative";

    public MobileSdkReactNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

  @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void setAppVersionAndInitSDK(String appVersion) {
      if (appVersion.matches("^\\d+\\.\\d+\\.\\d+$")) {
        SASCollector.getInstance().setApplicationVersion(appVersion);
      } else {
        SASCollector.getInstance().setApplicationVersion("0.0.1");
      }
      SASCollector.getInstance().initialize(getCurrentActivity());
      FirebaseMessaging.getInstance().getToken().addOnSuccessListener(token -> {
        Log.d("SASModule", "token="+token);
        if(!TextUtils.isEmpty(token)) {
          SASCollector.getInstance().registerForMobileMessages(token);
        }
      });
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        setPushChannel();
      }
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
      HashMap<String, Object> rawData = data.toHashMap();
      HashMap<String, String> convertedData = new HashMap<>();
      for (Map.Entry<String, Object> entry : rawData.entrySet()) {
        if(entry.getValue() instanceof String) {
          convertedData.put(entry.getKey(), (String)entry.getValue());
        }
      }
      SASCollector.getInstance().addAppEvent(eventKey, convertedData);
    }

   @ReactMethod
   public void identity(String value, String type, Promise promise) {
     SASCollector.getInstance().identity(value, type, new SASCollector.IdentityCallbackWithMessage() {
       @Override
       public void onComplete(boolean b, String message) {
         SLog.d("Identity", "Identity called with: " + (b ? "success" : "failure"));
         SLog.d("Identity callback message", message);

         new Handler(Looper.getMainLooper()).post(new Runnable() {
           @Override
           public void run() {
             promise.resolve(b);
           }
         });
       }
     });
   }

    @ReactMethod
    public void detachIdentity(Promise promise) { //SASCollector.DetachIdentityCallback callback
      SASCollector.getInstance().detachIdentity(new SASCollector.DetachIdentityCallback() {
        @Override
        public void onComplete(boolean b) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
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
    public void getApplicationVersion(Callback callback) {
      callback.invoke(SASCollector.getInstance().getApplicationVersion());
    }

  @ReactMethod
  public void setApplicationVersion(String version) {
      if (version.matches("^\\d+\\.\\d+\\.\\d+$")) {
        SASCollector.getInstance().setApplicationVersion(version);
      }
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
  public void handleMobileMessage(ReadableMap data) {
      HashMap<String, String> convertedData = MapConverter.convertReadableMapToHashMap(data);
    SASCollector.getInstance().handleMobileMessage(convertedData);
  }

  @ReactMethod
  public void loadSpotData(String spotId, ReadableMap attributes, Promise promise) {
      SASCollector.SpotDataCallback spotDataCallback = new SASCollector.SpotDataCallback() {
        @Override
        public void data(String spotId, String content) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              promise.resolve(content);
            }
          });
        }
        @Override
        public void noData(String spotData) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              promise.resolve("No Data");
            }
          });
        }
        @Override
        public void failure(String spotId, int errCode, String errMsg) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              promise.resolve("Failed with error message" + errMsg);
            }
          });
        }
      };
      if (attributes == null) {
        SASCollector.getInstance().loadSpotData(spotId, spotDataCallback);
      } else {
        HashMap<String, String> convertedAttrs = MapConverter.convertReadableMapToHashMap(attributes);
        SASCollector.getInstance().loadSpotData(spotId, convertedAttrs, spotDataCallback);
      }
  }
  @ReactMethod
  public void registerSpotViewable(String spotId) {
      SASCollector.getInstance().registerSpotViewable(spotId);
  }
  @ReactMethod
  public void registerSpotClicked(String spotId) {
      SASCollector.getInstance().registerSpotClicked(spotId);
  }

  @RequiresApi(api = Build.VERSION_CODES.O)
  private void setPushChannel() {
    NotificationManager notificationManager =
      (NotificationManager) getCurrentActivity().getSystemService(getCurrentActivity().NOTIFICATION_SERVICE);

    String customAndroidChannel = "ReactNativePushChannel";
    CharSequence channelName = "React Native Channel";
    int importance = NotificationManager.IMPORTANCE_HIGH;
    NotificationChannel notificationChannel = new NotificationChannel(customAndroidChannel, channelName, importance);
    notificationChannel.enableLights(true);
    notificationChannel.setLightColor(Color.RED);
    notificationChannel.enableVibration(true);
    notificationChannel.setShowBadge(true);
    notificationChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
    notificationManager.createNotificationChannel(notificationChannel);

    SASCollector.getInstance().setPushNotificationChannelId(customAndroidChannel);
  }
}

