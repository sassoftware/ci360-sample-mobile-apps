# Working with the react-native iOS Mobile SDK

Welcome to the React-Native SDK guide for our platform! This document is designed to provide you with a comprehensive understanding of how to effectively utilize our React-Native SDK. We will walk you through usage examples and provide a comparison with the native SDK to enhance your understanding.

## Design Abstract
In our project, we've leveraged the power of React Native SDK for iOS and Android to provide a flexible and efficient development experience. Here's an overview of how it works compared to the native SDK:

 - **Key Functions with Native SDK:** 
While we embrace the benefits of React Native, it's important to note that the core functionality of our application still relies on the native SDKs for iOS and Android. These native SDKs provide the foundation for critical operations.

 - **Bridging with React Native:** 
React Native SDK serves as a bridge between our JavaScript code and the native modules. It facilitates seamless communication between the TypeScript world and the underlying native code. This bridging is essential for integrating native capabilities into our React Native app.

 - **TypeScript Functions:**
Our application makes extensive use of TypeScript functions, which provide a statically-typed and more maintainable codebase. These TypeScript functions are called from within our React Native components to interact with both the React Native SDK and the underlying native SDKs.

This combination of native SDKs and React Native SDK, along with TypeScript, enables us to build a cross-platform mobile application that leverages the strengths of both worlds while maintaining a high level of performance and extensibility.

## Installation

Before proceeding, ensure that you have successfully installed the React-Native SDK [installation guide](./sdk/latest/). If you haven't completed this step yet, please refer to the installation guide for step-by-step instructions on setting up the SDK.


## Table of Contents
<a name="back-to-top"></a>
1. [Framework Versions](#framework-versions)
2. [Functionality Comparisons](#functionality-comparisons)
    - [Example: Enable SDK Internal Logging](#expand-enable-sdk-internal-logging)
    - [Example: Return the Mobile SDK Version](#expand-return-the-mobile-sdk-version)
    - [Example: Retrieving the Session ID](#expand-return-session-id)
    - [Example: Retrieving the Device ID](#expand-return-device-id)
    - [Example: Bind a Device ID to and Identity](#expand-bind-a-device-id-to-and-identity)
    - [Example: Detach Identitiy from Device](#expand-detach-identitiy-from-device)
    - [Example: Track User Navigation in the App](#expand-track-user-navigation-in-the-app)
    - [Example: Working with Events](#expand-working-with-events)
    - [Example: Working with Spots: Add an Inline Spot](#expand-working-with-spots-inline)
    - [Example: Working with Spots: Add an Interstitial Spot](#enable-mobile-messages-push-notification)
    - [Example: Enable Mobile Messages: Push Notification](#enable-mobile-messages-push-notification)
    - [Example: Enable Mobile Messages: Rich Push Notification](#enable-mobile-messages-rich-push-notification)
    - [Example: Reset the Mobile Device ID](#expand-reset-the-mobile-device-id)


## Framework Versions

State the versions of Native iOS and React Native frameworks that you're using for these examples.

- Native iOS: iOS 12.4+
- React Native: 0.71+

## Functionality Comparisons

### Example: Enable SDK internal Logging
<a name="expand-enable-sdk-internal-logging"></a>
<details><summary>Click to expand</summary>

This example illustrates how to set up SAS Collector and Logger in a Native iOS application. **Note: The setup for Native iOS and React Native iOS projects is the same for this functionality.** You will need to modify your `AppDelegate.h` and `AppDelegate.m` files.

#### Step 1: Update AppDelegate.h

In your `AppDelegate.h` file, you need to import the SASCollector header. 

```objective-c
// AppDelegate.h

// ... Your existing import statements
#import <UIKit/UIKit.h>

// NEWLY ADDED: Import SASCollector
#import <SASCollector/SASCollector.h>

// ... Rest of the file
```

#### Step 2: Update AppDelegate.m

In your `AppDelegate.m` file, you will need to import two headers: `SASCollector.h` and `SASLogger.h`.

```objective-c
// AppDelegate.mm

// ... Your existing import statements
#import <UIKit/UIKit.h>

// NEWLY ADDED: Import SASCollector and SASLogger
#import <SASCollector/SASCollector.h>
#import <SASCollector/SASLogger.h>

// ... Rest of the file
```

#### Step 3: Modify didFinishLaunchingWithOptions Method

Locate the `didFinishLaunchingWithOptions:` method in your `AppDelegate.m` and add the following line to set the SAS Logger level.

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ... Existing code

    // NEWLY ADDED: Set SAS Logger level
    [SASLogger setLevel:SASLoggerLevelError];

    // ... Existing code
    return YES;
}
```

[Back to Top](#back-to-top)
</details>



---

### Example: Return the Mobile SDK Version
<a name="expand-return-the-mobile-sdk-version"></a>
<details><summary>Click to expand</summary>

This example provides guidance on how to obtain the SDK version in both native iOS using Objective-C and React Native iOS using TypeScript.

## Native iOS Objective-C

To retrieve the SDK version in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
+(NSString*)sdkVersion;
```

## React Native iOS TypeScript

To retrieve the SDK version in React Native using TypeScript, follow these steps:

1. Import the required modules and functions:

   ```typescript
   import React, { useState, useEffect } from 'react';
   import { View, Text, Platform } from 'react-native';
   import { getSdkVersion } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to store the SDK version:

   ```typescript
   const [sdkVersion, setSdkVersion] = useState<string>('');
   ```

3. Utilize the `useEffect` hook to fetch the SDK version and update the state:

   ```typescript
   useEffect(() => {
       getSdkVersion((version: string) => {
           setSdkVersion(version);
       });
   }, []);
   ```

4. Display the SDK version in your component's `return` statement:

   ```typescript
   return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>{Platform.OS} SDK version: {sdkVersion}</Text>
    </View>
   );
   ```

5. As a reference, the `getSdkVersion` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
   RCT_EXPORT_METHOD(getSdkVersion:(RCTResponseSenderBlock)callback)
   {
      NSString* sdkVersion = [SASCollector sdkVersion];
      callback(@[sdkVersion]);
   }
   ```

6. Example Code: [sdkVersionExample.tsx](./docs/sdkVersionExample.tsx)

[Back to Top](#back-to-top)
</details>


---

### Example: Retrieving the Session ID
<a name="expand-return-session-id"></a>
<details><summary>Click to expand</summary>

This example provides guidance on how to obtain the session ID in both native iOS using Objective-C and React Native iOS using TypeScript.

## Native iOS Objective-C

To retrieve the session ID in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
NSString* sessionParamter = [SASCollector getSessionBindingParamter]; //_ci_=<device_id>*<session_id>*<heartbeat>*<timestamp>
NSString* sessionID = [[sessionParamter componentsSeparatedByString:@"="][1] componentsSeparatedByString:@"*"][1];
```

## React Native iOS TypeScript

To retrieve the Session ID in React Native using TypeScript, follow these steps:

1. Import the required modules and functions:

   ```typescript
   import React, { useState, useEffect } from 'react';
   import { View, Text } from 'react-native';
   import { getSessionID } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to store the session ID:

   ```typescript
   const [sessionID, setSessionID] = useState<string>('');
   ```

3. Utilize the `useEffect` hook to fetch the SDK version and update the state:

   ```typescript
   useEffect(() => {
       getSessionID((sessionID: string) => {
           setSessionID(sessionID);
       });
   }, []);
   ```

4. Display the session ID in your component's `return` statement:

   ```typescript
   return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Session ID: {sessionID}</Text>
    </View>
   );
   ```

5. As a reference, the `getSessionID` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
    RCT_EXPORT_METHOD(getSessionID:(RCTResponseSenderBlock)callback)
    {
        NSString* sessionParamter = [SASCollector getSessionBindingParamter]; //_ci_=<device_id>*<session_id>*<heartbeat>*<timestamp>
        NSString* sessionID = [[sessionParamter componentsSeparatedByString:@"="][1] componentsSeparatedByString:@"*"][1];
        callback(@[sessionID]);
    }
   ```

6. Example Code: [sessionIdExample.tsx](./docs/sessionIdExample.tsx)

[Back to Top](#back-to-top)
</details>


---

### Example: Retrieving the Device ID
<a name="expand-return-session-id"></a>
<details><summary>Click to expand</summary>

This example provides guidance on how to obtain the Device ID in both native iOS using Objective-C and React Native iOS using TypeScript.

## Native iOS Objective-C

To retrieve the Device ID in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
[SASCollector deviceId];
```

## React Native iOS TypeScript

To retrieve the Device ID in React Native using TypeScript, follow these steps:

1. Import the required modules and functions:

   ```typescript
   import React, { useState, useEffect } from 'react';
   import { View, Text } from 'react-native';
   import { getDeviceID } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to store the Device ID:

   ```typescript
   const [deviceID, setDeviceID] = useState<string>('');
   ```

3. Utilize the `useEffect` hook to fetch the SDK version and update the state:

   ```typescript
   useEffect(() => {
       getDeviceID((deviceID: string) => {
           setDeviceID(deviceID);
       });
   }, []);
   ```

4. Display the Device ID in your component's `return` statement:

   ```typescript
   return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text>Device ID: {deviceID}</Text>
    </View>
   );
   ```

5. As a reference, the `getDeviceID` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
    RCT_EXPORT_METHOD(getDeviceID:(RCTResponseSenderBlock)callback) {
        NSString* deviceID = [SASCollector deviceId];
        callback(@[deviceID]);
    }
   ```

6. Example Code: [deviceIdExample.tsx](./docs/deviceIdExample.tsx)

[Back to Top](#back-to-top)
</details>

---

### Example: Track User Navigation in the App
<a name="expand-track-user-navigation-in-the-app"></a>
<details><summary>Click to expand</summary>

This example illustrates the process of using the `newPage` API from the React Native SDK to track user navigation within your app.

**Using the Native iOS SDK:**

```objective-c
[SASCollector newPage:@"outdoor/fishing/livebait"];
```

**Using React Native with TypeScript:**

Follow these steps to monitor user navigation within your app:

1. Import the necessary modules and functions:

   ```typescript
   import React from 'react';
   import { newPage } from 'mobile-sdk-react-native';
   ```

2. Trigger the `newPage` API within your component's `return` statement:

   ```typescript
   return (
      newPage('outdoor/fishing/livebait');
   );
   ```

3. As a reference, the `newPage` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
   RCT_EXPORT_METHOD(newPage:(NSString*)uri)
   {
      [SASCollector newPage:uri];
   }
   ```

3. Example Code: [newPageExample.tsx](./docs/newPageExample.tsx)

[Back to Top](#back-to-top)   
</details>


---

### Example: Bind a Device ID to and Identity
<a name="expand-bind-a-device-id-to-and-identity"></a>
<details><summary>Click to expand</summary>

This example demonstrates how to use the `identity:withType:completion:` API from the React Native SDK to associate a user's identity with a device ID. This association is performed after the user signs in to your app, allowing you to uniquely identify the user. The `type` parameter specifies the type of identity (customer ID or login), while the `value` parameter holds the corresponding identifier. The supported identity types are `SASCOLLECTOR_IDENTITY_TYPE_CUSTOMER_ID` and `SASCOLLECTOR_IDENTITY_TYPE_LOGIN`, which are constants defined in `SASCollectorEvents.h`.

**Using the Native iOS SDK:**

Here's an example that uses `CUSTOMER_ID` as the identity:

```objective-c
[SASCollector
    identity:logonValue
    withType:SASCOLLECTOR_IDENTITY_TYPE_CUSTOMER_ID
    completion:^(bool completed) {
        NSLog(completed ? @"success" : @"failure");
    
        // Identity is now associated
        dispatch_async(dispatch_get_main_queue(), ^{
            // Perform tasks here that need to be on the main thread
        });
}];
```

**Using React Native with TypeScript:**

Follow these steps to retrieve the SDK version:

1. Import the required modules and functions:

   ```typescript
    import React, { useState } from 'react';
    import { View, Button, TextInput } from 'react-native';
    import { identity } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to hold the login type and user ID:

   ```typescript
    const [userId, setUserId] = React.useState<string>('');
    const loginType = 'IDENTITY_TYPE_CUSTOMER_ID';
    // const loginType = 'IDENTITY_TYPE_LOGIN_ID';
   ```

3. Create a handler function to trigger the `identity` function:

   ```typescript
   const handlePress = async () => {
    try {
        await identity(userId, loginType);
        console.log('Log-in Success');
    } catch (error) {
        console.log('Log-in Failure');
    }
   };
   ```

4. Include a button in your component's `return` statement:

   ```typescript
   return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <TextInput
            placeholder="Enter User ID"
            onChangeText={setUserId} // Capture and update the userId state
        />
      <Button title="Identity" onPress={handlePress} />
    </View>
   );
   ```

5. As a reference, the `identity` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
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
   ```

6. Example Code: [identityExample.tsx](./docs/identityExample.tsx)

[Back to Top](#back-to-top)
</details>


---

### Example: Detach Identity from Device
<a name="expand-detach-identitiy-from-device"></a>
<details><summary>Click to expand</summary>

Use the `detachIdentity` method to allow users to sign out from your app. This action:

- Disconnects the device from the user's current identity, stopping personalized push notifications.
- Generates new session and focus events.
  
**Using the Native iOS SDK:**

```objective-c
+(void)detachIdentity:(void(^)(bool))completionHandler
```

You can also suspend data collection and detach identity together using `shutdownAndDetachIdentity`. To reattach the device, use the `identity` method. To resume collection, call `[SASCollector initializeCollection];`.

**Using React Native with TypeScript:**

Follow these steps to retrieve the SDK version:

1. Import the required modules and functions:

   ```typescript
   import React, { useState } from 'react';
   import { View, Button } from 'react-native';
   import { detachIdentity } from 'mobile-sdk-react-native';
   ```

2. Create a handler function to trigger the `detachIdentity` function:

   ```typescript
   const handlePress = async () => {
    try {
        await detachIdentity();
        console.log('Log-out Success');
    } catch (error) {
        console.log('Log-out Failure');
    }
   };
   ```

3. Include a button in your component's `return` statement:

   ```typescript
   return (
    <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Button title="Detach Identity" onPress={handlePress} />
    </View>
   );
   ```

4. As a reference, the `detachIdentity` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
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
   ```
5. Example Code: [detachIdentityExample.tsx](./docs/detachIdentityExample.tsx)

[Back to Top](#back-to-top)
</details>


---

### Example: Working with Events
<a name="expand-working-with-events"></a>
<details><summary>Click to expand</summary>

When working with events, utilize the `addAppEvent` API to send customized event data to the mobile SDK. This API involves:

- An event identifier (mobile event key) that aligns with your SAS Customer Intelligence 360 configuration.
- Optional metadata in the form of name-value pairs within a dictionary.

**Using the Native iOS SDK:**

To send events in native iOS, use the following method:

```objective-c
+(void)addAppEvent:(NSString*)eventName data:(NSDictionary *)data;
```

Example usage:

```objective-c
[SASCollector addAppEvent:@"myEventId"
      data:@{@"myAttributeName":@"myAttributeValue"}];
```

You can omit metadata using:

```objective-c
[SASCollector addAppEvent:@"myEvent" data:nil];
```

**Using React Native with TypeScript:**

Follow these steps:

1. Import necessary modules and functions:

   ```typescript
   import React, { useState } from 'react';
   import { View, TextInput, Button } from 'react-native';
   import { addAppEvent } from 'mobile-sdk-react-native';
   ```

2. Set up state to hold custom event data:

   ```typescript
   const [customEventKey, setCustomEventKey] = React.useState<string>('');
   ```

3. Include a TextInput and Button to submit `addAppEvent`:

   ```typescript
   return (
     <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <TextInput
            placeholder="Submit Custom Event"
            onChangeText={setCustomEventKey} // Capture and update the CustomEventKey state
        />
       <Button title="Submit Custom Event" onPress={
           () => {
               addAppEvent(customEventKey, null);
            }
        } />
     </View>
   );
   ```

5. As a reference, the `addAppEvent` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
    RCT_EXPORT_METHOD(addAppEvent: (NSString*)eventKey data:(NSDictionary*)data){
        [SASCollector addAppEvent:eventKey data:data];
    }
   ```

6. Example Code: [addAppEventExample.tsx](./docs/addAppEventExample.tsx)

[Back to Top](#back-to-top)
</details>


---
### Example: Working with Spots: Add an Inline Spot
<a name="expand-working-with-spots-inline"></a>
<details><summary>Click to expand</summary>

When define `Inline` spot in a React Native project, there's no need to define the view within the app's ViewController. This aspect is seamlessly managed by pre-built functions available in our React Native SDK, located in `ios\views`, `src\InlineAdView.tsx`, `Constants.m`. 

For better comparison, the corresponding example in our native iOS SDK uses UIKit with Objective-C.

**Using the Native iOS SDK:**

To define spot in native iOS via UIKit, use the following method:

1. in .h file, import UIKit and SASCollector and conform SASIA_AdDelegate protocol in the ViewContorller
    ```objective-c
    #import <UIKit/UIKit.h>
    #import <SASCollector/SASCollector.h>
    @interface ViewController : UIViewController <SASIA_AdDelegate>
    @end
    ```

2. in .m file, with the viewDidLoad method
    - initialize SASCollectorUIAdView, 
    - define SpotID
    - add to View and load the Spot:
    ```objective-c
    SASCollectorUIAdView *myAd1 = [[SASCollectorUIAdView alloc] initWithFrame:CGRectMake(25, 25, 400, 300)];

    myAd1.delegate = self; 
    myAd1.spotID = @"snzrle_native_spot";
    
    [self.view addSubview:myAd1];
    [myAd1 load];
    ```

**Using React Native with TypeScript:**

Follow these steps:

1. Import necessary modules and functions:

   ```typescript
   import React, { useEffect } from 'react';
   import { View, NativeEventEmitter } from 'react-native';
   import { InlineAdView, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';
   ```

2. Set up iOS messaging event that handle by NativeEventEmitter:

   ```typescript
   let iOSMessagingEvent: NativeEventEmitter;
    if (Platform.OS === 'ios') {
      iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
    }
   ```

3. Utilize the `useEffect` to listen `Inline Ad view is loaded` or `returned default content` (optional):
   ```typescript
    useEffect(() => {
      if (Platform.OS === 'ios') {
        const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INLINE_AD) {
            console.log('Inline Ad view is loaded.');
          }
        });

        const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INLINE_AD) {
            console.log('Inline Ad view returned default content.');
          }
        });

        return () => {
          adLoadedListener.remove();
          adDefaultLoadedListener.remove();
        };
      }
    }, []);
    ```
4. Include a `spotId` in `InlineAdView` for display content:

   ```typescript
   return (
     <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <InlineAdView
            spotId="snzrle_app_spot" //the mobile spot id defined in your tenant
            style={{ height: 250, width:300, margin: 25}}
        />
     </View>
   );
   ```

5. As a reference, working with the InlineAdView spot involves three components:

   - Bridging: 
      - ios/[views/InlineAdViewManager.m](./docs/views/InlineAdViewManager.m)
      - ios/[views/InlineAdView.m](./docs/views/InlineAdView.m)
   - Managing events:
      - ios/[views/AdDeledgateEvent.m](./docs/views/AdDelegateEvent.m)
      - ios/[Constants.m](./docs/Constants.m)
   - UIManager:
      - src/[views/InlineAdView.tsx](./docs/views/InlineAdView.tsx) 

6. Example Code: [addInlineAdViewExample.tsx](./docs/addInlineAdViewExample.tsx)

[Back to Top](#back-to-top)
</details>

---
### Example: Working with Spots: Add an Interstitial Spot
<a name="expand-working-with-spots-interstitials"></a>
<details><summary>Click to expand</summary>


When utilizing the `Interstitial` spot in a React Native project, it should be initilized during the screen display and similar to Inline Spot which require the spotID.

**Using the Native iOS SDK:**

To define spot in native iOS, use the following method:

1. Initial the interstitial ad spot on screen load:
    ```objective-c
    self.interstitialAd = [[SASCollectorInterstitialAd alloc] init];
    ```

2. define the interstitial spot with spotID:
    ```objective-c
    self.interstitialAd.spotID = @"MySpotID";
    self.MyInterstitialAd1.delegate = self;
    [self.MyInterstitialAd1 load];
    ```

**Using React Native with TypeScript:**

Follow these steps:

1. Import necessary modules and functions:

   ```typescript
   import React, { useEffect } from 'react';
   import { View, NativeEventEmitter } from 'react-native';
   import { InterstitialAdView, AdDelegateEvent, Constants } from 'mobile-sdk-react-native';
   ```

2. Set up iOS messaging event that handle by NativeEventEmitter:

   ```typescript
   let iOSMessagingEvent: NativeEventEmitter;
    if (Platform.OS === 'ios') {
      iOSMessagingEvent = new NativeEventEmitter(AdDelegateEvent);
    }
   ```

3. Utilize the `useEffect` to listen `Interstitial Ad view is loaded` or `returned default content` (optional):
   ```typescript
    useEffect(() => {
      if (Platform.OS === 'ios') {
        const adLoadedListener = iOSMessagingEvent.addListener(Constants.AD_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            console.log('Interstitial Ad view is loaded.');
          }
        });

        const adDefaultLoadedListener = iOSMessagingEvent.addListener(Constants.AD_DEFAULT_LOADED, (event: Event) => {
          if (event === Constants.TYPE_INTERSTITIAL_AD) {
            console.log('Interstitial Ad view returned default content.');
          }
        });

        return () => {
          adLoadedListener.remove();
          adDefaultLoadedListener.remove();
        };
      }
    }, []);
    ```
4. Include a `spotId` in `InterstitialAdView` for display content:

   ```typescript
   return (
     <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <InterstitialAdView
            spotId="snzrle_app_interstitial" //the mobile spot id defined in your tenant
        />
        <Text>Page to load Interstitial Spot.</Text>
     </View>
   );
   ```

5. As a reference, working with the InterstitialAdView spot involves three components:

   - Bridging: 
      - ios/[views/InterstitialAdViewController.m](./docs/views/InterstitialAdViewController.m)
      - ios/[views/InterstitialAdViewManager.m](./docs/views/InterstitialAdViewManager.m)
      - ios/[views/InterstitialAdView.m](./docs/views/InterstitialAdView.m)
   - Managing events:
      - ios/[views/AdDeledgateEvent.m](./docs/views/AdDelegateEvent.m)
      - ios/[Constants.m](./docs/Constants.m)
   - UIManager:
      - src/[views/InterstitialAdView.tsx](./docs/views/InterstitialAdView.tsx) 

6. Example Code: [addInterstitialAdViewExample.tsx](./docs/addInterstitialAdViewExample.tsx)

[Back to Top](#back-to-top)
</details>

---
### Example: Enable Mobile Messages: Push Notification
<a name="enable-mobile-messages-push-notification"></a>
<details><summary>Click to expand</summary>

## Prerequisites
- Generate APNS authentication key
- Set up Push Notification and Background capability in XCode


## Enable iOS application with Push Notification via SAS SDK

### AppDelegate.h Configuration

Replace the content in `AppDelegate.h` with the following code:

   ```objective-c
   #import <React/RCTBridgeDelegate.h>
   #import <UIKit/UIKit.h>
   #import <UserNotifications/UserNotifications.h>
   #import <React/RCTBridge.h>
   #import <React/RCTEventDispatcher.h>
   #import <SASCollector/SASCollector.h>

   @interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, RCTBridgeDelegate, SASMobileMessagingDelegate2>
   @property (nonatomic, strong) UIWindow *window;
   @end
   ```

### AppDelegate.m Configuration

1. **Add Imports**

   Add these imports for SAS CI360 SDK:

   ```objective-c
   #import <SASCollector/SASCollector.h>
   #import <SASCollector/SASLogger.h>
   #import <mobile-sdk-react-native/SASMobileMessagingEvent.h>
   ```

2. **Initialize Logger and Request Authorization**

   In the `didFinishLaunchingWithOptions` method, add `currentNotificationCenter` with Authorization code for asking permission to use Push Notificaiton in user's iPhone:

   ```objective-c
   [SASLogger setLevel:SASLoggerLevelAll];

   if (@available(iOS 10.0, *)) {
      UNUserNotificationCenter.currentNotificationCenter.delegate = self;
      [UNUserNotificationCenter.currentNotificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
         if (error != nil) {
            [SASLogger error:error.localizedDescription];
            return;
         }
         dispatch_async(dispatch_get_main_queue(), ^{
            [application registerForRemoteNotifications];
         });
      }];
   }

   [SASCollector setMobileMessagingDelegate2:self];
   ```

3. **Register for Remote Notifications**

   Add the `didRegisterForRemoteNotificationsWithDeviceToken` and `didReceiveRemoteNotification` methods to the application with SASCollector function, for register device token and push notification handler:

   ```objective-c
   -(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
      [SASCollector registerForMobileMessages:deviceToken completionHandler:^{
         [SASLogger info:@"Registering for remote notifications is successful"];
      } failureHandler:^{
         [SASLogger info:@"Registering for remote notifications failed"];
      }];
   }

   -(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
      [SASCollector handleMobileMessage:userInfo withApplication:application];
      completionHandler(UIBackgroundFetchResultNoData);
   }
   ```

4. **Handle Notification Response**

   Add `didReceiveNotificationResponse` method:

   ```objective-c
   -(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
      [SASCollector handleMobileMessage:response.notification.request.content.userInfo withApplication:UIApplication.sharedApplication];
      completionHandler();
   }
   ```

5. **Add support functions for SAS**

   To handle Push Notification Action Link:
   ```objective-c
   -(NSDictionary*)getActionLinkFromMobileMessage:
      (NSDictionary *)notificationInfo {
         if (notificationInfo == nil) {
            return nil;
         }
         NSDictionary *aps = notificationInfo[@"aps"];
         NSDictionary *mobileMessageDictionary =
         aps[@"MobileMessage"];

         if (mobileMessageDictionary == nil) {
            return nil;
         }
         if (![mobileMessageDictionary[@"template"]
            isEqualToString:@"creative.pushNotification"]) {
            return nil;
      }
      NSArray *actions = mobileMessageDictionary[@"actions"];
      NSString *link = actions[0][@"link"];
      if (link == nil) {
         return nil;
      }
      return @{@"notificationWithLink": link};
   }
   ```

   To handle the user action when Push Notification / In-App Message received:
   ```objective-c
   #pragma mark SASMobileMessagingDelegate2
   -(void)actionWithLink:(NSString * _Nonnull)link
   type:(SASMobileMessageType)type {
   NSMutableString* msgType = [NSMutableString
      stringWithString:@""];
   if (type == SASMobileMessageTypePushNotification) {
      msgType = [NSMutableString
         stringWithString:@"PushNotification"];
   } else if (type == SASMobileMessageTypeInAppMessage) {
      msgType = [NSMutableString
         stringWithString:@"InAppMsg"];
   }
   NSDictionary *args = @{@"type": msgType,
   @"link": link};
   [SASMobileMessagingEvent
      emitMessageOpenedWithPayload:args];
   }
   -(void)messageDismissed {
   [SASMobileMessagingEvent emitMessageDismissed];
   }
   ```

6. **To enable Rich Push Notification**

   Please refer to the [Enable Mobile Messages: Rich Push Notification](#enable-mobile-messages-rich-push-notification) section.


7. **Enable Push Notification in React Native App**
    After apply iOS configuration via XCode, we can now able to add React Native

   ### Step 1: Import Required Modules
   ```typescript
   import { NativeEventEmitter, DeviceEventEmitter, Platform } from 'react-native';
   ```

   ### Step 2: Initialize Mobile Messaging Event for iOS
   ```typescript
   let iOSMessagingEvent;
   if (SASMobileMessagingEvent != null) {
   iOSMessagingEvent = new NativeEventEmitter(SASMobileMessagingEvent);
   }
   ```

   ### Step 3: Add Event Listeners
   Add the following code to ensure that event listeners are in place to handle both push notifications and in-app messages.
   ```typescript
   React.useEffect(() => {
   if (Platform.OS === 'ios') {
      iOSMessagingEvent.addListener(Constants.MESSAGE_OPENED, (data) => {
         console.log('data: ' + data);
         console.log('message type: ' + data.type + ' link is: ' + data.link);
         const msg = (data.type === 'InAppMsg' ? 'User got in-app msg with link:' + data.link : 'User got push notification with link:' + data.link);
      });

      iOSMessagingEvent.addListener(Constants.MESSAGE_DISMISSED, () => {
         console.log('User dismissed message');
      });
   }
   }, []);
   ```

   ### Step 4: Cleanup
   Make sure to remove all listeners when the component unmounts.
   ```typescript
   return () => {
      DeviceEventEmitter.removeAllListeners();
      if (SASMobileMessagingEvent) {
         iOSMessagingEvent.removeAllListeners(SASMobileMessagingEvent);
      }
   };
   ```

[Back to Top](#back-to-top)
</details>

---
### Example: Enable Mobile Messages: Rich Push Notification
<a name="enable-mobile-messages-rich-push-notification"></a>
<details><summary>Click to expand</summary>

### Step 1: Create Notification Service Extension

   1. Open your project in Xcode.
   2. Go to `File` -> `New` -> `Target`.
   3. Choose `Notification Service Extension` and click `Next`.
   4. Enter the name for your new target and click `Finish`.
 

### Step 2: Update NotificationService.m

   After the target is created, two new files are added: `NotificationService.h` and `NotificationService.m`. Replace the `didReceiveNotificationRequest` method in `NotificationService.m` with the following code:

   ```objective-c
   -(void)didReceiveNotificationRequest:(UNNotificationRequest
      *)request withContentHandler:(void
      (^)(UNNotificationContent * _Nonnull))contentHandler {
         self.contentHandler = contentHandler;
         self.bestAttemptContent = [request.content mutableCopy];
         NSDictionary *notificationData =
         (NSDictionary*)request.content.userInfo[@"data"];
         if (notificationData == nil) {
            return;
         }
         NSString *urlStr = (NSString*)[notificationData
         objectForKey:@"attachment-url"];
         if (urlStr == nil) {
            return;
         }
         NSURL *fileUrl = [NSURL URLWithString:urlStr];
         if (fileUrl == nil) {
            return;
         }
         NSURLSessionDownloadTask *downloadTask =
         [NSURLSession.sharedSession
            downloadTaskWithURL:fileUrl
            completionHandler:^(NSURL * _Nullable location,
                  NSURLResponse * _Nullable response,
                  NSError * _Nullable error) {
                  if (location != nil && error == nil) {
                     NSString *tempDir = NSTemporaryDirectory();
                     NSString *suggestedName = [response
                     suggestedFilename];
                     if (suggestedName != nil) {
                        NSString *fileName = [NSString
                           stringWithFormat:@"file://%@%@", tempDir, suggestedName];
                        NSString *tempFileName = [fileName
                           stringByReplacingOccurrencesOfString:@" " withString:@"_"];
                        NSURL *tempUrl = [NSURL
                           URLWithString:tempFileName];
                        NSError *removeFileError;

                        if ([NSFileManager.defaultManager
                           fileExistsAtPath:tempUrl.path] &&
                           [NSFileManager.defaultManager
                              isDeletableFileAtPath:tempUrl.path]) {
                              [NSFileManager.defaultManager
                              removeItemAtPath:tempUrl.path error:&removeFileError];
                     }
                     if (removeFileError != nil) return;

                     NSError *moveFileError;
                     [NSFileManager.defaultManager
                     moveItemAtURL:location toURL:tempUrl error:&moveFileError];
                     if (moveFileError != nil) return;

                     NSError *attachmentError;
                     UNNotificationAttachment *attachment =
                     [UNNotificationAttachment
                     attachmentWithIdentifier:@"ci360content" URL:tempUrl
                     options:nil error:&attachmentError];
                     self.bestAttemptContent.attachments =
                     @[attachment];
                     if (attachmentError != nil) return;
                  }
            }
            self.contentHandler(self.bestAttemptContent);
         }];
         [downloadTask resume];
      }
   ```

   This will enable rich push notifications for your iOS React Native application. The guide now includes the configuration for `AppDelegate.h`, `AppDelegate.m`, and rich push notifications.

[Back to Top](#back-to-top)
</details>

---
(Continue with other functionalities)
