//
//  SasSpotDataHandler.m
//  mobile_sdk_flutter
//
//  Created by Wei Wen on 12/8/24.
//

#import "SasSpotDataHandler.h"

@implementation SasSpotDataHandler

-(instancetype)initWithFlutterResult:(FlutterResult)result cleanup:(void (^)(void))cleanup {
    self = [super init];
    if (self) {
        self.result = result;
        self.cleanup = cleanup;
    }
    return self;
}

- (void)dataForSpotId:(NSString * _Nonnull)spotId withContent:(NSString * _Nonnull)content { 
    dispatch_async(dispatch_get_main_queue(), ^{
        self.result(content);
        
        if(self.cleanup) {
            self.cleanup();
        }
    });
}

- (void)failureForSpotId:(NSString * _Nonnull)spotId withErrorCode:(long)errorCode andErrorMessage:(NSString * _Nonnull)errorMessage {
    NSString *message = [NSString stringWithFormat:@"Error: getting spot %@ failed with code %ld and message %@", spotId, errorCode, errorMessage];
    SLogDebug(message);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.result(message);
        if(self.cleanup) {
            self.cleanup();
        }
    });
}

- (void)noDataForSpotId:(NSString * _Nonnull)spotId { 
    NSString *message = [NSString stringWithFormat:@"No data: spot %@ has no data", spotId];
    SLogDebug(message);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.result(message);
        if(self.cleanup) {
            self.cleanup();
        }
    });
}

@end
