#import "InterstitialAdViewController.h"
#import "AdDelegateEvent.h"
#import "Constants.h"

@implementation InterstitialAdViewController {
    InterstitialAdView *_interstitialAdView;

}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 0, 1, 1);
        self.view = view;
    }
    return self;
}

-(void)setAdView:(InterstitialAdView *)adView {
    _interstitialAdView = adView;
    _interstitialAdView.delegate = self;
}


- (void)didLoad:(SASIA_AbstractAd *)ad {
    [_interstitialAdView showFromController:self];
    [AdDelegateEvent emitAdLoadedEventWithType:TYPE_INTERSTITIAL_AD withSpotId:_interstitialAdView.spotId withViewId:_interstitialAdView.viewId];
}

- (void)didLoadDefault:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdDefaultLoadedEventWithType:TYPE_INTERSTITIAL_AD withSpotId:_interstitialAdView.spotId withViewId:_interstitialAdView.viewId];
}

- (void)didFailLoad:(SASIA_AbstractAd *)ad error:(NSError *)error failingUrl:(NSString *)failingUrl {
    [AdDelegateEvent emitAdLoadFailedEventWithType:TYPE_INTERSTITIAL_AD];
}

- (BOOL)willBeginAction:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [AdDelegateEvent emitAdWillBeginActionEventWithType:TYPE_INTERSTITIAL_AD];
    return true;
}

- (void)didFinishAction:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdActionFinishedEventWithType:TYPE_INTERSTITIAL_AD];
}

- (BOOL)willResize:(SASIA_AbstractAd *)ad size:(CGRect)size {
    [AdDelegateEvent emitAdWillResizeEventWithType:TYPE_INTERSTITIAL_AD];
    return true;
}

- (void)didFinishResize:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdResizeFinishedEventWithType:TYPE_INTERSTITIAL_AD];
}

- (BOOL)willExpand:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [AdDelegateEvent emitAdWillExpandEventWithType:TYPE_INTERSTITIAL_AD];
    return true;
}

- (void)didFinishExpand:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdExpandFinishedEventWithType:TYPE_INTERSTITIAL_AD];
}

- (BOOL)willClose:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdWillCloseEventWithType:TYPE_INTERSTITIAL_AD];
    return true;
}

- (void)didClose:(SASIA_AbstractAd *)ad {
    [AdDelegateEvent emitAdClosedEventWithType:TYPE_INTERSTITIAL_AD];
    [_interstitialAdView removeFromSuperview];
    [self removeFromParentViewController];
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
