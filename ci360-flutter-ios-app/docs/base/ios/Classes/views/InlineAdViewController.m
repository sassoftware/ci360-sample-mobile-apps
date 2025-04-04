#import "InlineAdViewController.h"

@implementation InlineAdViewController {
    SASCollectorUIAdView *_view;
    NSMutableString *_spotID;
    NSDictionary* _args;
    FlutterMethodChannel* _methodChannel;
    BOOL _isLoaded;
}
-(UIColor*)lightGray {
    return [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
}

-(instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        _spotID = args[@"spotID"];
        [self viewDidLoad];
        
        _methodChannel = [FlutterMethodChannel methodChannelWithName:@"inline_ad_controller_channel" binaryMessenger:messenger];
        
        __weak __typeof__(self) weakSelf = self;
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _isLoaded = NO;
    }
    
    
    return self;
}

-(void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"updateSpotId"]) {
        _spotID = call.arguments[@"spotID"];
        _view.spotID = _spotID;
        [_view load];
    }
}

/* ad delegate methods */
-(void)didLoad:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adLoaded" arguments:nil];
}

-(void)didLoadDefault:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adDefaultLoaded" arguments:nil];
}

-(void)didFailLoad:(SASIA_AbstractAd *)ad error:(NSError *)error failingUrl:(NSString *)failingUrl {
    NSString* errStr = [NSString stringWithFormat:@"%@", error];
    NSDictionary* args = @{@"error": errStr, @"url": failingUrl};
    [_methodChannel invokeMethod:@"adLoadFailed" arguments:args];
}

-(BOOL)willBeginAction:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [_methodChannel invokeMethod:@"adWillBeginAction" arguments:@{@"willBeginAction": @YES}];
    return YES;
}

-(void)didFinishAction:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adActionFinished" arguments:nil];
}

-(BOOL)willResize:(SASIA_AbstractAd *)ad size:(CGRect)size {
    [_methodChannel invokeMethod:@"adWillResize" arguments:@{@"willResize": @YES}];
    return YES;
}

-(void)didFinishResize:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adResizeFinished" arguments:nil];
}

-(BOOL)willExpand:(SASIA_AbstractAd *)ad url:(NSString *)url {
    [_methodChannel invokeMethod:@"adWillExpand" arguments:@{@"url": url, @"willExpand": @YES}];
    return YES;
}

-(void)didFinishExpand:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adExpandFinished" arguments:nil];
}

-(BOOL)willClose:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adWillClose" arguments:@{@"willClose": @YES}];
    return YES;
}

-(void)didClose:(SASIA_AbstractAd *)ad {
    [_methodChannel invokeMethod:@"adClosed" arguments:nil];
}

/* end of ad delegate methods*/


-(void)viewDidLoad {
    [super viewDidLoad];
    _view = [SASCollectorUIAdView new];
    _view.backgroundColor = [self lightGray];
    _view.delegate = self;
    _view.spotID = _spotID;
    self.view = _view;
}

-(UIView* _Nonnull)view {
    if (!_isLoaded) {
        [_view load];
        _isLoaded = YES;
    } 
    return _view;
}

@end
