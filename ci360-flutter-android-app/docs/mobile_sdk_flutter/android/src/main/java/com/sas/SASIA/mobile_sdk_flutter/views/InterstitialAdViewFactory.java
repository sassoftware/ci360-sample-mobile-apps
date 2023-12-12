package com.sas.SASIA.mobile_sdk_flutter.views;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class InterstitialAdViewFactory extends PlatformViewFactory {
    @NonNull private final BinaryMessenger messenger;

    public InterstitialAdViewFactory(@NonNull BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        Map<String, Object> creationParams = (Map<String, Object>)args;
        return new InterstitialAdView(messenger, context, viewId, creationParams);
    }
}
