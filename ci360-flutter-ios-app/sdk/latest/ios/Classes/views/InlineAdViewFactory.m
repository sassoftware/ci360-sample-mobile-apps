#import "InlineAdViewFactory.h"
#import "InlineAdViewController.h"

@implementation InlineAdViewFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}

-(instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

-(NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args {
    return [[InlineAdViewController alloc] initWithFrame:frame viewIdentifier:viewId arguments:args binaryMessenger:_messenger];
}

-(NSObject<FlutterMessageCodec> *)createArgsCodec {
    return FlutterStandardMessageCodec.sharedInstance;
}

@end
