#import "MobileSdkFlutterPlugin.h"
#import <SASCollector/SASCollector.h>
#import "./views/InlineAdViewFactory.h"
#import "./views/InterstitialAdViewFactory.h"


@interface MobileSdkFlutterPlugin ()
  @property(nonatomic, retain) FlutterMethodChannel *channel;
@end

@implementation MobileSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  InlineAdViewFactory* factory = [[InlineAdViewFactory alloc] initWithMessager:registrar.messenger];
  [registrar registerViewFactory:factory withId:@"inlineAdView"];
  InterstitialAdViewFactory *interstitialFactory = [[InterstitialAdViewFactory alloc] initWithMessager:registrar.messenger];
  [registrar registerViewFactory:interstitialFactory withId:@"interstitialAdView"];
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"mobile_sdk_flutter"
            binaryMessenger:registrar.messenger];
  MobileSdkFlutterPlugin* instance = [[MobileSdkFlutterPlugin alloc] init];
  instance.channel = channel;
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([call.method isEqualToString:@"getPlatformVersion"]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } 
  else if ([call.method isEqualToString:@"newPage"]) {
    [SASCollector newPage:call.arguments[@"uri"]]; 
    result(nil);   
    }
  else if ([call.method isEqualToString:@"addAppEvent"]){
      NSString *eventKey = (NSString *)call.arguments[@"eventKey"];
      NSDictionary *data = call.arguments[@"data"];
      if (data != nil && ![data isKindOfClass:[NSNull class]]) {
        for(NSString* key in [data allKeys]) {
          [SASLogger info:[data objectForKey: key]];
        }
      }
      if ([data isKindOfClass:[NSNull class]]) {
          [SASCollector addAppEvent:eventKey data: nil];
      } else {
          [SASCollector addAppEvent:eventKey data: data];
      }      
      result(nil);
  } 
  else if ([call.method isEqualToString:@"identity"]) {
    NSString *value = call.arguments[@"value"];
    NSString *type = call.arguments[@"type"];
    NSLog(@"value: %@, type: %@", value, type);
    
    [SASCollector identity:value withType:type completion:^(BOOL success){
      if (success) {
        NSLog(@"identity check success");
      } else {
        NSLog(@"identity check failure");
      }
       dispatch_async(dispatch_get_main_queue(), ^{
            result([NSNumber numberWithBool:success]);
       });    
    }];   
  }
  else if ([call.method isEqualToString:@"detachIdentity"]) {
    [SASCollector detachIdentity:^(BOOL success){
      if (success) {
        NSLog(@"detachIdentity success");
      } else {
        NSLog(@"detachIdentity failure");
      }
      dispatch_async(dispatch_get_main_queue(), ^{
        result([NSNumber numberWithBool:success]);
      });
    }];    
  }
  else if ([call.method isEqualToString:@"registerForMobileMessages"]) {
      NSString* tokenString = call.arguments[@"token"];
      NSData* tokenData = [self hexStrToData:tokenString];
      [SASCollector registerForMobileMessages:tokenData completionHandler:^{
          SLogInfo(@"registerForMobileMessages  is successful.");
      } failureHandler:^{
          SLogError(@"registerForMobileMessages failed.");
      }];
  }
  else if ([call.method isEqualToString:@"handleMobileMessage"]) {
    NSDictionary* msgData = call.arguments[@"data"];
      BOOL success = [SASCollector handleMobileMessage:msgData WithApplication:UIApplication.sharedApplication];
    result([NSNumber numberWithBool:success]);
  }
  else if ([call.method isEqualToString:@"startMonitoringLocation"]) {
    [SASCollector startMonitoringLocation];
    result(nil);
  }
  else if ([call.method isEqualToString:@"disableLocationMonitoring"]) {
    [SASCollector disableLocationMonitoring];
    result(nil);
  }
  else if([call.method isEqualToString:@"getSessionBindingParameter"]) {
    result([SASCollector getSessionBindingParamter]);
  }
   else if([call.method isEqualToString:@"resetDeviceId"]) {
    [SASCollector resetDeviceId];
    result(nil);
  } 
  else if([call.method isEqualToString:@"getDeviceId"]) {
    result([SASCollector deviceId]);
  } 
  else if([call.method isEqualToString:@"getTenantId"]) {
    result([SASCollector tenantId]);
  } 
  else if([call.method isEqualToString:@"setTenantId"]) {
    NSString* tenantId = call.arguments[@"tenantId"];
    [SASCollector setTenantId:tenantId];
    result(nil);
  } 
  else if([call.method isEqualToString:@"getTagServer"]) {
    result([SASCollector tagServer]);
  } 
  else if([call.method isEqualToString:@"setTagServer"]) {
    NSString* tagServer = call.arguments[@"tagServer"];
    [SASCollector setTagServer:tagServer];
    result(nil);
  } 
  else if([call.method isEqualToString:@"getApplicationVersion"]) {
    result([SASCollector applicationVersion]);
  } 
  else if([call.method isEqualToString:@"setApplicationVersion"]) {
    NSString* newVersion = call.arguments[@"appVersion"];
    [SASCollector setApplicationVersion:newVersion];
    result(nil);
  }  
  else if([call.method isEqualToString:@"setTenant"]) {
      NSString *tenantId = call.arguments[@"tenantId"];
      NSString *tagServer = call.arguments[@"tagServer"];
      NSString *appId = call.arguments[@"appId"];
      [SASCollector setTenantId:tenantId];
      [SASCollector setTagServer:tagServer];
      [SASCollector setAppId:appId];
      [SASCollector initializeCollection];
      result([NSNumber numberWithBool:YES]);  
  } 
  else {
    result(FlutterMethodNotImplemented);
  }
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
