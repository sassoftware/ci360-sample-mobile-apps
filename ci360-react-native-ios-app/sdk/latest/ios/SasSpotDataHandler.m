#import "SasSpotDataHandler.h"

@implementation SasSpotDataHandler

-(instancetype)initWithContent:(RCTPromiseResolveBlock)contentPromise andError:(RCTPromiseRejectBlock)errorPromise {
  self = [super init];
  if (self) {
    self.contentPromise = contentPromise;
    self.errorPromise = errorPromise;
  }
  return self;
}

- (void)dataForSpotId:(NSString * _Nonnull)spotId withContent:(NSString * _Nonnull)content { 
  self.contentPromise(content);
}

- (void)failureForSpotId:(NSString * _Nonnull)spotId withErrorCode:(long)errorCode andErrorMessage:(NSString * _Nonnull)errorMessage {
  self.errorPromise(@"Error", errorMessage, nil);
}

- (void)noDataForSpotId:(NSString * _Nonnull)spotId { 
  self.errorPromise(@"Error", @"No Data", nil);
}

@end
