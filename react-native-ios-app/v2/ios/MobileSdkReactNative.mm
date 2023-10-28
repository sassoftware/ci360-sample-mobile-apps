#import "MobileSdkReactNative.h"

@implementation MobileSdkReactNative
RCT_EXPORT_MODULE()

// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_EXPORT_METHOD(multiply:(double)a
                  b:(double)b
                  resolve:(RCTPromiseResolveBlock)resolve
                  reject:(RCTPromiseRejectBlock)reject)
{
    NSNumber *result = @(a * b);

    resolve(result);
}

RCT_EXPORT_METHOD(newPage:(NSString*)uri) {
    [SASCollector newPage:uri];
}

RCT_EXPORT_METHOD(getSessionID:(RCTResponseSenderBlock)callback)
{
    NSString* sessionParamter = [SASCollector getSessionBindingParamter];
    NSString* sessionID = [[sessionParamter componentsSeparatedByString:@"="][1] componentsSeparatedByString:@"*"][0];
    callback(@[sessionID]);
}

RCT_EXPORT_METHOD(getSdkVersion:(RCTResponseSenderBlock)callback) {
    NSString* sdkVersion = [SASCollector sdkVersion];
    callback(@[sdkVersion]);
}

RCT_EXPORT_METHOD(addAppEvent: (NSString*)eventKey data:(NSDictionary*)data){
    [SASCollector addAppEvent:eventKey data:data];
}

RCT_EXPORT_METHOD(identity:(NSString*)value withType:(NSString*)type isSuccess:(RCTPromiseResolveBlock)successPromise isFailure:(RCTPromiseRejectBlock)failurePromise) {
    [SASCollector identity:value withType:type completion:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                successPromise([NSNumber numberWithBool:success]);
            } else {
                failurePromise(@"Error", @"Identity failure", nil);
            }
        });

    }];
}

RCT_EXPORT_METHOD(detachIdentity:(RCTPromiseResolveBlock)successPromise isFailure:(RCTPromiseRejectBlock)failurePromise) {
    [SASCollector detachIdentity:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                successPromise([NSNumber numberWithBool:success]);
            } else {
                failurePromise(@"Error", @"Identity detachh failure", [NSError new]);
            }
        });

    }];
}

RCT_EXPORT_METHOD(startMonitoringLocation) {
    [SASCollector startMonitoringLocation];
}

RCT_EXPORT_METHOD(disableLocationMonitoring) {
    [SASCollector disableLocationMonitoring];
}

RCT_EXPORT_METHOD(resetDeviceID) {
    [SASCollector resetDeviceId];
}

RCT_EXPORT_METHOD(getDeviceID:(RCTResponseSenderBlock)callback) {
    NSString* deviceID = [SASCollector deviceId];
    callback(@[deviceID]);
}

RCT_EXPORT_METHOD(getTenantID:(RCTResponseSenderBlock)callback) {
    NSString* tenantID = [SASCollector tenantId];
    callback(@[tenantID]);
}

RCT_EXPORT_METHOD(getTagServer:(RCTResponseSenderBlock)callback) {
    NSString* tagServer = [SASCollector tagServer];
    callback(@[tagServer]);
}

RCT_EXPORT_METHOD(getAppVersion:(RCTResponseSenderBlock)callback) {
    NSString* appVersion = [SASCollector applicationVersion];
    callback(@[appVersion]);
}

RCT_EXPORT_METHOD(registerForMobileMessage:(NSString*)token) {
    if (token != nil) {
        NSData* tokenData = [self hexStrToData:token];
        [SASCollector registerForMobileMessages:tokenData completionHandler:^{
            SLogInfo(@"registerForMobileMessages  is successful.");
        } failureHandler:^{
            SLogError(@"registerForMobileMessages failed.");
        }];
    }
}

RCT_EXPORT_METHOD(handleMobileMessage:(NSDictionary*)data isSuccess:(RCTResponseSenderBlock)callback) {
    BOOL success = [SASCollector handleMobileMessage:data WithApplication:UIApplication.sharedApplication];
    callback(@[[NSNumber numberWithBool:success]]);
}

-(NSData*)hexStrToData:(NSString*)hexStr {
    NSString *cleanedHex = [hexStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *data = [[NSMutableData alloc] init];
    unsigned char wholeByte;
    char byteChars[3] = {'\0', '\0', '\0'};
    int i;
    for(i=0; i<[cleanedHex length] / 2; i++) {
        byteChars[0] = [cleanedHex characterAtIndex:i*2];
        byteChars[1] = [cleanedHex characterAtIndex:i*2+1];
        wholeByte = strtol(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}
@end
