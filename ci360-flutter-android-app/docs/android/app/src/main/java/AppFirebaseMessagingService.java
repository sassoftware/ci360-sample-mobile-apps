//package com.sas.SASIA.mobile_sdk_flutter_example;
package com.ronald.my_first_flutter_app;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

public class AppFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "AppFirebaseMsgService";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        SLog.i(TAG, "From: " + remoteMessage.getFrom());
        SLog.i(TAG, "Data: " + remoteMessage.getData().toString());

        if (!SASCollector.getInstance().handleMobileMessage(remoteMessage.getData())) {
            //Handle non-SASCollector message
        }
    }

    @Override
    public void onNewToken(String token) {
        super.onNewToken(token);
        SLog.e("NEW_TOKEN",token);

        if (token != null) {
            SASCollector.getInstance().registerForMobileMessages(token);
        }
    }

    
}