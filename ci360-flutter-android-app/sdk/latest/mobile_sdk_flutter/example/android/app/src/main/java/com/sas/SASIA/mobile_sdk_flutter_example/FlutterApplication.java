package com.sas.SASIA.mobile_sdk_flutter_example;

import android.app.Application;
import com.sas.mkt.mobile.sdk.util.SLog;

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
