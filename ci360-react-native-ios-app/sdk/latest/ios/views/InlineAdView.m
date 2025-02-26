#import "InlineAdView.h"
#import <React/RCTConvert.h>
#import <React/RCTAutoInsetsProtocol.h>

@interface InlineAdView() {
    NSString* _spotID;
    NSString* _viewID;
    BOOL _notVisible;
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

-(NSString*)viewId {
    return _viewID;
}

-(void)setViewId:(NSString *)viewId {
    _viewID = viewId;
}

-(BOOL)notVisible {
  return _notVisible;
}

-(void)setNotVisible:(BOOL)notVisible {
  _notVisible = notVisible;
  [self setHidden:_notVisible];
}

@end
