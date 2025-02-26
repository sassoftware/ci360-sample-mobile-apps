//
//  SASMobileMessagingEvent.h
//  MobileSdkReactNativeExample
//
//  Created by Wei Wen on 8/31/22.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface SASMobileMessagingEvent: RCTEventEmitter<RCTBridgeModule>
 +(void)emitMessageOpenedWithPayload:(NSDictionary *)payload;
 +(void)emitMessageDismissed;
 +(void)emitMessageDeviceToken:(NSDictionary *)payload;
@end
