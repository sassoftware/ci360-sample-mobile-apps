#import "MobileSdkReactNative.h"


@implementation MobileSdkReactNative
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(setAppVersionAndInitSDK:(NSString*)appVersion) {
    NSRegularExpression *regExpr = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+\\.[0-9]+\\.[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [regExpr rangeOfFirstMatchInString:appVersion options:NSMatchingProgress range:NSMakeRange(0, appVersion.length)];
    if (range.location != NSNotFound) {
        [SASCollector setApplicationVersion:appVersion];
    } else {
        [SASCollector setApplicationVersion:@"0.0.1"];
    }
    [SASCollector initializeCollection];
}

RCT_EXPORT_METHOD(newPage:(NSString*)uri) {
    [SASCollector newPage:uri];
}

RCT_EXPORT_METHOD(addAppEvent: (NSString*)eventKey data:(NSDictionary*)data){
    [SASCollector addAppEvent:eventKey data:data];
}

RCT_EXPORT_METHOD(identity:(NSString *)value type:(NSString *)type resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {
  [SASCollector identity:value withType:type withCompletion:^(BOOL success, NSString * _Nonnull message) {
      SLogInfo(@"Identity callback message: %@", message);

      dispatch_async(dispatch_get_main_queue(), ^{
          if (success) {
              resolve([NSNumber numberWithBool:success]);
          } else {
              reject(@"Error", @"Identity failure", nil);
          }
      });
  }];
}

RCT_EXPORT_METHOD(detachIdentity:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject ) {
    [SASCollector detachIdentity:^(BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
              resolve([NSNumber numberWithBool:success]);
            } else {
              reject(@"Error", @"Identity detachh failure", [NSError new]);
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

RCT_EXPORT_METHOD(getApplicationVersion:(RCTResponseSenderBlock)callback) {
    NSString* appVersion = [SASCollector applicationVersion];
    callback(@[appVersion]);
}

RCT_EXPORT_METHOD(setApplicationVersion:(NSString*)version) {
    NSRegularExpression *regExpr = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+\\.[0-9]+\\.[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSRange range = [regExpr rangeOfFirstMatchInString:version options:NSMatchingProgress range:NSMakeRange(0, version.length)];
    if (range.location != NSNotFound) {
        [SASCollector setApplicationVersion:version];
    }
}

// ... (existing imports and code remain unchanged)

RCT_EXPORT_METHOD(setTenantId:(NSString *)tenantId)
{
  [SASCollector setTenantId:tenantId];
}

RCT_EXPORT_METHOD(setTagServer:(NSString *)tagServer)
{
  [SASCollector setTagServer:tagServer];
}

RCT_EXPORT_METHOD(setAppId:(NSString *)appId)
{
  [SASCollector setAppId:appId];
}

RCT_EXPORT_METHOD(initializeCollection)
{
  [SASCollector initializeCollection];
}

RCT_EXPORT_METHOD(shutdown)
{
  [SASCollector shutdown];
}

RCT_EXPORT_METHOD(getSessionId:(RCTResponseSenderBlock)callback) {
  NSString *sessionId = [SASCollector getSessionBindingParamter];
  if (sessionId == nil) {
    sessionId = @""; // Or handle the nil case as needed
  }
  callback(@[sessionId]);
}
// ... (rest of the existing exports remain unchanged)

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

RCT_EXPORT_METHOD(handleMobileMessage:(NSDictionary*)data callback:(RCTResponseSenderBlock)callback) {
    BOOL success = [SASCollector handleMobileMessage:data WithApplication:UIApplication.sharedApplication];
    callback(@[[NSNumber numberWithBool:success]]);
}


RCT_EXPORT_METHOD(loadSpotData:(NSString *)spotId attributes:(NSDictionary * _Nullable)attributes resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject) {

  SasSpotDataHandler *spotDataHandler = [[SasSpotDataHandler alloc] initWithContent:resolve andError:reject];
    if (!attributes || [attributes count] == 0) {
      [SASCollector loadSpotData:spotId withCompletionHandler:spotDataHandler];
    } else {
      [SASCollector loadSpotData:spotId withAttributes:attributes withCompletionHandler:spotDataHandler];
    }
}

RCT_EXPORT_METHOD(registerSpotViewable:(NSString *)spotId) {
  [SASCollector registerSpotViewableWith:spotId];
}

RCT_EXPORT_METHOD(registerSpotClicked:(NSString *)spotId) {
  [SASCollector registerSpotClickWith:spotId];
}

- (NSNumber *)multiply:(double)a b:(double)b {
  return [NSNumber numberWithDouble:(a * b)];
}


//RCT_EXPORT_METHOD(loadSpotData:(NSString*)spotId attributes:(NSDictionary*)attributes spotContent:(RCTPromiseResolveBlock)contentPromise errorContent:(RCTPromiseRejectBlock)errorPromise) {
////  [SASCollector identity:value withType:type withCompletion:^(BOOL success, NSString * _Nonnull message) {}];
//  SasSpotDataHandler *spotDataHandler = [SasSpotDataHandler new];
//  if (!attributes || [attributes count] == 0) {
//    [SASCollector loadSpotData:spotId withCompletionHandler:spotDataHandler];
//  } else {
//    [SASCollector loadSpotData:spotId withAttributes:attributes withCompletionHandler:spotDataHandler];
//  }
//}

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

// Don't compile this code when we build for the old architecture.
//#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeMobileSdkReactNativeSpecJSI>(params);
}
//#endif

@end
