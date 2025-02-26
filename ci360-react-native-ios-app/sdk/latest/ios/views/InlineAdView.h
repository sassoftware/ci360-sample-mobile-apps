#import <React/RCTView.h>
#import <React/RCTDefines.h>
#import <SASCollector/SASCollector.h>

@interface InlineAdView : SASCollectorUIAdView

@property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *viewId;
@property (nonatomic) BOOL notVisible;
//@property (nonatomic) BOOL useLocalResources;
//@property (nonatomic, copy) NSURL *resourcePath;
@end

