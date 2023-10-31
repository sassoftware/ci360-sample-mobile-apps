package com.sas.SASIA.mobile_sdk_flutter.views;

import android.content.Context;
import android.graphics.Rect;
import android.view.View;
import androidx.annotation.NonNull;

import com.sas.ia.android.sdk.AbstractAd;
import com.sas.ia.android.sdk.AdDelegate;
import com.sas.ia.android.sdk.InterstitialAd;
import com.sas.mkt.mobile.sdk.ads.SASCollectorAd;
import com.sas.mkt.mobile.sdk.ads.SASCollectorInterstitialAd;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BaseAdView implements MethodChannel.MethodCallHandler{
    BinaryMessenger messenger;
    AbstractAd ad;
    String channelId;
    String spotID;
    private MethodChannel methodChannel;

    public BaseAdView(BinaryMessenger messenger, String channelId) {
        this.messenger = messenger;
        this.channelId = channelId;
        methodChannel = new MethodChannel(messenger, channelId);
        methodChannel.setMethodCallHandler(this);
    };

    public void setContents(AbstractAd ad, String spotID) {
        this.spotID = spotID;
        this.ad = ad;
        this.ad.setDelegate(new AdDelegate() {
            @Override
            public void onLoaded(AbstractAd ad) {
                super.onLoaded(ad);
                if (ad instanceof InterstitialAd) {
                    ((InterstitialAd) ad).show();
                }
                methodChannel.invokeMethod("adLoaded", null);
            }

            @Override
            public void onDefaultLoaded(AbstractAd ad) {
                super.onDefaultLoaded(ad);
                methodChannel.invokeMethod("adDefaultLoaded", null);
            }

            @Override
            public void onLoadFailed(AbstractAd ad, int errorCode, String description, String failingUrl) {
                super.onLoadFailed(ad, errorCode, description, failingUrl);
                methodChannel.invokeMethod("adLoadFailed", null);
            }

            @Override
            public boolean willBeginAction(AbstractAd ad, String url) {
                Map<String, Boolean> map = new HashMap<>();
                map.put("willBeginAction", true);
                methodChannel.invokeMethod("adWillBeginAction",map);
                return super.willBeginAction(ad, url);
            }

            @Override
            public void onActionFinished(AbstractAd ad) {
                super.onActionFinished(ad);
                methodChannel.invokeMethod("adActionFinished", null);
            }

            @Override
            public boolean willResize(AbstractAd ad, Rect size) {
                Map<String, Boolean> map = new HashMap<>();
                map.put("willResize", true);
                methodChannel.invokeMethod("adWillResize", true);
                return super.willResize(ad, size);
            }

            @Override
            public void onResizeFinished(AbstractAd ad) {
                super.onResizeFinished(ad);
                methodChannel.invokeMethod("adResizeFinished", null);
            }

            @Override
            public boolean willExpand(AbstractAd ad, String url) {
                Map<String, Boolean> map = new HashMap<>();
                map.put("willExpand", true);
                methodChannel.invokeMethod("adWillExpand", map);
                return super.willExpand(ad, url);
            }

            @Override
            public void onExpandFinished(AbstractAd ad) {
                super.onExpandFinished(ad);
                methodChannel.invokeMethod("adExpandFinished", null);
            }

            @Override
            public boolean willClose(AbstractAd ad) {
                Map<String, Boolean> map = new HashMap<>();
                map.put("willClose", true);
                methodChannel.invokeMethod("adWillClose", map);
                return super.willClose(ad);
            }

            @Override
            public void onClosed(AbstractAd ad) {
                super.onClosed(ad);
                methodChannel.invokeMethod("adClosed", null);
            }
        });
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            default:
            result.success(null);
        }
    }
}
