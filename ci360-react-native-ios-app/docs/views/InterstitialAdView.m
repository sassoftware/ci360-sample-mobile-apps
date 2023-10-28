#import "InterstitialAdView.h"

@interface InterstitialAdView() {
    NSString *_spotId;
}
@end


@implementation InterstitialAdView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    [[self viewController] prefersStatusBarHidden];
//    self.bounds = CGRectInset(self.frame, 0.0f, 10.0f);
//    self.layoutMargins = UIEdgeInsetsMake(10.0f, 0.0f, 0.0f, 0.0f);
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        [self addViewController];
    }

    return self;
}

-(NSString*)spotId {
    return _spotId;
}

-(void)setSpotId:(NSString *)spotID {
    _spotId = spotID;
    self.spotID = spotID;
     [self load];
}


-(void)addViewController {
    _hostingController = [InterstitialAdViewController new];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController addChildViewController:_hostingController];
//    [window.rootViewController prefersStatusBarHidden];
    [_hostingController didMoveToParentViewController:window.rootViewController];
    [_hostingController setAdView:self];
}

/*- (void)removeFromSuperview {
    if (_hostingController != nil) {
        [_hostingController willMoveToParentViewController:nil];
        [_hostingController removeFromParentViewController];
        _hostingController = nil;
        //[super removeFromSuperview];
    }
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    [window.rootViewController preferredStatusBarStyle];
}*/

@end
