#import <Flutter/Flutter.h>

@interface InterstitialAdViewFactory : NSObject<FlutterPlatformViewFactory>
-(instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger;
@end