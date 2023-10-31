package com.sas.SASIA.mobile_sdk_flutter.views;

import android.content.Context;
import android.graphics.Color;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

import com.sas.SASIA.mobile_sdk_flutter.Constants;
import com.sas.ia.android.sdk.AbstractAd;
import com.sas.mkt.mobile.sdk.ads.SASCollectorAd;

import java.util.Map;

public class InlineAdView extends BaseAdView implements PlatformView {
    SASCollectorAd ad;
    String spotID;

    public InlineAdView(BinaryMessenger messenger, @NonNull Context context, int id, @Nullable Map<String, Object> creationParams) {
        super(messenger, Constants.Inline_Ad_Controller_Channel);
        spotID = (String)creationParams.get(Constants.Spot_ID);
        ad = new SASCollectorAd(context);
        ad.setBackgroundColor(Color.LTGRAY);
        setContents(ad, spotID);
    }

    @Nullable
    @Override
    public View getView() {
        if (spotID != null) {
            ad.load(spotID, null);
        }

        return ad;
    }

    @Override
    public void dispose() {

    }
}

