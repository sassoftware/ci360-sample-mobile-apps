# React-Native SDK Guide and Comparison

Welcome to the React-Native SDK guide for our platform! This document is designed to provide you with a comprehensive understanding of how to effectively utilize our React-Native SDK. We will walk you through usage examples and provide a comparison with the native SDK to enhance your understanding.

## Installation

Before proceeding, ensure that you have successfully installed the React-Native SDK [installation guide](link-to-installation-guide). If you haven't completed this step yet, please refer to the installation guide for step-by-step instructions on setting up the SDK.


## Table of Contents

1. [Framework Versions](#framework-versions)
2. [Functionality Comparisons](#functionality-comparisons)
    - [Example 1: Enable SDK Internal Logging](#example-1-enable-sdk-internal-logging)
    - [Example 2: Return the Mobile SDK Version](#example-2-return-the-mobile-sdk-version)
    - [Example 3: Track User Navigation in the Apps](#example-3-treack-user-navigation-in-the-apps)
    - ...


## Framework Versions

State the versions of Native iOS and React Native frameworks that you're using for these examples.

- Native iOS: iOS 12.4+
- React Native: 0.71+

## Functionality Comparisons

### Example: Enable SDK internal Logging
<details><summary>Click to expand</summary>

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

</details>



---

### Example 2 - Return the Mobile SDK Version
<details><summary>Click to expand</summary>
This example outlines how to retrieve the SDK version in both native iOS Objective-C and React Native iOS TypeScript using the example provided.

## Native iOS Objective-C

In our native iOS using Objective-C, you can retrieve the SDK version using the following method:

```objective-c
// Objective-C
+(NSString*)sdkVersion;
```

## React Native iOS TypeScript

In React Native using TypeScript, follow these steps to retrieve the SDK version:

1. Import required modules and functions:
   
   ```typescript
   import React from 'react';
   import { Text, Platform } from 'react-native';
   import { getSdkVersion } from 'react-native-mobile-sdk';
   ```

2. In your component, set up state to hold the SDK version:

   ```typescript
   const [sdkVersion, setSdkVersion] = React.useState<string>('');
   ```

3. Utilize the `useEffect` hook to fetch the SDK version and update the state:

   ```typescript
   React.useEffect(() => {
       getSdkVersion((version: string) => {
           setSdkVersion(version);
       });
   }, []);
   ```

4. Render the SDK version in your component's `return` statement:

   ```typescript
   return (
       <Text>{Platform.OS} SDK version: {sdkVersion}</Text>
   );
   ```

5. As Reference, in our react-native sdk, the `getSdkVersion` function is implemented in the `react-native-mobile-sdk.mm` file, as follows:

   ```objective-c
   RCT_EXPORT_METHOD(getSdkVersion:(RCTResponseSenderBlock)callback)
   {
      NSString* sdkVersion = [SASCollector sdkVersion];
      callback(@[sdkVersion]);
   }
   ```

</details>


---

### Example 3: Track User Navigation in the App
<details><summary>Click to expand</summary>
This example outlines how to call the newPage API via React Native SDK

**Native iOS SDK **

```objective-c
[SASCollector newPage:@"outdoor/fishing/livebait"];
```

In React Native using TypeScript, follow these steps to retrieve the SDK version:

1. Import required modules and functions:
   
   ```typescript
   import React from 'react';
   import { newPage } from 'react-native-mobile-sdk';
   ```

2. Trigger newPage API in your component's `return` statement:

   ```typescript
   return (
      newPage('outdoor/fishing/livebair');
   );
   ```

3. As Reference, in our react-native sdk, the `newPage` function is implemented in the `react-native-mobile-sdk.mm` file, as follows:

   ```objective-c
   RCT_EXPORT_METHOD(newPage:(NSString*)uri)
   {
      [SASCollector newPage:uri];
   }
   ```

</details>



---

(Continue with other functionalities)
