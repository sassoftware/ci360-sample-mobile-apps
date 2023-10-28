#import <Flutter/Flutter.h>

@interface InlineAdViewFactory : NSObject<FlutterPlatformViewFactory>
-(instancetype)initWithMessager:(NSObject<FlutterBinaryMessenger>*)messenger;
@end