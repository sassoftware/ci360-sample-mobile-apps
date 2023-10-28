#import <React/RCTView.h>
#import <React/RCTDefines.h>
#import <SASCollector/SASCollector.h>

@interface InlineAdView : SASCollectorUIAdView<SASIA_AdDelegate>

@property (nonatomic, copy) NSString *spotId;

@end
