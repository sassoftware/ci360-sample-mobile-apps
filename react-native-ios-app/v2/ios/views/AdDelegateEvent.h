#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

@interface AdDelegateEvent : RCTEventEmitter<RCTBridgeModule>

+(void)emitAdLoadedEventWithType:(NSString*)adType;
+(void)emitAdDefaultLoadedEventWithType:(NSString*)adType;
+(void)emitAdLoadFailedEventWithType:(NSString*)adType;
+(void)emitAdWillBeginActionEventWithType:(NSString*)adType;
+(void)emitAdActionFinishedEventWithType:(NSString*)adType;
+(void)emitAdWillResizeEventWithType:(NSString*)adType;
+(void)emitAdResizeFinishedEventWithType:(NSString*)adType;
+(void)emitAdWillExpandEventWithType:(NSString*)adType;
+(void)emitAdExpandFinishedEventWithType:(NSString*)adType;
+(void)emitAdWillCloseEventWithType:(NSString*)adType;
+(void)emitAdClosedEventWithType:(NSString*)adType;
@end
