#import <RCTAppDelegate.h>
#import <React/RCTBridgeDelegate.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <React/RCTBridge.h>
#import <React/RCTEventDispatcher.h>
#import <SASCollector/SASCollector.h>

@interface AppDelegate : RCTAppDelegate <UIApplicationDelegate, UNUserNotificationCenterDelegate, RCTBridgeDelegate, SASMobileMessagingDelegate2>

@end
