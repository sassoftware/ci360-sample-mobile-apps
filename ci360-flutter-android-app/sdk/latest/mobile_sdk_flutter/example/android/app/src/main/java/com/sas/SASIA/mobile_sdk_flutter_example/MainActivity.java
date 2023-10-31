package com.sas.SASIA.mobile_sdk_flutter_example;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import com.google.firebase.messaging.FirebaseMessaging;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.iam.SASMobileMessagingDelegate2;
import com.sas.mkt.mobile.sdk.util.SLog;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    MethodChannel channel;
    String notificationLink;
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "app_channel");
    }


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FirebaseMessaging.getInstance().getToken().addOnSuccessListener(token -> {
            if(!TextUtils.isEmpty(token)) {
                SASCollector.getInstance().registerForMobileMessages(token);
            }
        });

        Intent intent = getIntent();
        notificationLink = intent.getStringExtra("notificationWithLink");
        
        SASCollector.getInstance().setMobileMessagingDelegate2(new SASMobileMessagingDelegate2() {
            @Override
            public void dismissed() {
                Log.d("MainActivity", "push notification is dismissed");
                channel.invokeMethod("msgDismissed", null);
            }

            @Override
            public void action(String s, SASMobileMessageType sasMobileMessageType) {
                if (sasMobileMessageType.equals(SASMobileMessageType.IN_APP_MESSAGE)) {
                   Map<String, String> args = new HashMap<>();
                   args.put("link", s);
                   args.put("type", "InAppMsg");

                    channel.invokeMethod("actionLinkClicked", args);
                }
                Log.d("MainActivity", "action called");
            }

            @Override
            public Intent getNotificationIntent(String s) {
                SLog.i("getNotificationIntent", s);
                Intent intent = new Intent(MainActivity.this, MainActivity.class);
                intent.putExtra("notificationWithLink", s);
                // intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
                return intent;
            }
        });

    }

    @Override
    public void onPostResume() {
        super.onPostResume();

        if (notificationLink != null) {
            Map<String, String> args = new HashMap<>();
            args.put("link", notificationLink);
            args.put("type", "PushNotification");
            channel.invokeMethod("actionLinkClicked", args);
            notificationLink = null;
        }
    }
}
