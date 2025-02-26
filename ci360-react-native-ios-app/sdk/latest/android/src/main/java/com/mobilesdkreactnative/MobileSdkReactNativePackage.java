package com.mobilesdkreactnative;

import androidx.annotation.NonNull;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.mobilesdkreactnative.views.InlineAdViewManager;
import com.mobilesdkreactnative.views.InlineAdViewWithLocalResourcesManager;
import com.mobilesdkreactnative.views.InterstitialAdViewManager;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MobileSdkReactNativePackage implements ReactPackage {
    @NonNull
    @Override
    public List<NativeModule> createNativeModules(@NonNull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new MobileSdkReactNativeModule(reactContext));
        return modules;
    }

    @NonNull
    @Override
    public List<ViewManager> createViewManagers(@NonNull ReactApplicationContext reactContext) {
      InlineAdViewManager inlineAdViewManager = new InlineAdViewManager(reactContext);
      InlineAdViewWithLocalResourcesManager inlineAdViewManagerLocalResources = new InlineAdViewWithLocalResourcesManager(reactContext);
      InterstitialAdViewManager interstitialAdViewManager = new InterstitialAdViewManager(reactContext);
        return Arrays.<ViewManager>asList(inlineAdViewManager, inlineAdViewManagerLocalResources, interstitialAdViewManager);
    }
}
