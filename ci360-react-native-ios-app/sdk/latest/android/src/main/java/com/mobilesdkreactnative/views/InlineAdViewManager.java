package com.mobilesdkreactnative.views;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import com.mobilesdkreactnative.Constants;
import com.sas.ia.android.sdk.AbstractAd;
import com.sas.ia.android.sdk.AdDelegate;
import com.sas.mkt.mobile.sdk.ads.SASCollectorAd;


public class InlineAdViewManager extends SimpleViewManager<SASCollectorAd> {
  public static final String NAME = "InlineAdView";
  ReactApplicationContext callerContext;

  public InlineAdViewManager(ReactApplicationContext reactContext) {
    callerContext = reactContext;
  }

  @NonNull
  @Override
  public String getName() {
    return NAME;
  }

  @NonNull
  @Override
  protected SASCollectorAd createViewInstance(@NonNull ThemedReactContext reactContext) {
    InlineAdView adView = new InlineAdView(reactContext);
    adView.getWebView().setLayoutParams(new RelativeLayout.LayoutParams(-1, -1));
    adView.setVisibility(View.VISIBLE);
    adView.setBackgroundColor(Color.LTGRAY);
    return adView;
  }

  @ReactProp(name = "spotId")
  public void setSpotId(InlineAdView inlineAdView, @Nullable String spotID) {
    if (spotID != null) {
      inlineAdView.setSpotId(spotID);
      inlineAdView.load(spotID, null);
    }
  }

  @ReactProp(name = "viewId")
  public void setViewId(InlineAdView inlineAdView, @Nullable String viewId) {
    inlineAdView.setId(viewId);
  }

  @ReactProp(name="notVisible")
  public void setHiden(InlineAdView inlineAdView, @Nullable boolean notVisible) {
    if (notVisible) {
      inlineAdView.setVisibility(View.GONE);
    } else {
      inlineAdView.setVisibility(View.VISIBLE);
    }
  }

  protected class InlineAdView extends SASCollectorAd {
    Context context;
    String id = "";
    String spotId = "";
    ReactContext rnContext;

    public InlineAdView(Context context, AttributeSet attrs, int defStyle) {
      super(((ReactContext)context).getCurrentActivity(), attrs, defStyle);
    }

    public InlineAdView(Context context, AttributeSet attrs) {
      super(((ReactContext)context).getCurrentActivity(), attrs);
    }

    public InlineAdView(Context context) {
      super(((ReactContext)context).getCurrentActivity());
      this.context = context;
      setActionInBrowser(true);
      setDelegate(new AdDelegate() {
        @Override
        public void onLoaded(AbstractAd ad) {
          super.onLoaded(ad);
//          sendEvent2((ReactContext)context, Constants.AD_LOADED, Constants.TYPE_INLINE_AD);
          sendEvent((ReactContext)context, Constants.AD_LOADED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public void onDefaultLoaded(AbstractAd ad) {
          super.onDefaultLoaded(ad);
          sendEvent((ReactContext)context, Constants.AD_DEFAULT_LOADED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public void onLoadFailed(AbstractAd ad, int errorCode, String description, String failingUrl) {
          super.onLoadFailed(ad, errorCode, description, failingUrl);
          sendEvent((ReactContext)context, Constants.AD_LOAD_FAILED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public boolean willBeginAction(AbstractAd ad, String url) {
          sendEvent((ReactContext)context, Constants.AD_WILL_BEGIN_ACTION, Constants.TYPE_INLINE_AD);
          return super.willBeginAction(ad, url);
        }

        @Override
        public void onActionFinished(AbstractAd ad) {
          super.onActionFinished(ad);
          sendEvent((ReactContext)context, Constants.AD_ACTION_FINISHED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public boolean willResize(AbstractAd ad, Rect size) {
          sendEvent((ReactContext)context, Constants.AD_WILL_RESIZE, Constants.TYPE_INLINE_AD);
          return super.willResize(ad, size);
        }

        @Override
        public void onResizeFinished(AbstractAd ad) {
          super.onResizeFinished(ad);
          sendEvent((ReactContext)context, Constants.AD_RESIZE_FINISHED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public boolean willExpand(AbstractAd ad, String url) {
          sendEvent((ReactContext)context, Constants.AD_WILL_EXPAND, Constants.TYPE_INLINE_AD);
          return super.willExpand(ad, url);
        }

        @Override
        public void onExpandFinished(AbstractAd ad) {
          super.onExpandFinished(ad);
          sendEvent((ReactContext)context, Constants.AD_EXPAND_FINISHED, Constants.TYPE_INLINE_AD);
        }

        @Override
        public boolean willClose(AbstractAd ad) {
          return super.willClose(ad);
        }

        @Override
        public void onClosed(AbstractAd ad) {
          super.onClosed(ad);
          sendEvent((ReactContext)context, Constants.AD_CLOSED, Constants.TYPE_INLINE_AD);
        }
      });
//      setActionInBrowser(true);
    }

    public void setId(String id) {
      this.id = id;
    }
    public void setSpotId(String spotId) {
      this.spotId = spotId;
    }

    private void sendEvent(ReactContext ctx, String eventName, String type) {
      boolean isLoadOrDefaultLoad = false;
      WritableMap data = new WritableNativeMap();

      if (eventName.equals(Constants.AD_LOADED) || eventName.equals(Constants.AD_DEFAULT_LOADED)) {
        data.putString("eventType", type);
        data.putString("spotId", spotId != null ? spotId : "");
        data.putString("viewId", id != null ? id : "");
        isLoadOrDefaultLoad = true;
      }
      ctx.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, isLoadOrDefaultLoad ? data : eventName);
    }
  }

}
