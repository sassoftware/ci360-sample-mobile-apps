//package com.sas.SASIA.mobile_sdk_flutter_example;
package com.ronald.my_first_flutter_app;

import android.app.Application;
import android.os.Build;
import androidx.annotation.RequiresApi;
import com.sas.mkt.mobile.sdk.util.SLog;
import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

public class FlutterApplication extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        SLog.setLevel(SLog.ALL);
        SASCollector.getInstance().initialize(this);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            setPushChannel();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void setPushChannel() {
        NotificationManager notificationManager =
                (NotificationManager) this.getSystemService(NOTIFICATION_SERVICE);

        String customAndroidChannel = "FlutterPushChannel";
        CharSequence channelName = "Flutter Channel";
        int importance = NotificationManager.IMPORTANCE_HIGH;
        NotificationChannel notificationChannel = new NotificationChannel(customAndroidChannel, channelName, importance);
        notificationChannel.enableLights(true);
        notificationChannel.setLightColor(Color.RED);
        notificationChannel.enableVibration(true);
        notificationChannel.setShowBadge(true);
        notificationChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
        notificationManager.createNotificationChannel(notificationChannel);

        SASCollector.getInstance().setPushNotificationChannelId(customAndroidChannel);
    }
}
