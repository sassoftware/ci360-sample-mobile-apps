
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNMobileSdkReactNativeSpec.h"

@interface MobileSdkReactNative : NSObject <NativeMobileSdkReactNativeSpec>
#else
#import <React/RCTBridgeModule.h>
#import <SASCollector/SASCollector.h>
#import <Foundation/Foundation.h>

@interface MobileSdkReactNative : NSObject <RCTBridgeModule>
#endif

@end
