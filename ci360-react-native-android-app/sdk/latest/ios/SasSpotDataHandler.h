//
//  SasSpotDataHandler.h
//  mobile-sdk-react-native
//
//  Created by Wei Wen on 1/15/25.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <SASCollector/SASCollector.h>

@interface SasSpotDataHandler : NSObject<SpotDataHandler>
@property (nonatomic, strong) RCTPromiseResolveBlock contentPromise;
@property (nonatomic, strong) RCTPromiseRejectBlock errorPromise;

-(instancetype)initWithContent:(RCTPromiseResolveBlock)contentPromise andError:(RCTPromiseRejectBlock)errorPromise;
@end

