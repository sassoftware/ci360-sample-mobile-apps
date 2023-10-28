#import <UIKit/UIKit.h>
#import <SASCollector/SASCollector.h>
#import "InterstitialAdView.h"

@class InterstitialAdView;

@interface InterstitialAdViewController : UIViewController<SASIA_AdDelegate>

  -(void)setAdView:(InterstitialAdView *)adView;

@end
