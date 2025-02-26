#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

@interface AdDelegateEvent : RCTEventEmitter<RCTBridgeModule>

+(void)emitAdLoadedEventWithType:(NSString*)adType withSpotId:(NSString*)spotId withViewId:(NSString*)viewId;
+(void)emitAdDefaultLoadedEventWithType:(NSString*)adType withSpotId:(NSString*)spotId withViewId:(NSString*)viewId;
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
