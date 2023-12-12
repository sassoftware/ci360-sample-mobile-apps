//
//  SASMobileMessagingEvent.m
//  MobileSdkReactNativeExample
//
//  Created by Wei Wen on 8/31/22.
//

#import "SASMobileMessagingEvent.h"
#import "Constants.h"

@implementation SASMobileMessagingEvent

RCT_EXPORT_MODULE();


- (NSArray<NSString *> *)supportedEvents {
  return @[@"onMessageOpened", @"onMessageDismissed"];
}

-(void)onMessageOpened:(NSNotification*)notification {
    NSDictionary *args = notification.userInfo;
    [self sendEventWithName:MESSAGE_OPENED body:args];
}

-(void)onMessageDismissed {
 [self sendEventWithName:MESSAGE_DISMISSED body:nil];
}

- (void)startObserving {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageOpened:) name:MESSAGE_OPENED object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageDismissed) name:MESSAGE_DISMISSED object:nil];
}


- (void)stopObserving {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+(void)emitMessageOpenedWithPayload:(NSDictionary *)payload {
  [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_OPENED object:self userInfo:payload];
}
+(void)emitMessageDismissed {
  [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_DISMISSED object:self];
}

@end
