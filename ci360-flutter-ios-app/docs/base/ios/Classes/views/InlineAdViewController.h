#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <SASCollector/SASCollector.h>

@interface InlineAdViewController : UIViewController<FlutterPlatformView, SASIA_AdDelegate>
-(instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
    -(UIView* _Nonnull)view;

@end
