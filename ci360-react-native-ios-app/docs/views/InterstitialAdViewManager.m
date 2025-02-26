#import <Foundation/Foundation.h>
#import <React/RCTUIManager.h>
#import "InterstitialAdView.h"
#import "InterstitialAdViewManager.h"
#import "InterstitialAdViewController.h"

@implementation InterstitialAdViewManager {
    InterstitialAdView *adView;
    InterstitialAdViewController *viewController;
}


RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(spotId, NSString)
RCT_EXPORT_VIEW_PROPERTY(viewId, NSString)

-(InterstitialAdView *)view {
    adView = [InterstitialAdView new];
    return adView;
}

@end
