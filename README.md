# Working with the react-native iOS Mobile SDK

Welcome to the React-Native SDK guide for our platform! This document is designed to provide you with a comprehensive understanding of how to effectively utilize our React-Native SDK. We will walk you through usage examples and provide a comparison with the native SDK to enhance your understanding.

## Installation

Before proceeding, ensure that you have successfully installed the React-Native SDK [installation guide](link-to-installation-guide). If you haven't completed this step yet, please refer to the installation guide for step-by-step instructions on setting up the SDK.


## Table of Contents
<a name="back-to-top"></a>
1. [Framework Versions](#framework-versions)
2. [Functionality Comparisons](#functionality-comparisons)
    - [Example: Enable SDK Internal Logging](#expand-example-enable-sdk-internal-logging)
    - [Example: Return the Mobile SDK Version](#expand-return-the-mobile-sdk-version)
    - [Example: Track User Navigation in the App](#expand-track-user-navigation-in-the-app)
    - [Example: Bind a Device ID to and Identity](#expand-bind-a-device-id-to-and-identity)
    - [Example: Detach Identitiy from Device](#expand-detach-identitiy-from-device)
    - [Example: Working with Events](#expand-working-with-events)
    - [Example: Reset the Mobile Device ID](#expand-reset-the-mobile-device-id)


## Framework Versions

State the versions of Native iOS and React Native frameworks that you're using for these examples.

- Native iOS: iOS 12.4+
- React Native: 0.71+

## Functionality Comparisons

### Example: Enable SDK internal Logging
<details><summary>Click to expand</summary>
<a name="expand-example-enable-sdk-internal-logging"></a>

This example illustrates how to set up SAS Collector and Logger in a Native iOS application. **Note: The setup for Native iOS and React Native iOS projects is the same for this functionality.** You will need to modify your `AppDelegate.h` and `AppDelegate.mm` files.

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

#### Step 2: Update AppDelegate.mm

In your `AppDelegate.mm` file, you will need to import two headers: `SASCollector.h` and `SASLogger.h`.

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

Locate the `didFinishLaunchingWithOptions:` method in your `AppDelegate.mm` and add the following line to set the SAS Logger level.

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

### Example: Retrieving the Mobile SDK Version

<details><summary>Click to expand</summary>
<a name="#expand-return-the-mobile-sdk-version"></a>

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

[Back to Top](#back-to-top)
</details>


---

### Example: Track User Navigation in the App

<details><summary>Click to expand</summary>
<a name="#expand-track-user-navigation-in-the-app"></a>

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

[Back to Top](#back-to-top)   
</details>


---

### Example: Bind a Device ID to and Identity

<details><summary>Click to expand</summary>
<a name="#expand-bind-a-device-id-to-and-identity"></a>

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
   import { View, Button } from 'react-native';
   import { identity } from 'mobile-sdk-react-native';
   ```

2. Set up state in your component to hold the login type and user ID:

   ```typescript
   const [loginType, setLoginType] = React.useState<string>('');
   const [userId, setUserId] = React.useState<string>('');
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

[Back to Top](#back-to-top)
</details>


---

### Example: Detach Identity from Device

<details><summary>Click to expand</summary>
<a name="#expand-detach-identitiy-from-device"></a>

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

[Back to Top](#back-to-top)
</details>


---

### Example: Working with Events

<details><summary>Click to expand</summary>
<a name="#expand-working-with-events"></a>

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
      <TextInput onChangeText={setCustomEventKey} value={customEventKey} style={{ height: 40, width: 200, borderWidth: 1 }} />
      <Button title="Submit Custom Event" onPress={() => {
        addAppEvent(customEventKey, null);
      }} />
    </View>
   );
   ```

5. As a reference, the `addAppEvent` function is implemented in the `mobile-sdk-react-native.mm` file of our React Native SDK:

   ```objective-c
    RCT_EXPORT_METHOD(addAppEvent: (NSString*)eventKey data:(NSDictionary*)data){
        [SASCollector addAppEvent:eventKey data:data];
    }
   ```

[Back to Top](#back-to-top)
</details>


---
(Continue with other functionalities)
