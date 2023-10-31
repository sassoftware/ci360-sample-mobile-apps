package com.sas.SASIA.mobile_sdk_flutter;

import androidx.annotation.NonNull;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import java.util.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;

import com.sas.SASIA.mobile_sdk_flutter.views.InterstitialAdViewFactory;
import com.sas.SASIA.mobile_sdk_flutter.views.InlineAdViewFactory;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.SASCollectorEvent;


/** MobileSdkFlutterPlugin */
public class MobileSdkFlutterPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    PlatformViewRegistry registry = flutterPluginBinding.getPlatformViewRegistry();
    BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
    registry.registerViewFactory(Constants.Inline_Ad_View, new InlineAdViewFactory(messenger));
    registry.registerViewFactory(Constants.Interstitial_Ad_View, new InterstitialAdViewFactory(messenger));

    channel = new MethodChannel(messenger, "mobile_sdk_flutter");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();

    Log.d("onAttachedToEngine", "onAttachedToEngine is called");
    Log.d("Plugin", "onAttachedToEngine is called");  
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        return;
      case "newPage":       
        SASCollector.getInstance().newPage(call.argument("uri"));
        result.success(null);
        return;
      case "addAppEvent":
        String eventKey = call.argument("eventKey");
        HashMap<String, String> data = call.argument("data");
        if (data == null) {
          SASCollectorEvent event = new SASCollectorEvent(eventKey);
          SASCollector.getInstance().addAppEvent(event);
          result.success(null);
          return;
        } else {
          System.out.println(eventKey);
          System.out.println(data.toString());

          SASCollector.getInstance().addAppEvent(eventKey, data);
        }
          result.success(null);
          return;
      case "identity":
        String value = call.argument("value");
        String type = call.argument("type");
        SASCollector.getInstance().identity(value, type, new SASCollector.IdentityCallback() {
          public void onComplete(boolean identityResult) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
              @Override
              public void run() {
                result.success(identityResult);
              }
            });
          }
        });
        return;
      case "detachIdentity":
        SASCollector.getInstance().detachIdentity(new SASCollector.DetachIdentityCallback() {
          @Override
          public void onComplete(boolean detachResult) {
            new Handler(Looper.getMainLooper()).post(new Runnable() {
              @Override
              public void run() {
                result.success(detachResult);
              }
            });

          }
        });
        return;
      case "registerForMobileMessages":
        String token = call.argument("token");
        SASCollector.getInstance().registerForMobileMessages(token);
        return;
      case "handleMobileMessage":
        Map<String, String> msgData = call.argument("data");
        SASCollector.getInstance().handleMobileMessage(msgData);
        result.success(null);
        return;
      case "isEnabled":

        return;
      case "getSessionBindingParameter":
        String bindingParam = SASCollector.getInstance().getSessionBindingParameter();
        System.out.println("bindingParam: " + bindingParam);       
        result.success(bindingParam);
        return;
      case "resetDeviceId":
        SASCollector.getInstance().resetDeviceID();
        result.success(null);
        return;
      case "getDeviceId":
        result.success(SASCollector.getInstance().getDeviceID());
        return;
      case "getTenantId":
        result.success(SASCollector.getInstance().getTenantID());
        return;
      case "setTenantId":
        String newId = call.argument("tenantId");
        SASCollector.getInstance().setTenantID(newId);
        result.success(null);
        return;
      case "getTagServer":
        result.success(SASCollector.getInstance().getTagServer());
        return;
      case "setTagServer":
        String newServer = call.argument("tagServer");
        SASCollector.getInstance().setTagServer(newServer);
        result.success(null);
        return;
      case "disableLocationMonitoring":
        SASCollector.getInstance().disableLocationMonitoring();
        result.success(null);
        return;
      case "startMonitoringLocation":
        SASCollector.getInstance().startMonitoringLocation();
        result.success(null);
        return;
      case "shutdown":
        SASCollector.getInstance().shutdown();
        result.success(null);
        return;
      case "getApplicationVersion":
        result.success(SASCollector.getInstance().getApplicationVersion());
        return;
      case "setApplicationVersion":
        String newVersion = call.argument("appVersion");
        SASCollector.getInstance().setApplicationVersion(newVersion);
        result.success(null);
        return;
      case "getSDKVersion":
        result.success("");
        return;
      case "setTenant":
        String tenantId = call.argument("tenantId");
        String tagServer = call.argument("tagServer");
        String appId = call.argument("appId");
        SASCollector.getInstance().setTenantID(tenantId);
        SASCollector.getInstance().setTagServer(tagServer);      
        SASCollector.getInstance().initialize(context);   
        if (SASCollector.getInstance().getTenantID() == tenantId)
        {
          result.success(true);              
        }
        else
        {
          result.success(false);  
        }
        return;
      default:
        return;
    }
    
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onDetachedFromActivity() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    System.out.println("onAttachedToActivity is called");
    SASCollector.getInstance().initialize(context);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }


}
