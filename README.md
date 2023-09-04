# Functionality Comparison between Native iOS and React Native for CI360 iOS SDK

## Overview

This repository aims to help developers understand the translation of various functionalities from Native iOS to React Native. This is particularly useful if you're well-versed in Native iOS development and are considering or starting to work with React Native.

## Table of Contents

1. [Installation](#installation)
2. [Framework Versions](#framework-versions)
3. [Functionality Comparisons](#functionality-comparisons)
    - [Example 1: Enable SDK Internal Logging](#example-1-enable-sdk-internal-logging)
    - [Example 2: Return the Mobile SDK Version](#example-2-return-the-mobile-sdk-version)
    - [Example 3: Accessing Device Features](#example-3-accessing-device-features)
    - ...
4. [Resources](#resources)
5. [Contributing](#contributing)

## Installation

Provide instructions on how to clone your repository and install any dependencies so that they can run the examples.

```bash
# Installation steps
```

## Framework Versions

State the versions of Native iOS and React Native frameworks that you're using for these examples.

- Native iOS: iOS 12.4+
- React Native: 0.71+

## Functionality Comparisons

### Example: Enable SDK internal Logging

**Note: The setup for Native iOS and React Native iOS projects is the same for this functionality. **

This example illustrates how to set up SAS Collector and Logger in a Native iOS application. You will need to modify your `AppDelegate.h` and `AppDelegate.mm` files.

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
Note: The setup for Native iOS and React Native iOS projects is the same for this functionality.


---

### Example 2 - Return the Mobile SDK Version

This example outlines how to retrieve the SDK version in both native iOS Objective-C and React Native iOS TypeScript using the example provided.

## Native iOS Objective-C

In native iOS using Objective-C, you can retrieve the SDK version using the following method:

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

---

### Example 3: Accessing Device Features

**Native iOS - Swift**

```swift
// Swift code for accessing device features like the camera
```

**React Native - JavaScript**

```javascript
// JavaScript code for accessing device features like the camera
```

---

(Continue with other functionalities)
