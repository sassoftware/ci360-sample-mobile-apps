#import "AdDelegateEvent.h"
#import "Constants.h"

@implementation AdDelegateEvent

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
    return @[@"onAdLoaded", @"onAdDefaultLoaded", @"onAdLoadFailed",@"onAdWillBeginAction", @"onAdActionFinished", @"onAdWillResize", @"onAdResizeFinished", @"onAdWillExpand", @"onAdExpandFinished", @"onAdWillClose", @"onAdClosed"];
}

+(void)emitAdLoadedEventWithType:(NSString*)adType withSpotId:(NSString *)spotId withViewId:(NSString *)viewId{
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_LOADED object:nil userInfo:@{@"type": adType, @"spotId": spotId, @"viewId": viewId}];
}

+(void)emitAdDefaultLoadedEventWithType:(NSString*)adType withSpotId:(NSString *)spotId withViewId:(NSString *)viewId {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_DEFAULT_LOADED object:nil userInfo:@{@"type": adType, @"spotId": spotId, @"viewId": viewId}];
}

+(void)emitAdLoadFailedEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_LOAD_FAILED object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdWillBeginActionEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_WILL_BEGIN_ACTION object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdActionFinishedEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_ACTION_FINISHED object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdWillResizeEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_WILL_RESIZE object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdResizeFinishedEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_RESIZE_FINISHED object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdWillExpandEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_WILL_EXPAND object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdExpandFinishedEventWithType:(NSString*) adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_EXPAND_FINISHED object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdWillCloseEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_WILL_CLOSE object:nil userInfo:@{@"type": adType}];
}

+(void)emitAdClosedEventWithType:(NSString*)adType {
    [[NSNotificationCenter defaultCenter] postNotificationName:AD_CLOSED object:nil userInfo:@{@"type": adType}];
}

-(void)onAdLoaded:(NSNotification*)notification {
    [self composeAndSendEvent:notification withEventName:AD_LOADED];
}

-(void)onAdDefaultLoaded:(NSNotification*)notification {
    [self composeAndSendEvent:notification withEventName:AD_DEFAULT_LOADED];
}

-(void)onAdClosed:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_CLOSED body:type];
}

-(void)onAdLoadFailed:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_LOAD_FAILED body:type];
}

-(void)onAdWillBeginAction:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_WILL_BEGIN_ACTION body:type];
}

-(void)onAdActionFinished:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_ACTION_FINISHED body:type];
}

-(void)onAdWillResize:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_WILL_RESIZE body:type];
}

-(void)onAdResizeFinished:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_RESIZE_FINISHED body:type];
}

-(void)onAdWillExpand:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_WILL_EXPAND body:type];
}

-(void)onAdExpandFinished:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_EXPAND_FINISHED body:type];
}

-(void)onAdWillClose:(NSNotification*)notification {
    NSString *type = [notification.userInfo objectForKey:@"type"];
    [self sendEventWithName:AD_WILL_CLOSE body:type];
}

- (void)startObserving {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdLoaded:) name:AD_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdDefaultLoaded:) name:AD_DEFAULT_LOADED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdLoadFailed:) name:AD_LOAD_FAILED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdWillBeginAction:) name:AD_WILL_BEGIN_ACTION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdActionFinished:) name:AD_ACTION_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdWillResize:) name:AD_WILL_RESIZE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdResizeFinished:) name:AD_RESIZE_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdWillExpand:) name:AD_WILL_EXPAND object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdExpandFinished:) name:AD_EXPAND_FINISHED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdWillClose:) name:AD_WILL_CLOSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdClosed:) name:AD_CLOSED object:nil];
}

- (void)stopObserving {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)composeAndSendEvent:(NSNotification *)notification withEventName:(NSString*)eventName {
    NSString *type = [notification.userInfo objectForKey:@"type"]; // can be inline or interstitial
    NSString *spotId = [notification.userInfo objectForKey:@"spotId"];
    NSString *viewId = [notification.userInfo objectForKey:@"viewId"];
    if (!spotId)
        spotId = @"";

    if (!viewId)
        viewId = @"";

    if (![eventName isEqualToString:AD_DEFAULT_LOADED] && ![eventName isEqualToString:AD_LOADED]) {
        return;
    }
    [self sendEventWithName:eventName body:@{@"eventType": type, @"spotId": spotId, @"viewId": viewId}];
}

@end
