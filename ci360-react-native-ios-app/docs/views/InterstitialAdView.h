#import <React/RCTView.h>
#import <React/RCTDefines.h>
#import <SASCollector/SASCollector.h>
#import "InterstitialAdViewController.h"

@class InterstitialAdViewController;

@interface InterstitialAdView : SASCollectorInterstitialAd
  @property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *viewId;
  @property (nonatomic, strong) InterstitialAdViewController *hostingController;
@end
