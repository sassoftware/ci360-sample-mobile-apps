package com.mobilesdkreactnativeexample;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;
import android.util.Log;

public class RNFirebaseMessagingService extends FirebaseMessagingService {
  private static final String TAG = "RNFBMessageService";

  @Override
  public void onMessageReceived(RemoteMessage remoteMessage) {

    SLog.i(TAG, "From: " + remoteMessage.getFrom());
    SLog.i(TAG, "Data: " + remoteMessage.getData().toString());
    SASCollector.getInstance().handleMobileMessage(remoteMessage.getData());
  }

  @Override
  public void onNewToken(String token) {
    super.onNewToken(token);

    SLog.e("NEW_TOKEN", token);

    if (token != null) {
      SASCollector.getInstance().registerForMobileMessages(token);
    }
  }
}
