package com.example.mobilesdkreactnative;

import static com.facebook.react.defaults.DefaultNewArchitectureEntryPoint.load;

import android.app.Application;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.graphics.Color;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.facebook.react.PackageList;
import com.facebook.react.ReactApplication;
import com.facebook.react.ReactHost;
import com.facebook.react.ReactNativeHost;
import com.facebook.react.ReactPackage;
import com.facebook.react.defaults.DefaultReactHost;
import com.facebook.react.defaults.DefaultReactNativeHost;
import com.facebook.react.soloader.OpenSourceMergedSoMapping;

import com.facebook.react.config.ReactFeatureFlags;
import com.facebook.soloader.SoLoader;
//import com.example.mobilesdkreactnative.newarchitecture.MainApplicationReactNativeHost;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

public class MainApplication extends Application implements ReactApplication {


  private final ReactNativeHost mReactNativeHost =
      new DefaultReactNativeHost(this) {
        @Override
        protected boolean isNewArchEnabled() {
          return BuildConfig.IS_NEW_ARCHITECTURE_ENABLED;
        }

        @Override
        protected Boolean isHermesEnabled() {
          return BuildConfig.IS_HERMES_ENABLED;
        }

        @Override
        public boolean getUseDeveloperSupport() {
          return BuildConfig.DEBUG;
        }


        @Override
        protected List<ReactPackage> getPackages() {
          @SuppressWarnings("UnnecessaryLocalVariable")
          List<ReactPackage> packages = new PackageList(this).getPackages();
          // Packages that cannot be autolinked yet can be added manually here, for example:
          // packages.add(new MyReactNativePackage());
          // packages.add(new VectorIconsPackage());
          return packages;
        }

        @Override
        protected String getJSMainModuleName() {
          return "index";
        }
      };

//  private final ReactNativeHost mNewArchitectureNativeHost =
//      new MainApplicationReactNativeHost(this);

  @NonNull
  @Override
  public ReactNativeHost getReactNativeHost() {
//    if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
//      return mNewArchitectureNativeHost;
//    } else {
      return mReactNativeHost;
//    }
  }

  @Nullable
  @Override
  public ReactHost getReactHost() {
    return DefaultReactHost.getDefaultReactHost(getApplicationContext(), getReactNativeHost());
  }

  @Override
  public void onCreate() {
    super.onCreate();
    SLog.setLevel(SLog.ALL);
//    SASCollector.getInstance().initialize(this);
    // If you opted-in for the New Architecture, we enable the TurboModule system
//    ReactFeatureFlags.useTurboModules = BuildConfig.IS_NEW_ARCHITECTURE_ENABLED;
//    SoLoader.init(this, /* native exopackage */ false);
    try {
      SoLoader.init(this, OpenSourceMergedSoMapping.INSTANCE);
      if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
        // If you opted-in for the New Architecture, we load the native entry point for this app.
        load();
      }
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
//    initializeFlipper(this, getReactNativeHost().getReactInstanceManager());
  }

  /**
//   * Loads Flipper in React Native templates. Call this in the onCreate method with something like
//   * initializeFlipper(this, getReactNativeHost().getReactInstanceManager());
//   *
//   * @param context
//   * @param reactInstanceManager
//   */
//  private static void initializeFlipper(
//      Context context, ReactInstanceManager reactInstanceManager) {
//    if (BuildConfig.DEBUG) {
//      try {
//        /*
//         We use reflection here to pick up the class that initializes Flipper,
//        since Flipper library is not available in release mode
//        */
//        Class<?> aClass = Class.forName("com.example.mobilesdkreactnative.ReactNativeFlipper");
//        aClass
//            .getMethod("initializeFlipper", Context.class, ReactInstanceManager.class)
//            .invoke(null, context, reactInstanceManager);
//      } catch (ClassNotFoundException e) {
//        e.printStackTrace();
//      } catch (NoSuchMethodException e) {
//        e.printStackTrace();
//      } catch (IllegalAccessException e) {
//        e.printStackTrace();
//      } catch (InvocationTargetException e) {
//        e.printStackTrace();
//      }
//    }
//  }

  @RequiresApi(api = Build.VERSION_CODES.O)
  private void setPushChannel() {
    NotificationManager notificationManager =
      (NotificationManager) this.getSystemService(this.NOTIFICATION_SERVICE);

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
