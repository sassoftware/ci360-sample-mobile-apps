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
  return @[@"onMessageOpened", @"onMessageDismissed", @"onRegisterDeviceToken"];
}

-(void)onMessageOpened:(NSNotification*)notification {
    NSDictionary *args = notification.userInfo;
    [self sendEventWithName:MESSAGE_OPENED body:args];
}

-(void)onMessageDismissed {
 [self sendEventWithName:MESSAGE_DISMISSED body:nil];
}

-(void)onRegisterDeviceToken:(NSNotification*)notification {
    NSDictionary *args = notification.userInfo;
    NSData *token = args[@"deviceToken"];
    NSString *tokenStr = [SASMobileMessagingEvent dataToHexStr:token];
    NSDictionary *tokenInfo = @{@"deviceToken": tokenStr};
    [self sendEventWithName:REGISTER_DEVICE_TOKEN body:tokenInfo];
}

- (void)startObserving {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageOpened:) name:MESSAGE_OPENED object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageDismissed) name:MESSAGE_DISMISSED object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRegisterDeviceToken:) name:REGISTER_DEVICE_TOKEN object:nil];
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
+(void)emitMessageDeviceToken:(NSDictionary *)payload {
    [[NSNotificationCenter defaultCenter] postNotificationName:REGISTER_DEVICE_TOKEN object:self  userInfo:payload];
}

+(NSString*)dataToHexStr:(NSData*)data {
    NSMutableString *str = [NSMutableString stringWithCapacity:64];
    NSUInteger length = [data length];
    char *bytes = malloc(sizeof(char)*length);
    [data getBytes:bytes length:length];
    for(int i=0; i<length; i++) {
        [str appendFormat:@"%02.2hhX", bytes[i]];
    }
    free(bytes);
    return str;
}

@end
