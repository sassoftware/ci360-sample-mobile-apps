//
//  SasSpotDataHandler.h
//  mobile_sdk_flutter
//
//  Created by Wei Wen on 12/8/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <SASCollector/SASCollector.h>


@interface SasSpotDataHandler : NSObject<SpotDataHandler>
@property (nonatomic, copy) FlutterResult result;
@property (nonatomic, copy) void (^cleanup)(void);

-(instancetype)initWithFlutterResult:(FlutterResult)result cleanup:(void (^)(void))cleanup;

@end

