# Mobile React Native SDK

This repository contains a React Native SDK for mobile applications. The SDK provides functionalities for interacting with a mobile Spot, handling push notifications, and more.

## Getting Started

Follow the steps below to set up and integrate the Mobile React Native SDK into your project.

### Step 1: Installation

1. Clone this repository and navigate to the SDK directory:

   ```bash
   npx creat-react-native-library mobile-react-native-sdk
   cd mobile-react-native-sdk
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Navigate to the example directory:

   ```bash
   cd example
   ```

4. Install example project dependencies:

   ```bash
   bundle install
   npm install
   ```

5. Navigate to the iOS directory and install iOS dependencies:

   ```bash
   cd ios
   pod install
   cd ..
   ```

6. Run the example project in the iOS simulator:

   ```bash
   npx react-native run-ios
   ```

   Ensure that the simulator opens and displays the content correctly.

### Step 2: Integration

1. Copy the necessary files and directories to your project root:

   From `{root}/mobile-react-native-sdk/`:
   - Copy `src/Constants.tsx`, `src/index.tsx`, `views/`.

   From `{root}/mobile-react-native-sdk/ios`:
   - Copy `ios/Constants.h`, `ios/Constants.m`, `ios/SASMobileMessagingEvent.h`, `ios/SASMobileMessagingEvent.m`, `ios/views/`, `ios/SASCollector.xcframwork/`.

   Edit `MobileReactNativeSdk.h`:
   - Add `#import <SASCollector/SASCollector.h>` and `#import <Foundation/Foundation.h>`.

   Edit `MobileReactNativeSdk.mm`:
   - Add required methods and functionality.

2. In the example project:

   From `{root}/mobile-react-native-sdk/example`:
   - Copy `src/App.tsx`, `src/RootNavigation.tsx`, `src/compontents/`, `src/screens/`.

   In Xcode:

   - Add `SASCollector` framework.
   - Add `Fonts/FontAwesome.ttf`.
   - Edit `AppDelegate.h`: Add `#import <SASCollector/SASCollector.h>`.
   - Edit `AppDelegate.mm`: Add imports, configure logging, and initialize collection.

   Run `pod install` from the example directory.

   Run the example project in the iOS simulator to ensure that the SDK components are integrated correctly and functional.

### Step 3: Push Notifications

1. In Xcode:

   - Add push notification capabilities.
   - Add background modes: background fetch, remote notifications, background processing.

2. Copy `AppDelegate.h` and `AppDelegate.mm` to your project.

3. Create a target named `ReactNativeRichPush` for push notification services.

4. Copy `NotificationService.mm` to the new target.

## Checkpoints

- After Step 1: Ensure the simulator opens and displays the content correctly (21).
- After Step 2: Ensure the SDK components are integrated and functional (21 / sdkVersion / mobile Spot).
- After Step 3: Verify push notifications and background modes.

Feel free to reach out if you encounter any issues or need further assistance.
```

Replace `<repository_url>` with the actual URL of your GitLab repository. This README should provide clear instructions for setting up and integrating the Mobile React Native SDK into your project. Make sure to add any additional details or explanations as needed based on your project's requirements.
