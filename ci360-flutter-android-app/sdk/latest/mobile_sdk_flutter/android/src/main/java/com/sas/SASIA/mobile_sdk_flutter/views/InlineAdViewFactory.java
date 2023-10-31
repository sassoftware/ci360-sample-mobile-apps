package com.sas.SASIA.mobile_sdk_flutter.views;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

import java.util.Map;

public class InlineAdViewFactory extends PlatformViewFactory {
    @NonNull private final BinaryMessenger messenger;

    public InlineAdViewFactory(@NonNull BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        Map<String, Object> creationParams = (Map<String, Object>)args;

        return new InlineAdView(messenger, context, viewId, creationParams);
    }
}
