#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <SASCollector/SASCollector.h>
#import <SASCollector/SASLogger.h>

@implementation AppDelegate {
   FlutterMethodChannel *methodChannel;
   NSString *actionLink;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [SASLogger setLevel:SASLoggerLevelAll];

    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    methodChannel = [FlutterMethodChannel methodChannelWithName:@"app_channel" binaryMessenger:[controller binaryMessenger]];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter.currentNotificationCenter.delegate = self;
        [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [application registerForRemoteNotifications];
            });
        }];

    }
    [SASCollector setMobileMessagingDelegate2:self];
    
    [SASLogger info:@"didFinishLaunchingWithOptions"];
    
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {

    [SASCollector registerForMobileMessages:deviceToken completionHandler:^{
        [SASLogger info:@"Registration is successful"];

    } failureHandler:^{
        [SASLogger error:@"Registration failed"];
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSString* userInfoDesc = @"";
    if (userInfo != nil) {
        userInfoDesc = userInfo.description;
    }
    NSString* userInfoStr = [NSString stringWithFormat:@"didReceiveRemoteNotification, UserInfo: %@", userInfoDesc];
    [SASLogger info:userInfoStr];
    if (![SASCollector handleMobileMessage:userInfo WithApplication:application]) {
        //Handle non-SASCollector message
        NSLog(@"Remote Notification was not handled by SASCollector");
    }
}

// The following commented code is for newer iOS (10 and above).
// Uncomment and use it when the previous one:
// (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
// becomes obsolete.
/*- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString* userInfoDesc = @"";
    if (userInfo != nil) {
        userInfoDesc = userInfo.description;
    }
    NSString* userInfoStr = [NSString stringWithFormat:@"didReceiveRemoteNotification, UserInfo: %@", userInfoDesc];
    [SASLogger info:userInfoStr];
    if ([SASCollector handleMobileMessage:userInfo WithApplication:application]) {
        //Handle non-SASCollector message
        NSLog(@"Remote Notification was not handled by SASCollector");
    }
    completionHandler(UIBackgroundFetchResultNoData);
} */


- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString* userInfoStr = response.notification.request.content.userInfo.description;
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [SASLogger info:@"didReceiveNotificationResponse"];
    [SASLogger info: userInfoStr];
    
    if (![SASCollector handleMobileMessage:response.notification.request.content.userInfo WithApplication:UIApplication.sharedApplication]) {
        //Handle non-SASCollector message
        NSLog(@"Remote Notification was not handled by SASCollector");
    };
    completionHandler();
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//SASMobileMessagingDelegate2 delegate methods
-(void)messageDismissed {
   NSLog(@"message is dismissed");
   [self handleUserDismissMsg];
}

-(void)actionWithLink:(NSString *)link type:(SASMobileMessageType)type {
   NSLog(@"link: %@, type: %@", link, type == SASMobileMessageTypePushNotification ? @"push notification" : @"in-app message");

   [SASLogger info: @"actionWithLink called"];
   if (type == SASMobileMessageTypeInAppMessage) {
       NSDictionary *args = @{@"link": link, @"type": @"InAppMsg"};
       [methodChannel invokeMethod:@"actionLinkClicked" arguments:args];
   } else if (type == SASMobileMessageTypePushNotification) {
       actionLink = link;
   }
}


// methods that calls methods on the dart side
-(void)handleUserDismissMsg {
    [methodChannel invokeMethod:@"msgDismissed" arguments:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (actionLink != nil) {
        NSString *msg = [NSString stringWithFormat:@"applicationDidBecomeActive, link: %@", actionLink];
        [SASLogger info:msg];
        NSDictionary *args = @{@"link": actionLink, @"type": @"PushNotification"};
        [methodChannel invokeMethod:@"actionLinkClicked" arguments:args];
        actionLink = nil;
    }
    
}
@end
