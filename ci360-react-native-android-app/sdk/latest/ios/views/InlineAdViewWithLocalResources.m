//
//  InlineAdViewWithLocalResources.m
//  mobile-sdk-react-native
//
//  Created by Wei Wen on 3/8/24.
//

#import "InlineAdViewWithLocalResources.h"

@interface InlineAdViewWithLocalResources() {
    NSString* _spotID;
    NSString* _viewID;
    BOOL _notVisible;
    BOOL _useLocResources;
    NSString *_resourcePath;
    BOOL isSpotIdSet;
    BOOL isUseLocResourcesSet;
    BOOL isViewLoaded;
}
@end

@implementation InlineAdViewWithLocalResources

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
    isViewLoaded = NO;
    super.spotID = _spotID;
    isSpotIdSet = YES;
    if (isSpotIdSet && isUseLocResourcesSet && !isViewLoaded) {
        [self setLocResourcesAndLoad];
        isViewLoaded = YES;
    }
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

-(BOOL)useLocResources {
    return _useLocResources;
}

-(void)setUseLocResources:(BOOL)useLocalResources {
    _useLocResources = useLocalResources;
    isViewLoaded = NO;
    isUseLocResourcesSet = YES;
    if (isSpotIdSet && isUseLocResourcesSet && !isViewLoaded) {
        [self setLocResourcesAndLoad];
        isViewLoaded = YES;
    }
}

-(NSString*)resourcePath {
    return _resourcePath;
}

-(void)setResourcePath:(NSString *)path {
    _resourcePath = path;
}

-(void)setLocResourcesAndLoad {
    [self useLocalResources:_useLocResources];
    [self load];
}

@end
