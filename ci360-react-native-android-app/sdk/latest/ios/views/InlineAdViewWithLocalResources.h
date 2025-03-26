//
//  InlineAdViewWithLocalResources.h
//  mobile-sdk-react-native
//
//  Created by Wei Wen on 3/8/24.
//

#import <SASCollector/SASCollector.h>


@interface InlineAdViewWithLocalResources : SASCollectorUIAdView

@property (nonatomic, copy) NSString *spotId;
@property (nonatomic, copy) NSString *viewId;
@property (nonatomic) BOOL notVisible;
@property (nonatomic) BOOL useLocResources;
@property (nonatomic, copy) NSString *resourcePath;

@end


