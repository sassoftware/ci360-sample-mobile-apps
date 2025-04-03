# Working with the react-native Android Mobile SDK

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

Before proceeding, ensure that you have successfully installed the React-Native SDK [installation guide](link-to-installation-guide). If you haven't completed this step yet, please refer to the installation guide for step-by-step instructions on setting up the SDK.

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

State the versions of React Native frameworks that you're using for these examples.

- React Native: 0.72+

## Updated (V2) Framework Version

State the versions of React Native frameworks that you're using for these examples.

#### Upgrade to V2 with r=react-native 0.76.5

See references from [cookbook](#https://support.sas.com/documentation/onlinedoc/ci/ci360-mobile-sdks/ci360-react-native-cookbook.pdf) for React Native Version Update with [code](#https://support.sas.com/documentation/onlinedoc/ci/ci360-mobile-sdks/mobile-sdk-react-native.zip)

##### Note: This repository already includes the changes from cookbook please skip next step if using this repository

The current react native version of the example project is old and caused build errors on Mac
OS Sequoia. In addition, Android adb server cannot start with the old react native version
(possibility related to VPN). Due to these reasons, the project is updated with react native
version 0.76.5. Other packages are also updated to be compatible.

Please check out package.json and example/package.json in the project for details.

The top level package.json set yarn as the package manager. So please use yarn when installing the packages.

A new file turbo.json is created in the top project level, and it makes use of the TurboModule
system and generates code in both native android/ios and typescript/javascript based on given
inputs.

Please refer to the project for details. There are more configuration changes, and I will
list a few here:

1.  mobile-sdk-react-native.podspec
2.  .yarnrc.yml (new)
3.  tsconfig.json
4.  android/build.gradle
5.  android/gradle.properties
6.  example/android/gradle.properties
7.  example/android/settings.gradle
8.  example/android/build.gradle
9.  example/metro.config.js
10. example/react-native.config.js
11. example/app.json (new)
12. example/index.tsx
13. example/babel.config.js
14. Example/Gemfile
15. Turbo.json (new)
16. Package.json
17. example/package.json

In addition, react native 0.76.5 needs a newer Android Gradle Plugin (AGP 8.6) than the
previous version. For this update, Android Studio Ladybug 2024.2.1 which includes AGP 8.6 is
used for development. IOS development tool, in addition to VS Code, is Xcode 16.

#### Follow instructions from cookbook for more information.

Create a new library from npx

create-react-native-library@latest mobile-sdk-react-native

After successful creation of library using nitro module copy the below resources from cook book's code.

- android/
- ios/
- example/
- scripts/
- src/
- mobile-sdk-react-native.podspec
- package.json

#### go to root directory

- yarn root directory

- yarn example/
- bundle install ios/
- pod install ios/

### for Android

- yarn install
- cd example
- npm run start and then press a for android

### Note:

if you face any issue in lining of packages
Remove workspace:['example'] from root package.json

Then try yarn install at root level and npm install in example.

## Functionality Comparisons

### Example: Enable SDK internal Logging

<details><summary>Click to expand</summary>
<a name="expand-enable-sdk-internal-logging"></a>

This example illustrates how to set up SAS Collector and Logger in a Native Android application.

#### Step 1: Install packages

npx create-react-native-library mobile-sdk-react-native

```Java
import com.sas.mkt.mobile.sdk.SASCollector;
import com.sas.mkt.mobile.sdk.util.SLog;

// ... Rest of the file
```

#### Step 2: call log function

use log in onCreate method of MainApplication.java

```java
  @Override
  public void onCreate() {
    super.onCreate();
    SASCollector.getInstance().initialize(this);
    SLog.setLevel(SLog.ALL);

   ...
  }

```

[Back to Top](#back-to-top)

</details>

---

### Example: Return the Mobile SDK Version

<details><summary>Click to expand</summary>
<a name="expand-return-the-mobile-sdk-version"></a>

This example provides guidance on how to obtain the SDK version in React Native Android using TypeScript.

## React Native Android TypeScript

To retrieve the SDK version in React Native using TypeScript, follow these steps:

1. Import the required modules and functions:

   ```typescript
   import React, { useState, useEffect } from 'react';
   import { View, Text, Platform } from 'react-native';
   import { getSdkVersion } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to store the SDK version:

   ```typescript
   const [sdkVersion, setSdkVersion] = useState('');
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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <Text>
         {Platform.OS} SDK version: {sdkVersion}
       </Text>
     </View>
   );
   ```

5. As a reference, the `getSdkVersion` function is implemented in the `mobile-sdk-react-native.java` file of our React Native SDK:

   ```objective-c
   Java code for getsdk version
   ```

6. Example Code: [sdkVersionExample.tsx](./sdkVersionExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Retrieving the Session ID

<details><summary>Click to expand</summary>
<a name="expand-return-session-id"></a>

This example provides guidance on how to obtain the session ID in both native android using java and React Native iOS using TypeScript.

## Native android java

To retrieve the session ID in native android using java, you can use the following method:

```Java code
 @ReactMethod
  public void getSessionId(Callback callback) {
    callback.invoke(InternalSingleton.get().getSessionData().getCurrentSessionId());
  }
```

## React Native TypeScript

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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <Text>Session ID: {sessionID}</Text>
     </View>
   );
   ```

5. As a reference, the `getSessionID` function is implemented in the `mobile-sdk-react-native` of our React Native SDK:

   ```typescript
   export function getSessionId(callback: (sessionId: string) => void) {
     MobileSdkReactNative.getSessionId((sessionId: string) => {
       console.log('index :: ', sessionId);
       callback(sessionId);
     });
   }
   ```

6. Example Code: [sessionIdExample.tsx](./sessionIdExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Retrieving the Device ID

<details><summary>Click to expand</summary>
<a name="expand-return-session-id"></a>

This example provides guidance on how to obtain the Device ID in React Native using TypeScript.

## React Native android TypeScript

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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <Text>Device ID: {deviceID}</Text>
     </View>
   );
   ```

5. As a reference, the `getDeviceID` function is implemented in the `mobile-sdk-react-native` of our React Native SDK:

   ```Java
      @ReactMethod
   public void getDeviceID(Callback callback) {
    callback.invoke(SASCollector.getInstance().getDeviceID());
   }
   ```

6. Example Code: [deviceIdExample.tsx](./deviceIdExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Track User Navigation in the App

<details><summary>Click to expand</summary>
<a name="expand-track-user-navigation-in-the-app"></a>

This example illustrates the process of using the `newPage` API from the React Native SDK to track user navigation within your app.

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

3. As a reference, the `newPage` function is implemented in the `mobile-sdk-react-native` of our React Native SDK:

   ```java
     @ReactMethod
      public void newPage(String uri) {
         SASCollector.getInstance().newPage(uri);
      }
   ```

4. Example Code: [newPageExample.tsx](./newPageExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Bind a Device ID to and Identity

<details><summary>Click to expand</summary>
<a name="expand-bind-a-device-id-to-and-identity"></a>

This example demonstrates how to use the `identity:withType:completion:` API from the React Native SDK to associate a user's identity with a device ID. This association is performed after the user signs in to your app, allowing you to uniquely identify the user. The `type` parameter specifies the type of identity (customer ID or login), while the `value` parameter holds the corresponding identifier. The supported identity types are `SASCOLLECTOR_IDENTITY_TYPE_CUSTOMER_ID` and `SASCOLLECTOR_IDENTITY_TYPE_LOGIN`, which are constants defined in `SASCollectorEvents.h`.

**Using the Native android SDK:**

Here's an example that uses `CUSTOMER_ID` as the identity:

```java
@ReactMethod
  public void identity(
      String value, String type, Promise promise) {
    SASCollector.getInstance()
        .identity(value, type,
            new SASCollector.IdentityCallback() {
              @Override
              public void onComplete(boolean b) {
                Log.d("Identity", "Identity called with: "
                    + (b ? "success" : "failure"));
                new Handler(Looper.getMainLooper())
                    .post(new Runnable() {
                      @Override
                      public void run() {
                        promise.resolve(b);
                      }
                    });
              }
            });
  }
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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <TextInput
         placeholder="Enter User ID"
         onChangeText={setUserId} // Capture and update the userId state
       />
       <Button title="Identity" onPress={handlePress} />
     </View>
   );
   ```

5. As a reference, the `identity` function is implemented in the `mobile-sdk-react-native` of our React Native SDK:

   ```typescript
   export async function identity(value: string, type: string) {
     try {
       console.log('awaiting for identity in index', value, type);
       const isSuccess: boolean = await MobileSdkReactNative.identity(
         value,
         type
       );
       console.log('isSuccess for identity in index', isSuccess);
       return isSuccess;
     } catch (e: any) {
       console.log('error from identity in index', e);
       return false;
     }
   }
   ```

6. Example Code: [identityExample.tsx](./identityExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Detach Identity from Device

<details><summary>Click to expand</summary>
<a name="expand-detach-identitiy-from-device"></a>

Use the `detachIdentity` method to allow users to sign out from your app. This action:

- Disconnects the device from the user's current identity, stopping personalized push notifications.
- Generates new session and focus events.

**Using the Native Android SDK:**

```java
@ReactMethod
  public void detachIdentity(Promise promise) {
    SASCollector.getInstance()
        .detachIdentity(new SASCollector.DetachIdentityCallback() {
          @Override
          public void onComplete(boolean b) {
            new Handler(Looper.getMainLooper())
                .post(new Runnable() {
                  @Override
                  public void run() {
                    promise.resolve(b);
                  }
                });
          }
        });
  }

```

You can also suspend data collection and detach identity together using `shutdownAndDetachIdentity`. To reattach the device, use the `identity` method.

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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <Button title="Detach Identity" onPress={handlePress} />
     </View>
   );
   ```

4. As a reference, the `detachIdentity` function is implemented in the `mobile-sdk-react-native` of our React Native SDK:

   ```typescript
   export async function detachIdentity() {
     try {
       const isSuccess = await MobileSdkReactNative.detachIdentity();
       return isSuccess;
     } catch (e: any) {
       console.log(e);
       return false;
     }
   }
   ```

5. Example Code: [detachIdentityExample.tsx](./detachIdentityExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Working with Events

<details><summary>Click to expand</summary>
<a name="expand-working-with-events"></a>

When working with events, utilize the `addAppEvent` API to send customized event data to the mobile SDK. This API involves:

- An event identifier (mobile event key) that aligns with your SAS Customer Intelligence 360 configuration.
- Optional metadata in the form of name-value pairs within a dictionary.

**Using the Native android SDK:**

To send events in native android, use the following method:

```java
@ReactMethod
  public void addAppEvent(String eventKey, ReadableMap data) {
    if (data == null) {
      SASCollector.getInstance().addAppEvent(eventKey, null);
      return;
    }
    System.out.println(eventKey);
    HashMap<String, Object> rawData = data.toHashMap();
    // String rawData = data;
    HashMap<String, String> convertedData = new HashMap<>();
    // String convertedData = data;
    for (Map.Entry<String, Object> entry : rawData.entrySet()) {
      if (entry.getValue() instanceof String) {
        convertedData.put(
            entry.getKey(), (String) entry.getValue());
      }
    }
    System.out.println(eventKey);
    SASCollector.getInstance().addAppEvent(eventKey, convertedData);
  }
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
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <TextInput
         placeholder="Submit Custom Event"
         onChangeText={setCustomEventKey} // Capture and update the CustomEventKey state
       />
       <Button
         title="Submit Custom Event"
         onPress={() => {
           addAppEvent(customEventKey, null);
         }}
       />
     </View>
   );
   ```

4. As a reference, the `addAppEvent` function is implemented in the `mobile-sdk-react-native` file of our React Native SDK:

   ```typescript
   export function addAppEvent(eventKey: string, data: Object) {
     MobileSdkReactNative.addAppEvent(eventKey, data);
   }
   ```

5. Example Code: [addAppEventExample.tsx](./addAppEventExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Working with Spots: Add an Inline Spot

<details><summary>Click to expand</summary>
<a name="expand-working-with-spots-inline"></a>

When define `Inline` spot in a React Native project, there's no need to define the view within the app's ViewController. This aspect is seamlessly managed by pre-built functions available in our React Native SDK, located in `src\views`, `src\views\InlineAdView.tsx`, `src\Constants`.

**Using the Native android SDK:**

To define spot in native android, use the following method:

1. In `mobile-sdk-react-native` file

   ```typescript
   import { NativeModules, Platform } from 'react-native';

   const AdDelegateEvent = NativeModules.AdDelegateEvent;
   ```

**Using React Native with TypeScript:**

Follow these steps:

1. Import necessary modules and functions:

   ```typescript
   import React, { useEffect } from 'react';
   import { View, NativeEventEmitter } from 'react-native';
   import {
     InlineAdView,
     AdDelegateEvent,
     Constants,
   } from 'mobile-sdk-react-native';
   ```

2. Utilize the `useEffect` to listen `Inline Ad view is loaded` or `returned default content` (optional):

   ```typescript
   useEffect(() => {
     if (Platform.OS == 'android') {
       DeviceEventEmitter.addListener('onAdLoaded', (event: Event) => {
         if (event === Constants.TYPE_INTERSTITIAL_AD) {
           Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
         } else if (event === Constants.TYPE_INLINE_AD) {
           Toast.show('Inline Ad view is loaded', Toast.SHORT);
         }
       });
       DeviceEventEmitter.addListener('onAdClosed', (event: Event) => {
         if (event === Constants.TYPE_INTERSTITIAL_AD) {
           Toast.show(
             'Interstitial Ad view is closed by the user',
             Toast.SHORT
           );
         } else if (event === Constants.TYPE_INLINE_AD) {
           Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
         }
         setShowInterstitial(false);
       });
     }
   }, []);
   ```

3. Include a `spotId` in `InlineAdView` for display content:

   ```typescript
   return (
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <InlineAdView
         spotId="snzrle_app_spot" //the mobile spot id defined in your tenant
         style={{ height: 250, width: 300, margin: 25 }}
       />
     </View>
   );
   ```

4. As a reference, working with the InlineAdView spot involves three components:

   - Bridging:
     - android/[java/views/InlineAdViewManager.java](./views/InlineAdViewManager.java)
     - android/[java/views/InlineAdView.java](./views/InlineAdView.java)
     - android/[java/views/Constants.java](./views/Constants.java)
   - UIManager:
     - src/[/views/InlineAdView.tsx](./views/InlineAdView.tsx)

5. Example Code: [addInlineAdViewExample.tsx](./addInlineAdViewExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Working with Spots: Add an Interstitial Spot

<details><summary>Click to expand</summary>
<a name="expand-working-with-spots-interstitials"></a>

When utilizing the `Interstitial` spot in a React Native project, it should be initilized during the screen display and similar to Inline Spot which require the spotID.

**Using the Native android SDK:**

<!-- To define spot in native android, use the following method:

1. Initial the interstitial ad spot on screen load:

   ```objective-c
   self.interstitialAd = [[SASCollectorInterstitialAd alloc] init];
   ```

2. define the interstitial spot with spotID:
   ```objective-c
   self.interstitialAd.spotID = @"MySpotID";
   self.MyInterstitialAd1.delegate = self;
   [self.MyInterstitialAd1 load];
   ``` -->

**Using React Native with TypeScript:**

Follow these steps:

1. Import necessary modules and functions:

   ```typescript
   import React, { useEffect } from 'react';
   import { View, DeviceEventEmitter } from 'react-native';
   import {
     InterstitialAdView,
     AdDelegateEvent,
     Constants,
   } from 'mobile-sdk-react-native';
   ```

2. Utilize the `useEffect` to listen `Interstitial Ad view is loaded` or `returned default content` (optional):

   ```typescript
   useEffect(() => {
     if (Platform.OS == 'android') {
       DeviceEventEmitter.addListener('onAdLoaded', (event: Event) => {
         if (event === Constants.TYPE_INTERSTITIAL_AD) {
           Toast.show('Interstitial Ad view is loaded', Toast.SHORT);
         } else if (event === Constants.TYPE_INLINE_AD) {
           Toast.show('Inline Ad view is loaded', Toast.SHORT);
         }
       });
       DeviceEventEmitter.addListener('onAdClosed', (event: Event) => {
         if (event === Constants.TYPE_INTERSTITIAL_AD) {
           Toast.show(
             'Interstitial Ad view is closed by the user',
             Toast.SHORT
           );
         } else if (event === Constants.TYPE_INLINE_AD) {
           Toast.show('Inline Ad view is closed by the user', Toast.SHORT);
         }
         setShowInterstitial(false);
       });
     }
   }, []);
   ```

3. Include a `spotId` in `InterstitialAdView` for display content:

   ```typescript
   return (
     <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
       <InterstitialAdView
         spotId="snzrle_app_interstitial" //the mobile spot id defined in your tenant
       />
       <Text>Page to load Interstitial Spot.</Text>
     </View>
   );
   ```

4. As a reference, working with the InterstitialAdView spot involves three components:

   - Bridging:
     - android/[views/InterstitialAdViewManager.java](./views/InterstitialAdViewManager.java)
     - android/[views/InterstitialAdView.java](./views/InterstitialAdView.java)
   - Managing events:
     - android/[Constants.java](./Constants.java)
   - UIManager:
     - src/[views/InterstitialAdView.tsx](./views/InterstitialAdView.tsx)

5. Example Code: [addInterstitialAdViewExample.tsx](./addInterstitialAdViewExample.tsx)

[Back to Top](#back-to-top)

</details>

---

### Example: Enable Mobile Messages: Push Notification

<details><summary>Click to expand</summary>
<a name="enable-mobile-messages-push-notification"></a>

## Prerequisites

- Generate React Native Firebase authentication key
- Set up Push Notification and Background capability

## Enable android application with Push Notification via SAS SDK

<!-- ### AppDelegate.h Configuration

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
   ``` -->

6. **To enable Rich Push Notification**

   Please refere to [Enable Mobile Messages: Rich Push Notification](#enable-mobile-messages-rich-push-notification) section.

7. **Enable Push Notification in React Native App**
   After apply iOS configuration via XCode, we can now able to add React Native

   ### Step 1: Import Required Modules

   ```typescript
   import {
     NativeEventEmitter,
     DeviceEventEmitter,
     Platform,
   } from 'react-native';
   ```

   <!-- ### Step 2: Initialize Mobile Messaging Event for iOS

   ```typescript
   let iOSMessagingEvent;
   if (SASMobileMessagingEvent != null) {
     iOSMessagingEvent = new NativeEventEmitter(SASMobileMessagingEvent);
   }
   ``` -->

   ### Step 2: Add Event Listeners

   Add the following code to ensure that event listeners are in place to handle both push notifications and in-app messages.

   ```typescript
   React.useEffect(() => {
     if (Platform.OS === 'android') {
       DeviceEventEmitter.addListener(Constants.MESSAGE_DISMISSED, () => {
         console.log('User dismissed the message');
         Toast.show('User dismissed message', Toast.SHORT);
       });
       DeviceEventEmitter.addListener(
         Constants.MESSAGE_OPENED,
         (obj: { [key: string]: string }) => {
           const link = obj['link'];
           const msg = 'User got in-app msg with link:' + link;
           Toast.show(msg, Toast.SHORT);
           if (link?.includes('diagnostic')) {
             navigate('Content', { link: link });
           }
         }
       );

       DeviceEventEmitter.addListener(
         Constants.MESSAGE_NOTIFICATION_LINK_RECEIVED,
         (link: string) => {
           if (link.includes('diagnostic')) {
             Toast.show(
               'User got push notification' + ' with link' + link,
               Toast.SHORT
             );

             // This event is for the listener in deep link to listen to
             emitter.emit('PushLink', { link: link });
           }
         }
       );
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

Configure React Native (Typescript)
Push Notifications

1. Open Integrated Terminal, cd to example folder, and type this command:
   npm install events
2. Find App.tsx in the example/src folder.
   52
3. Add these three imports:
   ```typescript
   import { SASMobileMessagingEvent, Constants } from 'mobilesdk-react-native';
   import { navigate, RootTabParameterList } from './RootNavigation';
   import { EventEmitter as EvtEmitter } from 'events';
   ```
   Note: RootNavigation.tsx was created in the same (src) folder. The file contains input parameter definitions of tab screens. The exported navigate is used in case navigation is not created yet to avoid crashes in the app.
4. Change the app type:

   ```typescript
   const App: React.FC<Props> = { notificationWithLink };
   ```

   Note: notificationWithLink is the parameter passed from native side when the app has not been running and tapping push notification starts the app.

5. Before the start of Appt definition, create an instance of event emitter.
   `typescript
  const emitter = new EvtEmitter();
`
   Note: The emitter will send event when push notification is received while the app is
   in the background. Listener will be set up in deep link in step 11 to listen for the
   event and navigate to the Diagnostic screen.
6. add an entry in src/Constants.tsx of the project (NOT in example folder):
   export const MESSAGE_NOTIFICATION_LINK_RECEIVED = "onNotificationLinkReceived";
7. Add this code to ensure that event listeners are in place to handle both push notifications and in-app messages:

```typescript
React.useEffect(() => {
// This happens when the app is not started yet.
//Tapping push notification starts the app.
//notificationWithLink is a parameter in the initial props passed from the native side.
if (notificationWithLink &&
notificationWithLink?.includes('diagnostics')) {
Toast.show('User got push notification with link' + notificationWithLink, Toast.SHORT);
setInitialTab('Diagnostics');
if (Platform.OS === 'android') {

  DeviceEventEmitter.addListener(Constants.MESSAGE_DISMISSED,() => {
    Toast.show('User dismissed message', Toast.SHORT);
  });
  DeviceEventEmitter.addListener(Constants.MESSAGE_OPENED,(obj: {[key: string]: string}) => {
    const link = obj['link'];
    const msg = 'User got in-app msg with link:' + link;
    Toast.show(msg, Toast.SHORT);
    if (link?.includes('diagnostic')) {
      navigate('Diagnostics', {link: link});
    }
  });
  DeviceEventEmitter.addListener(Constants.MESSAGE_NOTIFICATION_LINK_RECEIVED, (link: string) => {
  if (link.includes('diagnostic')) {
    Toast.show('User got push notification' +  ' with link' + link, Toast.SHORT);
    //This event is for the listener in deep link to listen
    emitter.emit('PushLink', {link: link})
    }
  });
}

return () => {
  DeviceEventEmitter.removeAllListeners();
  }
}, []);
```

9. Android only: Right after checkLocationPermission(), add this code to specify the tab to display for a push notification. In this example, the app is set to display
   the Diagnostics tab when push notification is received.

   Note: This step is only for Android because when a push notification is clicked by the user, the app restarts.

   ```typescript
   let tabName = 'Identity';
   let pushLink = '';
   if (notificationWithLink && notificationWithLink.includes('diagnostics')) {
     tabName = 'Diagnostics';
     pushLink = notificationWithLink;
   }
   ```

10. If you use CI360 Android SDK 1.80.2 or 1.80.3, step 9 is not needed. Instead, this and step 11 will set up for deep link. After checkLocationPermission() , add this
    object to set up the screen when push notification is received:

    ```typescript
    const config = {
      screens: {
        Diagnostics: 'diagnostics',
      },
    };
    ```

    Note: Diagnostics is one of the screen name in the example project, ‘diagnostics’ is the part in the action link: app://diagnostics

11. In <Tab.Navigator> add initialRouteName:

    ````typescript
    <Tab.Navigator initialRouteName={initialTab}
    ```
    ````

12. In <Tab.Screen> for Diagnostics, add initialParams:
    ```typescript
    <Tab.Screen
      name="Diagnostics"
      component={DiagnosticScreen}
      options={{ tabBarLabel: "diagnostics" }}
    />
    ```

In-App Messages
In-app messages are sent to devices by invoking addAppEvent, which is exposed in the React Native library.
In the example project, a screen is created for sending an in-app message event and receiving it. Find MessageScreen.tsx in example/src/screens.

1. In MessageScreen, add this import:

```typescript
import { addAppEvent } from 'mobile-sdk-react-native';
```

For other imports, please see the attachment.

2. In the <View> container, add this code:

```typescript
  <View style={styles.spot}>
  <TextInput style={styles.textInput}
  onChangeText={setSmallMsg} value={smallMsg}/>
  <CustomButton title='Send Small In-App'
  width={{width: 200}} onPress={() => {
  addAppEvent(smallMsg, null); }} />
  </View>

  <View style={styles.spacer} />
  <View style={styles.spot}>
  <TextInput style={styles.textInput}
  onChangeText={setLargeMsg} value={largeMsg} />
  <CustomButton title='Send Large In-App'
  width={{width: 200}} onPress={() => {
  addAppEvent(largeMsg, null); }} />
  </View>
```

Note: The initial smallMsg and largeMsg values are the small and large in-app message events names created in Design Center.
Test Push Notifications and In-App Messages
A SAS Customer Intelligence 360 user creates events, creatives, and tasks for push notifications and in-app messages.
Test Push Notifications
Push notifications can be tested by sending external events from Postman.

3. Start the app, log in and put the app in the background.
4. In SAS Customer Intelligence 360, navigate to General Settings. Under Content Delivery, select Diagnostics.
5. For ID type, select your device ID and click Submit Test. You should receive a test push notification on your device.
   When creating a push notification creative (and then using that creative in a push task)
   in SAS Customer Intelligence 360, if you have ‘diagnostic’ in the creative uri, clicking the
   notification brings the app to foreground and opens the diagnostic screen.
   Test In-App Messages
   To test in-app messages, select the Messages tab on the running app. Click the Send
   Small In-App button to open the small in-app message pop-up at the bottom of the
   screen. Click the Send Large In-App button to open the large in-app message pop-up at
   the center of the screen. Both message pop-ups have a Close (x) button. If a user clicks
   the button, a toast message briefly appears. The large in-app message pop-up has a
   button that opens the diagnostic screen.

[Back to Top](#back-to-top)

</details>

---

(Continue with other functionalities)
