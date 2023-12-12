package com.sas.SASIA.mobile_sdk_flutter_example;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;

public class AppFirebaseMessagingService extends FirebaseMessagingService {
    private static final String TAG = "AppFirebaseMsgService";

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        SLog.i(TAG, "From: " + remoteMessage.getFrom());
        SLog.i(TAG, "Data: " + remoteMessage.getData().toString());

        if (!SASCollector.getInstance().handleMobileMessage(
            remoteMessage.getData())) {
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