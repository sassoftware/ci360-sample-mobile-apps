#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTLinkingManager.h>

#import <SASCollector/SASCollector.h>
#import <SASCollector/SASLogger.h>
#import <mobile-sdk-react-native/SASMobileMessagingEvent.h>

@implementation AppDelegate {
  RCTBridge *bridge;
  SASMobileMessagingEvent *msgEvent;
  NSMutableDictionary *savedPushInfo;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"MobileSdkReactNativeExample";
  // You can add your custom initial props in the dictionary below.
  // They will be passed down to the ViewController used by React Native.
  self.initialProps = @{};
  BOOL didFinishLaunchingWithOptions = [super application:application didFinishLaunchingWithOptions:launchOptions];
  
  [SASLogger setLevel:SASLoggerLevelAll];
  
  [SASCollector initializeCollection];
  if (@available(iOS 10.0, *)) {
      UNUserNotificationCenter.currentNotificationCenter.delegate = self;
      [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
          if(error != nil) {
            [SASLogger error:error.localizedDescription];
              return;
          }
          dispatch_async(dispatch_get_main_queue(), ^{
              [application registerForRemoteNotifications];
          });
      }];
  }
  
  [SASCollector setMobileMessagingDelegate2:self];

  NSDictionary *notificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  NSDictionary *linkData = [self getActionLinkFromMobileMessage:notificationInfo];

  return didFinishLaunchingWithOptions;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [SASCollector registerForMobileMessages:deviceToken completionHandler:^{
    [SASLogger info:@"Registering for remote \
      notifications is successful"];
  } failureHandler:^{
    [SASLogger info:@"Registering for remote \
      notifications failed"];
  }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
  [SASCollector handleMobileMessage:userInfo WithApplication:application];
  completionHandler(UIBackgroundFetchResultNoData);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
  [SASCollector handleMobileMessage:
   response.notification.request.content.userInfo WithApplication:UIApplication.sharedApplication];
  completionHandler();
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

-(NSDictionary*)getActionLinkFromMobileMessage:(NSDictionary *)notificationInfo {
  [SASLogger info:@"getActionLinkFromMobileMessage"];
  if (notificationInfo == nil) {
    return nil;
  }
  NSDictionary *aps = notificationInfo[@"aps"];
  NSDictionary *mobileMessageDictionary = aps[@"MobileMessage"];
  if (mobileMessageDictionary == nil) {
    return nil;
  }
  if (![mobileMessageDictionary[@"template"] isEqualToString:@"creative.pushNotification"]) {
    return nil;
  }
  NSArray *actions = mobileMessageDictionary[@"actions"];
  NSString *link = actions[0][@"link"];
  if (link == nil) {
    return nil;
  }
  return @{@"notificationWithLink": link};
}

#pragma mark SASMobileMessagingDelegate2
- (void)actionWithLink:(NSString * _Nonnull)link type:(SASMobileMessageType)type {
  NSMutableString* msgType = [NSMutableString stringWithString:@""];
  if (type == SASMobileMessageTypePushNotification) {
    msgType = [NSMutableString stringWithString:@"PushNotification"];
  } else if (type == SASMobileMessageTypeInAppMessage) {
    msgType = [NSMutableString stringWithString:@"InAppMsg"];
  }
  NSDictionary *args = @{@"type": msgType, @"link": link};

  [SASMobileMessagingEvent emitMessageOpenedWithPayload:args];

}

- (void)messageDismissed {
  [SASLogger info:@"User dismissed the notification message"];
  [SASMobileMessagingEvent emitMessageDismissed];

}

@end
