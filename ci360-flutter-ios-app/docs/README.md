# Working with the Flutter iOS and CI360 Mobile SDK

Welcome to the Flutter SDK guide for the CI360 platform! This document is designed to provide you with a comprehensive understanding of how to effectively utilize our SDK with Flutter. We will walk you through usage examples and provide a comparison with the native SDK to enhance your understanding.

## Design Abstract
In our project, we've leveraged the power of Flutter SDK for iOS and Android to provide a flexible and efficient development experience. Here's an overview of how it works compared to the native SDK:

 - **Key Functions with Native SDK:** 
While we embrace the benefits of Flutter, it's important to note that the core functionality of our application still relies on the native SDKs for iOS and Android. These native SDKs provide the foundation for critical operations.

 - **Bridging with Flutter:** 
Flutter SDK serves as a bridge between our Dart code and the native modules. It facilitates seamless communication between the Dart world and the underlying native code. This bridging is essential for integrating native capabilities into our Flutter app.

 - **Dart Functions:**
Our application makes extensive use of Dart functions. These Dart functions are called from within our Flutter components/screens to interact with both the Flutter SDK and the underlying native SDKs. We will be building in a platform agnostic way but must implement native code and call that native code on each platform. If you're familiar with the Flutter development cycle, you should be familiar with this but you can find the information [Writing custom platform-specific code](https://docs.flutter.dev/platform-integration/platform-channels) where the Flutter documenation describe it in more detail for using method channels for each platform (iOS and Android)

This combination of native SDKs and Flutter SDK, along with Dart, enables us to build a cross-platform mobile application that leverages the strengths of both worlds while maintaining a high level of performance and extensibility.

## Installation

Before proceeding, please refer to the flutter cookbook found on the [CI360 Mobile SDK Developer Page](https://developer.sas.com/guides/customer-intelligence/sas-ci360-mobile-sdk.html). If you haven't completed this step yet, please refer to the installation guide for step-by-step instructions on setting up the SDK.

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
    - [Example: Working with Spots: Add an Interstitial Spot](#expand-working-with-spots-interstitials)
    - [Example: Enable Mobile Messages: Push Notification](#enable-mobile-messages-push-notification)
    - [Example: Reset the Mobile Device ID](#expand-reset-the-mobile-device-id)


## Framework Versions

State the versions of Native iOS and Flutter frameworks that you're using for these examples.

- Native iOS: iOS 12.4+
- Flutter: 3.13+

## Functionality Comparisons

### Example: Enable SDK internal Logging
<details><summary>Click to expand</summary>
<a name="expand-enable-sdk-internal-logging"></a>

This example illustrates how to set up SAS Collector and Logger in a Native iOS application. **Note: The setup for Native iOS and Flutter iOS projects is the same for this functionality.** You will need to modify your `AppDelegate.h` and `AppDelegate.m` files.

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

<details><summary>Click to expand</summary>
<a name="expand-return-the-mobile-sdk-version"></a>

This example provides guidance on how to obtain the SDK version in both native iOS using Objective-C and Flutter iOS using Dart.

## Native iOS Objective-C

To retrieve the SDK version in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
+(NSString*)sdkVersion;
```

## Flutter iOS Dart

To retrieve the SDK version in Flutter using Dart, follow these steps. We're going to use channels for our implementation which means we must create the required channels first. Remember to replace `ProjectName` or `Project Name` or `project_name` etc., with your own project's name

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<String?> getSDKVersion() {
    return MobileSdkFlutterPlatform.instance.getSDKVersion();
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<String> getSDKVersion() {
      throw UnimplementedError('getSDKVersion is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<String> getSDKVersion() async {
      return await methodChannel.invokeMethod('getSDKVersion');
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
   else if([call.method isEqualToString:@"getSDKVersion"]) {
    result([SASCollector getSDKVersion]);
   } 
   ```

5. In the screen you wish to use, you can generate a Future widget or getSDKVersion during the initState(). Initiate the string using a local variable and then use the function created earlier.

   ```Dart
   String _sdkVersion = 'Unknown';
   ```

   ```Dart
   void initState() {
      _sdkVersion = getSDKVersion();
      super.initState();
   }
   ```

6. Example Code: [sdkVersionExample.dart](./example_screenssdkVersionExample.dart)

[Back to Top](#back-to-top)
</details>

---

### Example: Retrieving the Session Binding Parameter

<details><summary>Click to expand</summary>
<a name="expand-return-session-id"></a>

This example provides guidance on how to obtain the session ID in both native iOS using Objective-C and Flutter iOS using Dart.

## Native iOS Objective-C

To retrieve the session ID in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
NSString* sessionParamter = [SASCollector getSessionBindingParamter]; //_ci_=<device_id>*<session_id>*<heartbeat>*<timestamp>
```

## Flutter iOS Dart

To retrieve the Session ID in Flutter using Dart, follow these steps:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<String?> getSessionBindingParameter() {
    return MobileSdkFlutterPlatform.instance.getSessionBindingParameter();
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<String> getSessionBindingParameter() {
      throw UnimplementedError('getSessionBindingParameter is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<String> getSessionBindingParameter() async {
      return await methodChannel.invokeMethod('getSessionBindingParameter');
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
   else if([call.method isEqualToString:@"getSessionBindingParameter"]) {
    result([SASCollector getSessionBindingParameter]);
   } 
   ```

5. In the screen you wish to use, you can generate the value onPressed or use a Future widget in order to properly set it up. Additionally you can use Future widget or initState sections to get the information.

   ```Dart
   ElevatedButton(
      style: ElevatedButton.styleFrom(
            fixedSize: const Size(250, 40)),
      onPressed: () {
         widget.mobileSdkFlutter
            .getSessionBindingParameter()
            .then((param) => setState(() {
                  bindingParam = param;
                  }));
      },
      child: const Text('Check Binding Param'),
   ),
   ```

6. Example Code: [sessionIdExample.dart](./example_screenssessionIdExample.dart)

[Back to Top](#back-to-top)
</details>


---

### Example: Retrieving the Device ID

<details><summary>Click to expand</summary>
<a name="expand-return-session-id"></a>

This example provides guidance on how to obtain the Device ID in both native iOS using Objective-C and Flutter iOS using Dart.

## Native iOS Objective-C

To retrieve the Device ID in native iOS using Objective-C, you can use the following method:

```objective-c
// Objective-C
[SASCollector deviceId];
```

## Flutter iOS Dart

To retrieve the Device ID in Flutter using Dart, follow these steps:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<String?> getDeviceId() {
    return MobileSdkFlutterPlatform.instance.getDeviceId();
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<String> getDeviceId() {
      throw UnimplementedError('getDeviceId is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<String> getDeviceId() async {
      return await methodChannel.invokeMethod('getDeviceId');
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
   else if([call.method isEqualToString:@"getDeviceId"]) {
    result([SASCollector getDeviceId]);
   } 
   ```

5. In the screen you wish to use, you can generate the value onPressed or use a Future widget in order to properly set it up. Additionally you can use Future widget or initState sections to get the information.

   ```Dart
   ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
      onPressed: () {
         widget.mobileSdkFlutter
            .getDeviceId()
            .then((device) => setState(() {
                  deviceId = device;
                  }));
      },
      child: const Text('Get Device ID'))
   ``````
   
6. Example Code: [deviceIdExample.dart](./example_screensdeviceIdExample.dart)

[Back to Top](#back-to-top)
</details>

---

### Example: Track User Navigation in the App

<details><summary>Click to expand</summary>
<a name="expand-track-user-navigation-in-the-app"></a>

This example illustrates the process of using the `newPage` API from the Flutter SDK to track user navigation within your app.

**Using the Native iOS SDK:**

```objective-c
[SASCollector newPage:@"outdoor/fishing/livebait"];
```

**Using Flutter with Dart:**

Follow these steps to monitor user navigation within your app:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<String?> newPage() {
    return MobileSdkFlutterPlatform.instance.newPage(uri);
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<void> newPage(String uri) {
    throw UnimplementedError('newPage has not been implemented.');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<void> newPage(String uri) async {
      return await methodChannel.invokeMethod('newPage', {'uri': uri});
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
   else if ([call.method isEqualToString:@"newPage"]) {
    [SASCollector newPage:call.arguments[@"uri"]]; 
    result(nil);   
   }
   ```

5. In the screen you wish to use, you can generate the value onPressed or use a Future widget in order to properly set it up. Additionally you can use initState sections to get the information.

   ```Dart
   @override
   void initState() {
      newPage(/home/profile/address);
      super.initState();
   }
   ``````
   
6. Example Code: [newPageExample.dart](./example_screensnewPageExample.dart)

[Back to Top](#back-to-top)   
</details>


---

### Example: Bind a Device ID to and Identity

<details><summary>Click to expand</summary>
<a name="expand-bind-a-device-id-to-and-identity"></a>

This example demonstrates how to use the `identity:withType:completion:` API from the Flutter SDK to associate a user's identity with a device ID. This association is performed after the user signs in to your app, allowing you to uniquely identify the user. The `type` parameter specifies the type of identity (customer ID or login), while the `value` parameter holds the corresponding identifier. The supported identity types are `SASCOLLECTOR_IDENTITY_TYPE_CUSTOMER_ID` and `SASCOLLECTOR_IDENTITY_TYPE_LOGIN`, which are constants defined in `SASCollectorEvents.h`.

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

**Using Flutter with Dart:**

Follow these steps to implement identity:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<bool> identity(String value, String type) {
    return MobileSdkFlutterPlatform.instance.identity(value, type);
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<bool> identity(String value, String type) {
    throw UnimplementedError('identity is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<bool> identity(String value, String type) async {
      return await methodChannel
         .invokeMethod('identity', {'value': value, 'type': type});
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
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
   ```

5. In the screen you wish to use, you can setup a screen that processes it and errors in events of failures

   ```Dart
   ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 40),
          ),
          onPressed: () {
            widget.mobileSdkFlutter.identity(identityTextFieldController.text, _dropdownValue).then((success) => {
                  if (success)
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return DetailsPage(identityTextFieldController.text, widget.mobileSdkFlutter);
                      }))
                    }
                  else
                    {
                      showDialog(
                          context: context,
                          builder: (_) => const AlertDialog(
                                title: Text("Error"),
                                content: Text("Login failed."),
                              ))
                    }
                });
          },
          child: const Text("Login"),
   )
   ```
   
6. Example Code: [identityExample.dart](./example_screensidentityExample.dart)

[Back to Top](#back-to-top)
</details>


---

### Example: Detach Identity from Device

<details><summary>Click to expand</summary>
<a name="expand-detach-identitiy-from-device"></a>

Use the `detachIdentity` method to allow users to sign out from your app. This action:

- Disconnects the device from the user's current identity, stopping personalized push notifications.
- Generates new session and focus events.
  
**Using the Native iOS SDK:**

```objective-c
+(void)detachIdentity:(void(^)(bool))completionHandler
```

You can also suspend data collection and detach identity together using `shutdownAndDetachIdentity`. To reattach the device, use the `identity` method. To resume collection, call `[SASCollector initializeCollection];`.

**Using Flutter with Dart:**

Follow these steps to detach Identity from a user:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<bool> detachIdentity() {
    return MobileSdkFlutterPlatform.instance.detachIdentity();
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<bool> detachIdentity() {
    throw UnimplementedError('detachIdentity is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<bool> detachIdentity() async {
      return await methodChannel.invokeMethod('detachIdentity');
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
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
   ```

5. In the screen you wish to use, you can generate the value onPressed or use a Future widget in order to properly set it up. Additionally you can use Future widget or initState sections to get the information.

   ```Dart
   ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(250, 30),
            ),
            onPressed: () {
              mobileSdkFlutter.detachIdentity().then((success) => {
                    if (success) //navigate back to previous screen if detachIdentity is successful
                      {Navigator.of(context).pop()} 
                    else //display error if detachIdentity is unsuccessful
                      {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text("Error"),
                                  content:
                                      const Text("Detach identity failed."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK')),
                                  ],
                                ))
                      }
                  });
            },
            child: const Text('Detach Identity'))
   ```

5. Example Code: [detachIdentityExample.dart](./example_screensdetachIdentityExample.dart)

[Back to Top](#back-to-top)
</details>


---

### Example: Working with Events

<details><summary>Click to expand</summary>
<a name="expand-working-with-events"></a>

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

**Using Flutter with Dart:**

Follow these steps:

1. Create a function in `project_name_flutter.dart`

   ```Dart
   Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) {
    return MobileSdkFlutterPlatform.instance.addAppEvent(eventKey, data);
   }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) {
    throw UnimplementedError('addAppEvent is not implemented');
   }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
   Future<void> addAppEvent(String eventKey, Map<String, dynamic>? data) async {
      return await methodChannel.invokeMethod(
         'addAppEvent', <String, dynamic>{'eventKey': eventKey, 'data': data});
   }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart
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
   ```

5. In the screen you wish to use, you can generate the value onPressed or use a Future widget in order to properly set it up. Additionally you can use Future widget or initState sections to get the information.

   ```Dart
   ElevatedButton(
      style: ElevatedButton.styleFrom(
         fixedSize: const Size(250, 40)),
      onPressed: () {
         if (smallInAppMsgController.text.isNotEmpty) {
         widget.mobileSdkFlutter
               .addAppEvent(smallInAppMsgController.text, null);
         }
      },
      child: const Text('Get In-App Msg'))
   ```

6. Example Code: [addAppEventExample.dart](./example_screensaddAppEventExample.dart)

[Back to Top](#back-to-top)
</details>


---
### Example: Working with Spots: Add an Inline Spot

<details><summary>Click to expand</summary>
<a name="expand-working-with-spots-inline"></a>

When defining an `Inline` spot in a Flutter project, the default UIKit is called and then UI takes over

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
    myAd1.spotID = @"native_spot_name";
    
    [self.view addSubview:myAd1];
    [myAd1 load];
    ```

**Using Flutter with Dart:**

Follow these steps:

1. Ensure that the files in `ios\Classes\views\` exists in your iOS project in the same folder from this or the example project files
   
   * BaseAdViewController.h
   * BaseAdViewController.h
   * BaseAdViewController.m
   * InlineAdViewController.h
   * InlineAdViewController.m
   * InlineAdViewFactory.h
   * InlineAdViewFactory.m

2. Ensure to include these in your project_name_sdk.dart file in `ios\lib\views`

   ```Dart
   export 'views/sas_collector_inline_ad_view.dart';
   export 'views/sas_collector_inline_ad_view_controller.dart';
   ```

3. Create a widget for the in-line spot, you can see the code below or an example in `example_screens\addInlineAdViewExample.dart`
  
   ```Dart
    SASCollectorInlineAdView(
      spotID: 'SPOT_ID_HERE',
      onCreated: onInlineAdCreated,
   )
   ```

4. Example Code: [addInlineAdViewExample.tsx](./example_screens/addInlineAdViewExample.dart)

[Back to Top](#back-to-top)
</details>

---
### Example: Working with Spots: Add an Interstitial Spot

<details><summary>Click to expand</summary>
<a name="expand-working-with-spots-interstitials"></a>

When utilizing the `Interstitial` spot in a Flutter project, it should be initilized during the screen display, similar to Inline Spot which requires the spotID.

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

**Using Flutter with Dart:**

Follow these steps:

1. Ensure that the files in `ios\Classes\views\` exists in your iOS project in the same folder from this or the example project files
   
   * BaseAdViewController.h
   * BaseAdViewController.m
   * InterstitialAdViewController.h
   * InterstitialAdViewController.m
   * InterstitialAdViewFactory.h
   * InterstitialAdViewFactory.m

2. Ensure to include these in your project_name_sdk.dart file in `ios\lib\views`

   ```Dart
   export 'views/sas_collector_interstitial_ad_view.dart';
   export 'views/sas_collector_interstitial_ad_view_controller.dart';
   ```

3. In your screen/view add some code to deal with interstitial ads on create so that the SDK can properly track interactions and display
  
  ```Dart
    void onInterstitialAdCreated(
      SASCollectorInterstitialAdViewController controller) {
    interstitialAdController = controller;
    interstitialAdController.onLoadedHandler = () {
      print('onLoadedHandler is overriden on the client side');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    };

    interstitialAdController.onDefaultLoadedHandler = () {
      print('onDefaultLoadedHandler is overriden on the client side');
    };
    interstitialAdController.onLoadFailedHandler = () {
      print('onLoadFailedHandler is overriden on the client side');
    };
    interstitialAdController.onExpandFinishedHandler = () {
      print('onExpandFinishedHandler is overriden on the client side');
    };
    interstitialAdController.onActionFinishedHandler = () {
      print('actionFinishedHandler is overriden on the client side');
    };
    interstitialAdController.onClosedHandler = () {
      print("The closedHandler is overriden on the client side");
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
      Fluttertoast.showToast(
        msg: "The interstitial ad is closed by user",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18,
      );
    };
  }
    ```

4. Invoke the interstitial ad either through a button press or another function in the app

   ```Dart
   interstitialAdController.showAd();
   ```
   and 
   ```Dart
   SASCollectorInterstitialAdView(
      spotID: 'SPOT_ID_HERE',
      onCreated: onInterstitialAdCreated
      )
   ```

5. Example Code: [addInlineAdViewExample.tsx](./example_screens/addInterstitialAdViewExample.dart)
[Back to Top](#back-to-top)
</details>

### Example: Working with Spots: Add a creative only spot

<details><summary>Click to expand</summary>
<a name="creative-only-spot"></a>

The mobile sdk allows you to retrieve a creative only spot while also reporting impressions to CI360.

## Prerequisites
- Create a spot in the CI360 interface using JSON, HTML, or Text as the creative.
- Build functionatily in CI360 code to consume the creative

## Native iOS Objective-C

   ```objective-c
   @interface YourViewController : UIViewController  <SpotDataHandler >

   @implementation YourViewController
   //call below API in a method
   [SASCollector loadSpotData:@"your spot id" withCompletionHandler:self];

   If you have set attributes for your spot:
   NSMutableDictionary *yourSpotMap = [NSMutableDictionary dictionary];
      [yourSpotMap setObject:@"your value" forKey:@"your attribute"];
      
   
   [SASCollector loadSpotData:@" your spot id " withAttributes: yourSpotMap withCompletionHandler:self];

   //Put below SpotDataHandler methods in SpotDataHandler conforming YourViewController 
   - (void)dataForSpotId:(NSString * _Nonnull)spotId withContent:(NSString * _Nonnull)content {
            SLogInfo(@"content");
         [SASCollector registerSpotViewableWith:spotId];
   }
   
   - (void)failureForSpotId:(NSString * _Nonnull)spotId withErrorCode:(long)errorCode andErrorMessage:(NSString * _Nonnull)errorMessage {
      
      SLogInfo(@"errorCode %ld", errorCode);
      SLogInfo(@"errorMessage %ld", errorMessage);
   }
   
   - (void)noDataForSpotId:(NSString * _Nonnull)spotId {
      SLogInfo(@"There is no spot data");
   }
   ```

## Flutter iOS Dart

To retrieve the Device ID in Flutter using Dart, follow these steps:

1. Create a function in `project_name_flutter.dart`

   ```Dart
  Future<String> loadSpotData(String spotId, Map<String, dynamic>? attributes) {
    return MobileSdkFlutterPlatform.instance.loadSpotData(spotId, attributes);
  }

  Future<void> registerSpotViewable(String spotId) {
    return MobileSdkFlutterPlatform.instance.registerSpotViewable(spotId);
  }

  Future<void> registerSpotClicked(String spotId) {
    return MobileSdkFlutterPlatform.instance.registerSpotClicked(spotId);
  }
   ```

2. Create a default function in `project_name_flutter_platform.dart` file for when it isn't properly implemented for a specific platform

   ```Dart
   Future<String> loadSpotData(String spotId, Map<String, dynamic>? attributes) {
    throw UnimplementedError('loadSpotData is not implemented');
  }

  Future<void> registerSpotViewable(String spotId) {
    throw UnimplementedError('registerSpotViewable is not implemented');
  }

  Future<void> registerSpotClicked(String spotId) {
    throw UnimplementedError('registerSpotClicked is not implemented');
  }
   ```

3. Setup a method channel in the `project_name_method_channel.dart`

   ```Dart
   @override
  Future<String> loadSpotData(
      String spotId, Map<String, dynamic>? attributes) async {
    return await methodChannel.invokeMethod(
        'loadSpotData', {'spotId': spotId, 'attributes': attributes});
  }

  @override
  Future<void> registerSpotViewable(String spotId) async {
    return await methodChannel
        .invokeMethod('registerSpotViewable', {'spotId': spotId});
  }

  @override
  Future<void> registerSpotClicked(String spotId) async {
    return await methodChannel
        .invokeMethod('registerSpotClicked', {'spotId': spotId});
  }
   ```

4. Implement the function in `ProjectNameFlutterPlugin.m`

   ```Dart 
  } else if([call.method isEqualToString:@"loadSpotData"]) {
      NSString *spotId = call.arguments[@"spotId"];
      NSDictionary *attributes = call.arguments[@"attributes"];
      
      NSString *callId = [[NSUUID UUID] UUIDString];
      __block SasSpotDataHandler *handler = nil;
      handler = [[SasSpotDataHandler alloc] initWithFlutterResult:result cleanup:^{
          [self.sasSpotDataHandlers removeObjectForKey:callId];
          handler = nil;
      }];
      self.sasSpotDataHandlers[callId] = handler;
      
      if (attributes != nil && ![attributes isKindOfClass:[NSNull class]]) {
          [SASCollector loadSpotData:spotId withAttributes:attributes withCompletionHandler:handler];
      } else {
          [SASCollector loadSpotData:spotId withCompletionHandler:handler];
      }
      
  } else if([call.method isEqualToString:@"registerSpotViewable"]) {
      NSString *spotId = call.arguments[@"spotId"];
      [SASCollector registerSpotViewableWith:spotId];
      result(nil);
  } else if ([call.method isEqualToString:@"registerSpotClicked"]){
      NSString *spotId = call.arguments[@"spotId"];
      [SASCollector registerSpotClickWith:spotId];
      result(nil);
   ```

5. In the screen you wish to use, you can create a widget to use the data, depending on the type of data returned (JSON/HTML/Text). An example file is given below.
   
6. Example Code: [creativeOnlySpot.dart](./example_screens/creativeOnlySpot.dart)

[Back to Top](#back-to-top)
</details>

---
### Example: Enable Mobile Messages: Push Notification

<details><summary>Click to expand</summary>
<a name="enable-mobile-messages-push-notification"></a>

The mobile messaging in SAS SDK captures the notification and passes it through setSASMessagingDelagate2. In Flutter we will setup mobile messaging almost entirely through

## Prerequisites
- Generate APNS authentication key
- Set up Push Notification and Background capability in XCode


## Enable iOS application with Push Notification via SAS SDK

### AppDelegate.h Configuration

Replace the content in `AppDelegate.h` with the following code:

   ```objective-c
   #import <Flutter/Flutter.h>
   #import <UIKit/UIKit.h>
   #import <UserNotifications/UserNotifications.h>
   #import <SASCollector/SASCollector.h>

   @interface AppDelegate : FlutterAppDelegate<UIApplicationDelegate, UNUserNotificationCenterDelegate, SASMobileMessagingDelegate2>
   @end
   ```

### AppDelegate.m Configuration

1. **Add Imports**

   Add these imports for SAS CI360 SDK:

   ```objective-c
   #import <SASCollector/SASCollector.h>
   #import <SASCollector/SASLogger.h>
   #import <mobile-sdk-Flutter/SASMobileMessagingEvent.h>
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

---
### Example: Enable Mobile Messages: Rich Push Notification

<details><summary>Click to expand</summary>
<a name="enable-mobile-messages-rich-push-notification"></a>

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

   This will enable rich push notifications for your iOS Flutter application. The guide now includes the configuration for `AppDelegate.h`, `AppDelegate.m`, and rich push notifications.

[Back to Top](#back-to-top)
</details>

---
(Continue with other functionalities)
