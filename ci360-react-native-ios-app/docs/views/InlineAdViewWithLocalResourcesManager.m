//
//  InlineAdViewManagerLocalResources.m
//  mobile-sdk-react-native
//
//  Created by Wei Wen on 3/8/24.
//
#import <Foundation/Foundation.h>
#import <React/RCTUIManager.h>
#import "InlineAdViewWithLocalResourcesManager.h"
#import "InlineAdViewWithLocalResources.h"
#import "AdDelegateEvent.h"
#import "Constants.h"

@implementation InlineAdViewWithLocalResourcesManager

RCT_EXPORT_MODULE()

-(InlineAdViewWithLocalResources *)view {
    InlineAdViewWithLocalResources *adView = [InlineAdViewWithLocalResources new];
    adView.delegate = self;
    return adView;
}

RCT_EXPORT_VIEW_PROPERTY(spotId, NSString)
RCT_EXPORT_VIEW_PROPERTY(useLocResources, BOOL)
RCT_EXPORT_VIEW_PROPERTY(resourcePath, NSString)
RCT_EXPORT_VIEW_PROPERTY(viewId, NSString)
RCT_EXPORT_VIEW_PROPERTY(notVisible, BOOL)

/* SASIA_AdDelegate delegate methods */
- (void)didLoad:(SASIA_AbstractAd *)ad {
    InlineAdViewWithLocalResources *adView = (InlineAdViewWithLocalResources*)ad;
    [AdDelegateEvent emitAdLoadedEventWithType:TYPE_INLINE_AD withSpotId:adView.spotId withViewId:adView.viewId];
}

- (void)didLoadDefault:(SASIA_AbstractAd *)ad {
    InlineAdViewWithLocalResources *adView = (InlineAdViewWithLocalResources*)ad;
    [AdDelegateEvent emitAdDefaultLoadedEventWithType:TYPE_INLINE_AD withSpotId:adView.spotId withViewId:adView.viewId];
}

- (void)didFailLoad:(SASIA_AbstractAd *)ad error:(NSError *)error failingUrl:(NSString *)failingUrl {
    [AdDelegateEvent emitAdLoadFailedEventWithType:TYPE_INLINE_AD];
}

- (BOOL)willBeginAction:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [AdDelegateEvent emitAdWillBeginActionEventWithType:TYPE_INLINE_AD];
    return true;
}

- (void)didFinishAction:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdActionFinishedEventWithType:TYPE_INLINE_AD];
}

- (BOOL)willResize:(SASIA_AbstractAd *)ad size:(CGRect)size {
    [AdDelegateEvent emitAdWillResizeEventWithType:TYPE_INLINE_AD];
    return true;
}

- (void)didFinishResize:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdResizeFinishedEventWithType:TYPE_INLINE_AD];
}

- (BOOL)willExpand:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [AdDelegateEvent emitAdWillExpandEventWithType:TYPE_INLINE_AD];
    return true;
}

- (void)didFinishExpand:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdResizeFinishedEventWithType:TYPE_INLINE_AD];
}

- (BOOL)willClose:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdWillCloseEventWithType:TYPE_INLINE_AD];
    return true;
}

- (void)didClose:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdClosedEventWithType:TYPE_INLINE_AD];
}
@end
