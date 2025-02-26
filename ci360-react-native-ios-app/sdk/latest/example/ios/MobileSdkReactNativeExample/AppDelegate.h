//#import <React/RCTBridgeDelegate.h>
#import <RCTAppDelegate.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <SASCollector/SASCollector.h>


@interface AppDelegate : RCTAppDelegate<UIApplicationDelegate, UNUserNotificationCenterDelegate, RCTBridgeDelegate, SASMobileMessagingDelegate2> 

@end
