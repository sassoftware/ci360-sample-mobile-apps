package com.sas.SASIA.mobile_sdk_flutter.views;

import android.content.Context;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

import com.sas.SASIA.mobile_sdk_flutter.Constants;
import com.sas.mkt.mobile.sdk.ads.SASCollectorInterstitialAd;
import java.util.Map;

public class InterstitialAdView extends BaseAdView implements PlatformView {
    SASCollectorInterstitialAd ad;
    Context context;

    public InterstitialAdView(BinaryMessenger messenger, @NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        super(messenger, Constants.Interstitial_Controller_Channel);
        this.context = context;
        ad = new SASCollectorInterstitialAd(this.context);
        String spotID = (String)creationParams.get(Constants.Spot_ID);
        setContents(ad, spotID);
    }

    @Nullable
    @Override
    public View getView() {
        ad = new SASCollectorInterstitialAd(this.context);
        return ad;
    }

    public void showAd() {
        ad = new SASCollectorInterstitialAd(this.context);
        setContents(ad, spotID);
        ad.load(spotID, null);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        super.onMethodCall(call, result);
        switch(call.method) {
            case "showAd":
                showAd();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    @Override
    public void dispose() {

    }
}

