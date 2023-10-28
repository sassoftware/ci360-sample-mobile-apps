#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <SASCollector/SASCollector.h>

@interface BaseAdViewController : UIViewController<SASIA_AdDelegate>
-(instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger channelId:(NSString*)channelId ad:(SASIA_AbstractAd*)ad spotId:(NSString*)spotID;
@end
