package com.mobilesdkreactnative.views;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.mobilesdkreactnative.Constants;
import com.mobilesdkreactnative.UseReactContext;
import com.sas.ia.android.sdk.AbstractAd;
import com.sas.ia.android.sdk.AdDelegate;
import com.sas.ia.android.sdk.InterstitialAd;
import com.sas.mkt.mobile.sdk.ads.SASCollectorInterstitialAd;

public class InterstitialAdViewManager extends ViewGroupManager<RelativeLayout> {
  private String spotID = "";
  public static final String NAME = "InterstitialAdView";
  ReactApplicationContext callerContext;

  public InterstitialAdViewManager(ReactApplicationContext reactContext) {
    callerContext = reactContext;
  }

  @NonNull
  @Override
  public String getName() {
    return NAME;
  }

  @NonNull
  @Override
  protected RelativeLayout createViewInstance(@NonNull ThemedReactContext reactContext) {
    InterstitialAdView adView = new InterstitialAdView(reactContext);
    adView.setBackgroundColor(Color.LTGRAY);
    return adView;
  }

  @ReactProp(name = "spotId")
  public void setSpotID(SASCollectorInterstitialAd interstitialAdView, @Nullable String spotID) {
    if (spotID != null) {
      this.spotID = spotID;
    }
    interstitialAdView.load(this.spotID, null);
  }

  protected class InterstitialAdView extends SASCollectorInterstitialAd {

    Context context;

    public InterstitialAdView(Context context) {
      super(((ReactContext) context).getCurrentActivity());
      this.context = context; // (ReactContext) context;

      setDelegate(new AdDelegate() {
        @Override
        public void onLoaded(AbstractAd ad) {
          super.onLoaded(ad);
          ((InterstitialAd) ad).show();
          sendEvent(Constants.AD_LOADED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public void onDefaultLoaded(AbstractAd ad) {
          super.onDefaultLoaded(ad);
          sendEvent(Constants.AD_DEFAULT_LOADED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public void onLoadFailed(AbstractAd ad, int errorCode, String description, String failingUrl) {
          super.onLoadFailed(ad, errorCode, description, failingUrl);
          sendEvent(Constants.AD_LOAD_FAILED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public boolean willBeginAction(AbstractAd ad, String url) {
          sendEvent(Constants.AD_WILL_BEGIN_ACTION, Constants.TYPE_INTERSTITIAL_AD);
          return super.willBeginAction(ad, url);
        }

        @Override
        public void onActionFinished(AbstractAd ad) {
          super.onActionFinished(ad);
          sendEvent(Constants.AD_ACTION_FINISHED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public boolean willResize(AbstractAd ad, Rect size) {
          sendEvent(Constants.AD_WILL_RESIZE, Constants.TYPE_INTERSTITIAL_AD);
          return super.willResize(ad, size);
        }

        @Override
        public void onResizeFinished(AbstractAd ad) {
          super.onResizeFinished(ad);
          sendEvent(Constants.AD_RESIZE_FINISHED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public boolean willExpand(AbstractAd ad, String url) {
          sendEvent(Constants.AD_WILL_EXPAND, Constants.TYPE_INTERSTITIAL_AD);
          return super.willExpand(ad, url);
        }

        @Override
        public void onExpandFinished(AbstractAd ad) {
          super.onExpandFinished(ad);
          sendEvent(Constants.AD_EXPAND_FINISHED, Constants.TYPE_INTERSTITIAL_AD);
        }

        @Override
        public boolean willClose(AbstractAd ad) {
          sendEvent(Constants.AD_WILL_CLOSE, Constants.TYPE_INTERSTITIAL_AD);
          return super.willClose(ad);
        }

        @Override
        public void onClosed(AbstractAd ad) {
          super.onClosed(ad);
          sendEvent(Constants.AD_CLOSED, Constants.TYPE_INTERSTITIAL_AD);
        }
      });
    }

    private void sendEvent(String eventName, String type) {
      ReactContext reactContext = UseReactContext.getReactContext(InterstitialAdView.this.getContext());
      reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, type);
    }
  }
}
