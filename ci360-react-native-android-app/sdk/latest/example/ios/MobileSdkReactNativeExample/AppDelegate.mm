#import "AppDelegate.h"
#import <React/RCTBundleURLProvider.h>
#import <SASCollector/SASCollector.h>
#import <SASCollector/SASLogger.h>
#import <mobile-sdk-react-native/SASMobileMessagingEvent.h>

@implementation AppDelegate {
  SASMobileMessagingEvent *msgEvent;
  NSMutableDictionary *savedPushInfo;
  NSData *deviceTokenForNotification;
  BOOL hasRegisteredDeviceToken;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.moduleName = @"MobileSdkReactNativeExample";
  
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
  
  NSDictionary *notificationInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
  NSDictionary *initialProps = [self getActionLinkFromMobileMessage:notificationInfo];
  
  if (initialProps != nil) {
    // Get the bridge and root view
    NSURL *jsCodeLocation = [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
    RCTRootView *rootView = [[RCTRootView alloc] initWithBundleURL:jsCodeLocation moduleName:self.moduleName initialProperties:initialProps launchOptions:launchOptions];
    rootView.backgroundColor =[UIColor whiteColor];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *rootViewController = [UIViewController new];
    rootViewController.view = rootView;
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
  }
  
  [SASLogger setLevel:SASLoggerLevelAll];
  [SASCollector setMobileMessagingDelegate2:self];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


- (void)applicationWillResignActive:(UIApplication *)application {
  if (!hasRegisteredDeviceToken) {
    NSDictionary *args = @{@"deviceToken": deviceTokenForNotification};
    [SASMobileMessagingEvent emitMessageDeviceToken:args];
    hasRegisteredDeviceToken = YES;
  }

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    hasRegisteredDeviceToken = NO;
    deviceTokenForNotification = deviceToken;

  //This should be used if NOT setting developerInitialized to true in SASCollector.plist
//  [SASCollector registerForMobileMessages:deviceToken completionHandler:^{
//    [SASLogger info:@"Registering for remote \
//      notifications is successful"];
//  } failureHandler:^{
//    [SASLogger info:@"Registering for remote \
//      notifications failed"];
//  }];
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
  return [self bundleURL];
}

- (NSURL *)bundleURL
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

-(NSDictionary*)getActionLinkFromMobileMessage:(NSDictionary *)notificationInfo {
  if (notificationInfo == nil) {
    return nil;
  }
  NSDictionary *aps = notificationInfo[@"aps"];
  if (aps == nil) {
    return nil;
  }
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
