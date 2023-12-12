package com.mobilesdkreactnativeexample;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.google.firebase.messaging.FirebaseMessaging;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.iam.SASMobileMessagingDelegate2;
import com.sas.mkt.mobile.sdk.util.SLog;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.Nullable;
import com.facebook.react.modules.core.DeviceEventManagerModule;

public class MainActivity extends ReactActivity { // implements ReactInstanceManager.ReactInstanceEventListener
  private static final String TAG = "MainActivity";
  private DeviceEventManagerModule.RCTDeviceEventEmitter emitter = null;
  private static final String DEFAULT_NOTIFICATION_ACTION_LINK_NAME = "SASCollectorIntentServicenotificationActionLink";
  private String notificationLink;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(null);
    // FirebaseApp.initializeApp(this);
    FirebaseMessaging.getInstance().getToken().addOnSuccessListener(token -> {
      Log.d(TAG, "token=" + token);
      if (!TextUtils.isEmpty(token)) {
        SASCollector.getInstance().registerForMobileMessages(token);
      }
    });

    if (emitter == null) {
      ReactInstanceManager manager = getReactNativeHost().getReactInstanceManager();
      manager
          .addReactInstanceEventListener((ReactInstanceManager.ReactInstanceEventListener) context -> emitter = context
              .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class));
    }

    Intent intent = getIntent();
    notificationLink = intent.getStringExtra("notificationWithLink");

    SASCollector.getInstance().setMobileMessagingDelegate2(new SASMobileMessagingDelegate2() {
      @Override
      public void dismissed() {
        Log.d("MainActivity", "push notification is dismissed");
        if (emitter != null) {
          emitter.emit("onMessageDismissed", null);
        }
      }

      @Override
      public void action(String s, SASMobileMessageType sasMobileMessageType) {
        if (sasMobileMessageType.equals(SASMobileMessageType.IN_APP_MESSAGE)) {
          WritableMap args = Arguments.createMap();
          args.putString("link", s);
          args.putString("type", "InAppMsg");

          if (emitter != null) {
            emitter.emit("onMessageOpened", args);
          }
        }
        Log.d("MainActivity", "action called");
      }

      @Override
      public Intent getNotificationIntent(String s) {
        SLog.i("getNotificationIntent", s);
        Intent intent = new Intent(MainActivity.this, MainActivity.class);
        intent.putExtra("notificationWithLink", s);
        return intent;
      }
    });
  }

  /**
   * Returns the name of the main component registered from JavaScript. This is
   * used to schedule
   * rendering of the component.
   */
  @Override
  protected String getMainComponentName() {
    return "MobileSdkReactNativeExample";
  }

  @Override
  public void onNewIntent(Intent intent) {
    // super.onNewIntent(intent);
    // notificationLink = intent.getStringExtra("notificationWithLink");
    // if (emitter != null && notificationLink != null &&
    // !notificationLink.isEmpty()) {
    // emitter.emit("onNotificationLinkReceived",
    // notificationLink);
    // }

    super.onNewIntent(intent);

    Bundle bundle = intent.getExtras();
    this.getIntent().putExtras(bundle);

    String notificationLink = intent.getStringExtra("notificationWithLink");
    if (emitter != null && notificationLink != null && !notificationLink.isEmpty()) {
      emitter.emit("onNotificationLinkReceived", notificationLink);
      intent.removeExtra("notificationWithLink");
    }
  }

  /**
   * Returns the instance of the {@link ReactActivityDelegate}. There the RootView
   * is created and
   * you can specify the rendered you wish to use (Fabric or the older renderer).
   */
  @Override
  protected ReactActivityDelegate createReactActivityDelegate() {
    return new MainActivityDelegate(this, getMainComponentName());
  }

  public static class MainActivityDelegate extends ReactActivityDelegate {
    private final @Nullable Activity activity;
    private Bundle initialProps = null;

    public MainActivityDelegate(ReactActivity activity, String mainComponentName) {
      super(activity, mainComponentName);
      this.activity = activity;
    }

    @Override
    protected ReactRootView createRootView() {
      ReactRootView reactRootView = new ReactRootView(getContext());
      // If you opted-in for the New Architecture, we enable the Fabric Renderer.
      reactRootView.setIsFabric(BuildConfig.IS_NEW_ARCHITECTURE_ENABLED);
      return reactRootView;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
      initialProps = new Bundle();
      final Bundle bundle = activity.getIntent().getExtras();
      if (bundle != null) {
        if (bundle.containsKey("notificationWithLink")) {
          initialProps.putString("notificationWithLink",
              bundle.getString("notificationWithLink"));
        } else if (bundle.containsKey(DEFAULT_NOTIFICATION_ACTION_LINK_NAME)) {
          initialProps.putString("notificationWithLink", bundle.getString(DEFAULT_NOTIFICATION_ACTION_LINK_NAME));
        }
      }
      super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    protected Bundle getLaunchOptions() {
      System.out.println(initialProps);
      return initialProps;
    }
  }

}
