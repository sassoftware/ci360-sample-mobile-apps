#import "InlineAdView.h"
#import <React/RCTConvert.h>
#import <React/RCTAutoInsetsProtocol.h>

@interface InlineAdView() {
    NSString* _spotID;
}
@end

@implementation InlineAdView

-(instancetype)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        super.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(NSString*)spotId {
    return _spotID;
}

-(void)setSpotId:(NSString *)spotID {
    _spotID = spotID;
    super.spotID = _spotID;
    [self load];
    
}

@end
