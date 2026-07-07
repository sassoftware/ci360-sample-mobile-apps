# 360FlutterApp

This is a sample Flutter Application that will demonstrate the integration with the SAS Customer Intelligence 360 Mobile SDK. It implements most of the SDK features that should help a Flutter App Developer understand the implementation details and concepts of these features. 

## Working with the Android Mobile SDK for Flutter

Welcome to the Flutter Android SDK guide for 360! This document is designed to provide you with a comprehensive understanding of how to effectively utilize the Flutter Android SDK. We will walk you through usage examples and provide a comparison with the native SDK to enhance your understanding.

## Design Abstract

In this project, we've leveraged the digital marketing capabilities of the 360 SDK for Flutter Android to provide working examples of how the SDK feaures can be used to full potential for specific use cases. 

## Installation

Before we get started, make sure you have embedded the Flutter for Android 360 Mobile SDK in your Mobile Application. If you haven't, please refer to this [installation guide](https://support.sas.com/documentation/onlinedoc/ci/ci360-mobile-sdks/ci360-flutter-cookbook.pdf) for step-by-step instructions on setting up the SDK.

## Table of Contents
<details><summary>Click to expand</summary>
<a name="back-to-top"></a>

- [Framework Version](#framework-version)
- [Naming Convention](#naming-convention)
- [Folder Heirarchy](#folder-heirarchy)
- [Getting started - SDK Integration](#getting-started)
   - [Creating a Flutter Plug-in Project & Template](#create-template)
   - [Embed 360 SDK libraries](#embed-libraries)
   - [Default Functionality](#default-functionality)
   - [Configuring Dart](#configure-dart)
   - [Configuring Android](#configure-android)
   - [Configuring the Flutter App](#configure-flutter)
- [Functionality Comparisons](#sdk-features) 
   - [SDK Features](#sdk-features)
     - [Sending Events](#sending-events)
     - [Working with Mobile Spots](#mobile-spots)
       - [Inline Ad Spot](#inline-spot)
       - [Interstitial Ad Spot](#interstitial-spot)
     - [Location Functionality (Geofence/Beacon)](#location-functionality)
     - [Implement Mobile Messaging](#mobile-messaging)
     - [Get App Version](#get-app-version)
     - [Reset Device ID](#reset-deviceid)
     - [Get SDK Version](#get-sdk-version)
     - [Disable the SDK](#disable-sdk)

</details>

### Framework Version
<details><summary>Click to expand</summary>
<a name="framework-version"></a>

The following language/platform versions were used to develop this project: 

        Flutter SDK       : 3.3.10
        360 Mobile SDK    : 1.80.3
        Kotlin version    : 1.6.10
        Android API Level : 34

[Back to Top](#back-to-top)
</details>

### Naming Convention
<details><summary>Click to expand</summary>
<a name="naming-convention"></a>

**com.ronald.my_first_flutter_app** refers to the package name for this example Flutter project. For Android, the name is the package ID as mentioned in the AndroidManifest.xml.

[Back to Top](#back-to-top)
</details>

### Folder Heirarchy
<details><summary>Click to expand</summary>
<a name="folder-heirarchy"></a>

        Project root folder: ci360-flutter-android-app
        Flutter code: ci360-flutter-android-app\libs
        360 Mobile SDK jar: ci360-flutter-android-app\android\app\libs
        Java code: ci360-flutter-android-app\mobile_sdk_flutter\android\src\main\java\com\sas\SASIA\mobile_sdk_flutter

[Back to Top](#back-to-top)
</details>

### Getting Started - SDK Integration
<details><summary>Click to expand</summary>
<a name="getting-started"></a>


#### Creating a Flutter Plug-in Project & Template
<details><summary>Click to expand</summary>
<a name="create-template"></a>

A Flutter app is built using Dart, a programming language. Flutter does not read native Android (Java or Kotlin) and iOS (Objective-C or Swift) languages. To enable you to use the Android and iOS SAS Customer Intelligence 360 mobile SDKs, the easiest approach is to build a wrapper that is a Flutter plug-in, around the SDKs to make them usable by Flutter apps.

The Flutter plug-in works by passing messages through channels between the Dart plugins and the native Android or iOS platforms. There are two types of channels in Flutter: the event channel and the method channel. The procedures in this guide use only the method channel.

To generate the plug-in template that contains the folders that you need for your Flutter plug-in project:

1. Open a terminal session and navigate to the desired location for this project.

2. Use the command shown in the example below to create a Flutter plug-in project that specifies to use Java for Android and Objective-C for iOS:

        flutter create -–org com.sas.SASIA –-template=plugin -- platforms=android,ios -a java -i objc 
        mobile_sdk_flutter_example

As mentioned in “Initial Setup”, com.sas.SASIA.mobile_sdk_flutter_example is the package
name being used as an example in this project. You may want to replace that with the name of your project.

The resulting project includes these folders: android, example, ios, lib, and test.

    - The android and ios folders contain code that exposes native functionality to the rest of the Flutter app in Dart.
    - The lib folder is where the Dart files that are used by the app are stored. It contains the definition of the functions that can be understood and used by Flutter apps.
    - The example folder contains a starter Flutter app, sometimes referred to as the example project. It can be used for testing the Flutter plug-in.
    - The test folder can be used to write unit test code.

[Back to Top](#back-to-top)
</details>

#### Embed 360 SDK libraries
<details><summary>Click to expand</summary>
<a name="embed-libraries"></a>

There are two ways to obtain SAS Customer Intelligence 360 Mobile SDKs:
    - A SAS Customer Intelligence 360 user can download the mobile SDKs through the user interface for SAS Customer Intelligence 360 and deliver the SDK ZIP file (SASCollector_<applicationID>.zip) to you to install. The Android SDK and the iOS SDK are distributed together as a single ZIP package.
    - You can access the mobile SDKs from a public repository. 


For Android, see [Configure a Dependency on the Maven Repository](https://go.documentation.sas.com/doc/en/cintcdc/production.a/cintmobdg/p1t2i055pqd62an1pcqe6syo7b56.htm#n1xbunv723fzhan1kwd3guyniow8) for the Mobile SDK in SAS Customer Intelligence 360: Developer’s Guide for Mobile Applications.

Note: A SASCollector.properties file (for Android) and a SASCollector.plist file (for iOS) contain necessary information to successfully implement the mobile SDKs, including the customer’s selected tenant and mobile app ID. The files are not included in the public repository. The files must be obtained from the mobile SDK ZIP package that is downloaded from SAS Customer Intelligence 360.

You need to add the SASCollector framework (library) to the Flutter plug-in project that
you created.

1. In Android Studio, open the Flutter plug-in project.

2. In the android folder, create a folder called libs.

3. Navigate to the folder that contains the SAS Customer Intelligence 360 Mobile SDK ZIP file (SASCollector_<applicationID>.zip). Unzip the file, navigate to the android folder, and find SASCollector.jar. Copy SASCollector.jar from SASCollector_<applicationID>.zip into the libs folder.

4. Go to File => Project Structure => Modules.

5. Select the android folder.
Note: In Android Studio, the folder name appears as mobile_sdk_flutter_android.

6. In the center pane, click the Dependencies tab, click +, and then select JARs or Directories.

7. Find SASCollector.jar and click Open.
Note: Do not select Export.

8. In Android Studio or VSCode, in your Flutter plug-in project, add the following JAR file dependency under Dependencies in build.gradle (inside the android folder.) implementation files('./libs/SASCollector.jar ')

9. If both the iPhone simulator and Android simulator are installed, you are prompted
to choose which one to use. Choose the Android simulator. Verify that the build
succeeds, and that the app starts.

[Back to Top](#back-to-top)
</details>

#### Default Functionality
<details><summary>Click to expand</summary>
<a name="default-functionality"></a>

Some mobile app events, such as focus and defocus, do not need an explicit API call in the Flutter plug-in to make them work. The integration of SAS Customer Intelligence Mobile SDKs and the Flutter app is sufficient.

Other basic functions, such as custom events, page loads, and identity, need to be converted to Flutter functions to be used by a Flutter app.

To define custom events, app developers work with the marketing team.
    - Marketers define the custom events that are needed. Those custom events and their attributes are created in the SAS Customer Intelligence 360 user interface.
    - Developers include the custom events and their associated attributes in the app.

Then, the custom events can be leveraged by the Flutter app without any further code changes.

[Back to Top](#back-to-top)
</details>

#### Configuring Dart
<details><summary>Click to expand</summary>
<a name="configure-dart"></a>

1. In the Flutter plug-in project, navigate to the libs folder.
The folder contains three files: mobile_sdk_flutter_platform_interface.dart, 
mobile_sdk_flutter_method_channel.dart and mobile_sdk_flutter.dart. Each file contains boilerplate code.

2. In mobile_sdk_flutter_platform_interface.dart, add the methods from the SAS Customer Intelligence 360 Mobile SDKs that you want to use in your Flutter app.

For example, you might start by adding newPage, addAppEvent, identity, detachIdentity, startMonitoringLocation, and disableLocationMonitoring. Other public methods in SASCollector can be added later, such as getDeviceId and resetDeviceId, which are primarily used by developers for debugging purposes.

Example:
        Future<void> newPage(String uri) {
            throw UnimplementedError('newPage has not been implemented.');
        }

3. In mobile_sdk_flutter_method_channel.dart, add the implementation of the methods that you defined in mobile_sdk_flutter_platform_interface.dart in step 2.

Example:
        @override
        Future<void> newPage(String uri) async {
            return await methodChannel.invokeMethod('newPage', {'uri': uri});
        }

4. Create a file called constants.dart in the lib folder. Add the content from the SASCollector library. The public constants in the library are exported and exposed to the Flutter plug-in’s app users. The following constants are needed at this point in the constants file if you want to add the identity function to the plug-in and use it in your app:
        const String identityTypeEmail = "email_id";
        const String identityTypeLogin = "login_id";
        const String identityTypeCustomerId = "customer_id";

Additional constants can be added later.

5. Create a file called sas_collector_sdk.dart in the lib folder. Add these exports to the file:
        export 'mobile_sdk_flutter.dart';
        export 'constants.dart';

6. In mobile_sdk_flutter.dart, add the implementation of the methods that are defined in the mobile_sdk_flutter.zip.   

[Back to Top](#back-to-top)
</details>

#### Configuring Android
<details><summary>Click to expand</summary>
<a name="configure-android"></a>

1. In the Flutter plug-in project, navigate to the android folder. In the android folder, navigate to src/main/java/com/sas/SASIA/mobile_sdk_flutter, and find MobileSdkFlutterPlugin.java.

2. VSCode cannot automatically add imports, so you must manually add the following imports to MobileSdkFlutterPlugin.java:

        import android.annotation.NonNull;
        import android.content.Context;
        import android.content.pm.PackageManager;
        import android.app.Activity;
        import android.os.Handler;
        import android.os.Looper;
        import io.flutter.embedding.engine.plugins.activity.ActivityAware;
        import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
        import io.flutter.plugin.common.MethodCall;
        import io.flutter.plugin.common.MethodChannel;
        import io.flutter.plugin.common.BinaryMessenger;
        import java.util.*;
        import com.sas.mkt.mobile.sdk.SASCollector;

If the build fails when running this code from the example folder, review the
finished project to find the missing imports.

3. In the MobileSdkFlutterPlugin class definition, implement ActivityAware using this code:
        public class MobileSdkFlutterPlugin implements FlutterPlugin,
        MethodCallHandler, ActivityAware {

4. In the MobileSdkFlutterPlugin class, at the start of the class definition, add these variables:
        private MethodChannel channel;
        private Context context;

5. Update onAttachedToEngine, as shown below:
        @Override
        public void onAttachedToEngine(@NonNull FlutterPluginBinding
        flutterPluginBinding) {
            channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), 
            "mobile_sdk_flutter");
            channel.setMethodCallHandler(this);
            this.context = flutterPluginBinding.getApplicationContext();
        }

6. Update onMethodCall by adding native implementations of the exposed methods discussed in “Configuring Dart”.

7. Add the onDetachedFromEngine override method:
        @Override
        public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
            channel.setMethodCallHandler(null);
        }

8. Because the MobileSdkFlutterPlugin class implements ActivityAware, override methods such as onDetachedFromActivity, onAttachedToActivity, onReattachedToActivityForConfigChanges, and
onDetachedFromActivityForConfigChanges are required. Only onAttachedToActivity needs to be overridden as shown below:
        @Override
        public void onAttachedToActivity(@NonNullActivityPluginBinding binding) {
            SASCollector.getInstance().initialize(context);
        }

9. The SAS Customer Intelligence 360 Mobile SDK’s Android initialization requires google services and gson dependencies:

   - Navigate to example/android. Add this line in the dependencies section of the project level build.gradle:
        classpath 'com.google.gms:google-services:4.3.13'

    - Navigate to example/android/app/. Add this line in the dependencies section of the app level build.gradle:
        implementation 'com.google.code.gson:gson:2.8.9'

[Back to Top](#back-to-top)
</details>

#### Configuring the Flutter App
<details><summary>Click to expand</summary>
<a name="configure-flutter"></a>

1. Add SASCollector.properties to Android:
    - In VSCode, navigate to android/app/src/main and create an assets folder.

    - Find the SASCollector.properties file. The file is in the mobile SDK ZIP file for SAS Customer 
      Intelligence 360 (SASCollector_<applicationID>.zip) in the android folder.

    - Copy SASCollector.properties into the assets folder.

2. If you will build the Android application’s release APK and want to reduce the APK’s size, then follow the following two steps:
    - Find build.gradle in example/android/app, 
        and add this code inside release {}:
        minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'

    - Create a file called proguard-rules.pro in example/android/app as shown in the above      
      screenshot.  
      Add this code inside proguard-rules.pro:
        - keep class com.sas.mkt.mobile.sdk.** { *;}

3. Android only: The SAS Customer Intelligence 360 Mobile SDK might not initialize in time to use functionality such as Identity. To avoid this issue: 

    - Navigate to example/android/app/src/main/java/MainActivity.java in the example project:
        Add this line in MainActivity.java:
        SASCollector.getInstance().initialize(this);

4. Most of the code that a Flutter app developer writes is in the lib folder. Navigate to the lib folder. In main.dart, create a plug-in instance to make the plug-in available for all other pages, as shown in the example below.
        
        final mobileSdkFlutterPlugin = MobileSdkFlutter();

The reference is passed to the pages that need to access the plug-in’s functions.

5. To test the Identity API, in the lib folder create a login page Dart file (login_page.dart) like the one in the example project. Put the following code inside a login button’s onPress function, as shown in the example below:
        ElevatedButton(style: ElevatedButton.styleFrom(
        fixedSize: const Size(300, 40),
        ),
        onPressed: () {
            widget.mobileSdkFlutter
            .identity(textFieldController.text, selectedType)
            .then((success) => {
            if (success){
                Navigator.of(context)
                .push(MaterialPageRoute(
        builder: (BuildContext context) {
        return DetailsPage(
        textFieldController.text,
        widget.mobileSdkFlutter);
        }))
        } else {
        showDialog(context: context,
        builder: (_) =>
        const AlertDialog(
        title: Text("Error"),
        content: Text("Login failed."),
        ))
        }
        });
        },
        child: const Text("Log In"),
        )

Note: widget.mobileSdkFlutter.identity is the Flutter plugin method that is
created when you configured Dart. It communicates with SDK’s native identity
method.

6. To test page loads and custom events, in the lib folder create a home page dart file (home_page.dart) like the one in the example project. Events are created because of an activity such as tapping a button. Examples are shown below:
        ElevatedButton(
        style: ElevatedButton.styleFrom(
        fixedSize: const Size(250, 40)),
        onPressed: () {
            if (pageUriController.text.isNotEmpty) {
            Widget.mobileSdkFlutter
            .newPage(pageUriController.text);
        }
        },
        child: const Text('Invoke New Page Event'),
        ),
        ElevatedButton(
        style: ElevatedButton.styleFrom(
        fixedSize: const Size(250, 40)),
        onPressed: () {
            if(eventNameController.text.isEmpty ||
            attributeNameController.text.isEmpty ||
            attributeValueController.text.isEmpty) {
            return;
        }
        widget.mobileSdkFlutter.addAppEvent(
        eventNameController.text, {
        attributeNameController.text:
        attributeValueController.text
        });
        },
        child: const Text('Invoke App Event'),
        )

Note: widget.mobileSdkFlutter.newPage and widget.mobileSdkFlutter.addAppEvent are the Flutter plugin methods that were created when you configured Dart. They communicate with SDK’s native newPage and addAppEvent methods. 

[Back to Top](#back-to-top)
</details>
</details>

## SDK Features
<a name="sdk-features"></a>

### Sending Events
<details><summary>Click to expand</summary>
<a name="sending-events"></a>

The system uses a unique mobile event key to identify the event type to send; you do not need to specify the event type in the code. All event types are sent the same way.

**Native Kotlin**

To send an event (such as tapping a button) to the mobile SDK, call this event:

        SASCollector.getInstance().addAppEvent(eventId, attrs)

**Hybrid Flutter Dart**

To send an event (such as tapping a button) to the mobile SDK, call this event:

        mobileSdkFlutter.addAppEvent(eventId, attrs)

Use these parameters:
    - a string identifier for the event. This string identifier should be the mobile event key
      that is specified in SAS Customer Intelligence 360.
    - a map of name-to-value pairs of associated metadata to be sent with the hash map.
      
        mobileSdkFlutter.addAppEvent("myEventId", {myAttributeName: myAttributeValue})

The map can be null if you do not want to send any metadata (attrs = null):
        mobileSdkFlutter.addAppEvent("myEventId”, null)

[Back to Top](#back-to-top)
</details>

### Mobile Spots
<details><summary>Click to expand</summary>
<a name="mobile-spots"></a>

With SAS Customer Intelligence 360, you can include personalized content, such as advertising, in your mobile apps. In SAS Customer Intelligence 360, the location in the mobile app where the content is delivered is called a spot.

SAS Customer Intelligence 360 Mobile SDKs provide two types of spots: 
- inline spots and
- interstitial spots. 

Spots have delegate methods that are invoked at the different stages of the life cycle of the spots. For example, when the user closes an interstitial spot, the didClose method is called. Developers specify what action to take when a method is called.

As with custom events, app developers work with marketers to define where to include spots in the app and the content of those spots.

    - The app developer includes the new mobile spots and the associated attributes in the app.
    - Marketers register the mobile spots in the CI360 user interface so that they can be leveraged in 
      campaigns without any further code changes.
    - Marketing users design HTML creatives in SAS Customer Intelligence 360. Those creatives are 
      delivered to the mobile spots via tasks that specify the mobile app, the spot, the target 
      audience, and various other criteria.

Currently, the implementation of spots in the Flutter plug-in requires only the spotID parameter. If other parameters for spots are needed, developers can follow similar procedures to add them in the plug-in.

This section describes how to implement mobile spot features in the Flutter plug-in to be used in a Flutter app. The creation of the Flutter spots functions is described in two sections: “Configure Flutter (Dart)” and “Configure Android”. The Dart functions are created as an interface that can be used by the Flutter widgets to get the spots. Most of the work that is involved in constructing and presenting spots is in Android.

**Native Kotlin**

****Inline Ad Spot -****

Use the user interface component com.sas.mkt.mobile.sdk.ads.SASCollectorAd in your layout XML or programmatically in your Activity or Fragment class.

                <com.sas.mkt.mobile.sdk.ads.SASCollectorAd 
                        android:id="@+id/myAd" 
                        android:layout_width="fill_parent" 
                        android:layout_height="300dp" />
                <com.sas.mkt.mobile.sdk.ads.SASCollectorAd 
                        android:id="@+id/myAd" 
                        android:layout_width="fill_parent" 
                        android:layout_height="300dp" />

When you are ready to display the spot content, load the desired Spot ID into the spot. The load occurs asynchronously, so this method returns immediately.

                SASCollectorAd myAd = (SASCollectorAd)findViewById(R.id.myAd);
                myAd.load("MySpotID", tags);
                SASCollectorAd myAd = (SASCollectorAd)findViewById(R.id.myAd);
                myAd.load("MySpotID", tags);

Note: In this example, tags is a map of name-value pairs to support the ad request. If there are no additional tags to be used, the map for name-value pairs can be null:

                Map <String, String> tags = new HashMap <String, String> ();
                tags.put("myAttribute", "myAttributeValue");

****Interstitial Spot -****

To create an interstitial spot, programmatically create an instance of the com.sas.mkt.mobile.sdk.ads.SASCollectorInterstitialAd class.


                SASCollectorInterstitialAd myAd = new SASCollectorInterstitialAd(myActivity);
                SASCollectorInterstitialAd myAd = new SASCollectorInterstitialAd(myActivity);

Load the spot with your Spot ID and supplemental attributes, the same way you would load for an inline spot.

                myAd.load("MySpotID", tags);
                myAd.load("MySpotID", tags);

Although the class is a UI view itself, it should not be added to your app's layout. Instead, use the show() method of the class to present the spot to the user when you are ready for the spot to take control of the screen. Use the Ad's delegate onLoaded method as a trigger to know when the ad content is ready to be shown.

                myAd.setDelegate(new AdDelegate() {
                        @Overrid
                        public void onLoaded(AbstractAd ad) {
                                super.onLoaded(ad);
                                if (ad instanceof InterstitialAd) {
                                ((InterstitialAd) ad).show();
                                }
                        }

                        });
                myAd.setDelegate(new AdDelegate() {
                        @Overrid
                        public void onLoaded(AbstractAd ad) {
                                super.onLoaded(ad);
                                if (ad instanceof InterstitialAd) {
                                ((InterstitialAd) ad).show();
                                }
                        }

                        });

In order for this trigger to operate, the activity must be registered in the app's manifest as shown in this example:

                <activity android:name="com.sas.ia.android.sdk.InterstitialActivity"/>
                <activity android:name="com.sas.ia.android.sdk.InterstitialActivity"/>


**Hybrid Flutter Dart**

#### Configuring Dart
1. In the Flutter plug-in project, navigate to the lib folder and create a views folder.

2. In the views folder, create the following Dart files:
    - sas_collector_ad_base_controller.dart
    - sas_collector_ad_view.dart
    - sas_collector_inline_ad_view_controller.dart
    - sas_collector_interstitial_ad_view_controller.dart
    - sas_collector_interstitial_ad.dart

Each of the views has delegate methods that correspond to the methods that are defined in AdDelegate (for Android) and SASIA_AdDelegate (for iOS) in the SAS Customer Intelligence 360 Mobile SDKs. Therefore, they need controllers to perform actions (such as onLoaded and onClosed for Android and didLoad and didClose for iOS).

sas_collector_ad_base_controller.dart is the base controller that the controllers of inline ad view and interstitial ad view inherit their values from. It defines all the delegate functions that an app can use. The app can also choose to use specific functionality. Please see the example project’s view_page.dart file to see how these functions are used.

An implementation example of the ad views and their controllers is provided in mobile_sdk_flutter.zip. In the mobile_sdk_flutter project example, navigate to mobile_sdk_flutter/lib/views.

3. In the lib folder, update sas_collector_sdk.dart to include this code:
        export 'views/sas_collector_ad_view.dart';
        export 'views/sas_collector_interstitial_ad.dart';
        export views/sas_collector_interstitial_ad_view_controller.dart';
        export 'views/sas_collector_inline_ad_view_controller.dart';

#### Configure Android

1. In the Flutter plug-in project, navigate to the Android folder. In /src/main/java/com/sas/SASIA/mobile_sdk_flutter, create a Constants.java file.

2. Add the following string constants.

TIP: The use of constants avoids typographical errors.

        package com.sas.SASIA.mobile_sdk_flutter;
        public class Constants {
        public static String Interstitial_Controller_Channel = "interstitial_controller_channel";
        public static String Inline_Ad_Controller_Channel = "inline_ad_controller_channel";
        public static String Spot_ID = "spotID";
        public static String Inline_Ad_View = "inlineAdView";
        public static String Interstitial_Ad_View = "interstitialAdView";
        }

Additional string constants can be added later as needed.

3. In src/main/java/com/sas/SASIA/mobile_sdk_flutter, create a views folder.

4. In mobile_sdk_flutter.zip, navigate to mobile_sdk_flutter/android/src/main/java/com/sas/SASIA/mobile_sdk_flutter/views.

5. Copy the following files and paste them in the views folder that you just created:
        • BaseAdView.java
        • InlineAdView.java
        • InlineAdViewFactory.java
        • InterstitialAdView.java
        • InterstitialAdViewFactory.java

BaseAdView includes functionality that is common to both InterstitialAdView and InlineAdView. These two classes inherit features from BaseAdView and add their own features on top of it.

6. Navigate to src/main/java/com/sas/SASIA/mobile_sdk_flutter. In MobileSdkFlutterPlugin.java , update the onAttachedToEngine method with this code to register the views:
        PlatformViewRegistry registry = flutterPluginBinding.getPlatformViewRegistry();
        BinaryMessenger messenger = flutterPluginBinding.getBinaryMessenger();
        registry.registerViewFactory(Constants.Inline_Ad_View, new InlineAdViewFactory(messenger));
        registry.registerViewFactory(Constants.Interstitial_Ad_View, new InterstitialAdViewFactory  
        (messenger));
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "mobile_sdk_flutter");
        channel.setMethodCallHandler(this);

7. In addition to the updates for the classes above, an update is needed in the example project.    
        Navigate to android/app/src/build.gradle:
        Add this dependency:
        implementation files('../../../android/libs/SASCollector.jar')


A direct reference to the mobile SDK (as shown above) is needed for some native code-related operations, such as push notifications.

Note: This becomes clear when additional functionality is included.

8. Include the mobile SDK’s implementation of the ad view activities in the example project’s AndroidManifest.xml file so that the Android version of the Flutter app works. Navigate to android/app/src/main in the example project.    

Add these lines to AndroidManifest.xml:

     <activity android:name="com.sas.ia.android.sdk.InterstitialActivity"/>
     <activity android:name="com.sas.ia.android.sdk.InterstitialWebActivity"/>


#### Inline Ad Spot
<a name="inline-spot"></a>

The size of inline and interstitial spot widgets on the Dart side depends on the size of the parent. Therefore, inline and interstitial spot widgets need to be wrapped in a widget (parent) such as SizedBox. The following is sample code for an inline spot widget:

        SizedBox(
        height: 100,
        width: 300,
        child: SASCollectorInlineAdView(
        spotID: 'weather_spot_1',
        onCreated: onInlineAdCreated,
        )

#### Interstitial Ad Spot
<a name="interstitial-spot"></a>

An interstitial spot widget does not render itself when it is placed on the screen. An interstitial spot widget needs a button to invoke its controller to display it. The following sample code provides that functionality:

        Card(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            children: [
            const Text('Interstitial Ad View'),
            ElevatedButton(
                onPressed: () {
                interstitialAdController.showAd();
                },
        child: const Text('Show Interstitial Ad')),
        ],
        ),
        ),
        ),
        SizedBox(
            width: 3,
            height: 4,
            child: SASCollectorInterstitialAdView(
            spotID: 'interstitial_spot',
            onCreated: onInterstitialAdCreated),
        )

The controllers for inline and interstitial ad views are defined at the start of the State class of the StatefulWidget. The controllers’ handler methods are the equivalent of the handler methods for inline and interstitial ad views. You can modify them to suit your needs. See view_page.dart in the example app of the finished project for more details.

[Back to Top](#back-to-top)
</details>

### Location Functionality (Geofence/Beacon)
<details><summary>Click to expand</summary>
<a name="location-functionality"></a>

Location features include precise location query (the ability to identify the local of a mobile device), geofence registration and detection, and beacon detection. 

Developers collaborate with marketers on when to send push notifications. If the location of a mobile app is known, a triggered push notification can be sent when users enter or leave geolocations, or when a beacon is discovered. For example, when a user enters the geofence of a drugstore, the mobile app can send a push notification that entitles the user to a discount.

A SAS Customer Intelligence 360 user creates a triggered push notification task with the trigger set (on the Orchestration tab) to one of these mobile location options:

    - Beacon Discovered
    - Geofence Entered
    - Geofence Exit

The SAS Customer Intelligence 360 user selects the trigger event’s attribute condition, which is the action that triggers the event. For example, if the Geofence Entered trigger is an airport, the event’s name might be Airport. Note that the CSV file that the developer delivered to the SAS Customer Intelligence 360 user to upload contains the event attributes to choose from. 

To enable location features, these actions are required:
    - Add startMonitoringLocation and disableLocationMonitoring. For geofences and beacons to work, 
      these two functions are needed from the SDK. 
    - Request location tracking permission. A developer requests location tracking permission from the 
      user through the mobile app.
    - Upload geofence and beacon data. A developer provides geofence and beacon information in a CSV 
      file to the SAS Customer Intelligence 360 user who uploads the file to the mobile application 
      that was created in SAS Customer Intelligence 360.

**Native Kotlin**

Activate the mobile SDK’s location-monitoring capabilities:

        SASCollector.getInstance().startMonitoringLocation();
        SASCollector.getInstance().startMonitoringLocation();

When location monitoring is activated, the mobile SDK automatically updates its location data on each focus of the mobile app, caching the precise location data for focus events within one minute of each other.

If you want to disable the functionality, use this code:

        SASCollector.getInstance().disableLocationMonitoring()
        SASCollector.getInstance().disableLocationMonitoring()

(Optional) To ensure that location monitoring is re-enabled after a device is rebooted, configure the SASCollectorBroadcastReceiver in the application’s manifest to receive BOOT_COMPLETED broadcasts:

        <receiver android:name="com.sas.mkt.mobile.sdk.SASCollectorBroadcastReceiver">
        <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
        </intent-filter>
        </receiver>
        <receiver android:name="com.sas.mkt.mobile.sdk.SASCollectorBroadcastReceiver">
        <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED"/>
        </intent-filter>
        </receiver>

Also configure the mobile app to declare usage of the RECEIVE_BOOT_COMPLETED permission in the manifest:

        <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>


**Hybrid Flutter Dart**

#### Configure Flutter

1. In pubspec.yaml, add the following dependencies:

        permission_handler: ^9.2.0
        location: ^4.4.0
        fluttertoast: ^8.0.9

2. In example/lib/main.dart, add imports at the start of the file, as shown in the code below:

        import 'package:fluttertoast/fluttertoast.dart';
        import 'package:permission_handler/permission_handler.dart';
        import 'package:location/location.dart' as loc;

3. Write this function:

        void getLocationPermissionsAndStartGeofence() async {
                if (await Permission.locationAlways.isGranted) {
                        mobileSdkFlutterPlugin.startMonitoringLocation();
                        _geofenceStarted = true;
                        return;
                }
                if (await Permission.locationAlways.isDenied ||await Permission.locationAlways. 
                        isPermanentlyDenied) {
                                Fluttertoast.showToast(
                                msg: 'For location-related features to work, '
                                'please always allow "appname" to '
                                ' access your location',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                                await Future.delayed(const Duration(seconds: 2), () {});
                                openAppSettings();
                }
        }

4. After the user grants permission in app settings and returns to the mobile app, the permission change is not apparent in the app. For the app to detect the permission change, the state class needs to implement WidgetsBindingObserver mixin, set itself as the observer, and override  didChangeAppLifecycleState as follows:

        @override
        void didChangeAppLifecycleState(AppLifecycleState state) async {
                await Future.delayed(const Duration(seconds: 1), () {});
                if (!_geofenceStarted) {
                getLocationPermissionsAndStartGeofence();
                }
                super.didChangeAppLifecycleState(state);
        }

5. In the initState method, add this code:
        if (Platform.isAndroid) {
            getLocationPermissionsAndStartGeofence();
        } else if (Platform.isIOS) {
            getLocationPermissionsIOSAndStartGeofence();
        }


#### Configure Android
1. Navigate to app/src/main and find the AndroidManifest.xml file.

2. Add permissions for locations:

        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
        <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
        <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
        <uses-permission android:name="android.permission.BLUETOOTH" />
        <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />

3. In <application></application>, add this code:

        <service android:name="com.sas.mkt.mobile.sdk.SASCollectorIntentService"></service>
        <receiver android:name="com.sas.mkt.mobile.sdk.SASCollectorBroadcastReceiver"
        android:exported = "true">
        <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
        </intent-filter>
        </receiver>

4. To enable detailed logging in the mobile SDK, create FlutterApplication.java in
app/src/main/java/com/sas/SASIA/mobile_sdk_flutter_example.

5. Add this code to the FlutterApplication.java file that you created:

        package com.sas.SASIA.mobile_sdk_flutter_example;
        import android.app.Application;
        import com.sas.mkt.mobile.sdk.util.SLog;

        public class FlutterApplication extends Application {
            @Override
            public void onCreate() {
                super.onCreate();
                SLog.setLevel(SLog.ALL);
            }
        }

6. In the AndroidManifest.xml file find 
   android:name=” <name of application>” and change it to android:name=”.FlutterApplication”

[Back to Top](#back-to-top)
</details>

### Mobile Messaging
<details><summary>Click to expand</summary>
<a name="mobile-messaging"></a>

Mobile message features include token registration, in-app messages, push notifications, rich push notifications for iOS, and the delegate methods. SAS Customer Intelligence 360 enables you to capture real-time impression data and connect other SAS Customer Intelligence 360 features with mobile messages. 

Push notifications can display timely offers that invite a mobile app user back into the mobile app or into a store. For example, a mobile app user might drive to a store for which a geofence is defined in the mobile app. When the user (more specifically, the user’s mobile device) enters that geofence, that action can trigger the mobile app to send a push notification that informs the user of a sale in the store.

In-app messages can display pop-up ads in the app. For example, the user might tap a button that triggers the in-app message event. The in-app message displays ads that might contain a link for the user to go to the website to learn more, or a button that takes the user to another page of the app to get more information. As the message is triggered by a SAS Customer Intelligence 360 custom event, this cannot be achieved using third-party plug-ins.

When the user clicks one of the buttons in an in-app message or opens a push notification, often the next action is to navigate to a particular section of your app. Design your delegate to be as flexible as possible so that it can perform navigation based on the link provided by the creative. This flexibility enables the SAS Customer Intelligence 360 user to achieve the desired calls to action more easily. Like the configuration of location functionality, mobile messages require more native
setup than Dart setup. 

**Native Kotlin**

Starting from Android 13, all applications must ask users for permissions to send push notification prompts. For more information, see Notification Permission for Opt-In Notifications.

In your application's manifest file, declare the necessary notification permission. Here is an example:

        <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
        <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

In your application's activity or fragment, request run-time permission from the user. Here is an example:

        String[] permissions = {Manifest.permission.POST_NOTIFICATIONS};

        activity.requestPermissions(permissions, MY_REQUEST_CODE);
        String[] permissions = {Manifest.permission.POST_NOTIFICATIONS};

        activity.requestPermissions(permissions, MY_REQUEST_CODE);

In your implementation of the FirebaseMessagingService interface, when the onMessageReceived callback is made, pass the data member of the RemoteMessage to SASCollector.handleMobileMessage. If the call returns false, the message was not intended for the SASCollector and the app should process the call as necessary.

        if( ! SASCollector.getInstance().handleMobileMessage(remoteMessage.getData())) {
                //Handle non-SASCollector message
        }
        if( ! SASCollector.getInstance().handleMobileMessage(remoteMessage.getData())) {
                //Handle non-SASCollector message
        }

When the onNewToken(String) callback is made, this token should be relayed to SAS Customer Intelligence 360 using the SASCollector.getInstance().registerForMobileMessages API.


        if (token != null) {

        SASCollector.getInstance().registerForMobileMessages(token, success -> {
                if (success) {
                SLog.d("TOKEN", "Registration success " + token);


                } else {
                SLog.d("TOKEN", "Registration failed ");
                }
        });
        }
        if (token != null) {
        SASCollector.getInstance().registerForMobileMessages(token, success -> {
                if (success) {
                SLog.d("TOKEN", "Registration success " + token);
                } else {
                SLog.d("TOKEN", "Registration failed ");
                }
        });
        }

Relay the current FCM token to SAS Customer Intelligence 360 on each start-up of your application.

String token = task.getResult();
        SASCollector.getInstance().registerForMobileMessages(token, success -> {
        if (success) {
                SLog.d("TOKEN", "Registration success " + token);
        } else {
                SLog.d("TOKEN", "Registration failed from settings ");
        }
        });
        String token = task.getResult();

        SASCollector.getInstance().registerForMobileMessages(token, success -> {
        if (success) {
                SLog.d("TOKEN", "Registration success " + token);
        } else {
                SLog.d("TOKEN", "Registration failed from settings ");
        }
        });

After the SDK is initialized, use this syntax to pass the channel ID to the NotificationManager API:

        NotificationManager notificationManager =
        (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        NotificationChannel notificationChannel = new NotificationChannel(
                "<your notification channel name>",
                "Digital Marketing",
                NotificationManager.IMPORTANCE_HIGH
        );

        notificationManager.createNotificationChannel(notificationChannel);

        SASCollector.getInstance().setPushNotificationChannelId(notificationChannel.getId());
        NotificationManager notificationManager =
        (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        NotificationChannel notificationChannel = new NotificationChannel(
                "<your notification channel name>",
                "Digital Marketing",
                NotificationManager.IMPORTANCE_HIGH
        );

        notificationManager.createNotificationChannel(notificationChannel);
        SASCollector.getInstance().setPushNotificationChannelId(notificationChannel.getId());


**Hybrid Flutter Dart**

#### Configure Flutter
1. For the methods of the SASMobileMessagingDelegate2 delegate to work, the Flutter method channel is used. When the delegate methods are called on the native side, messages are sent through the channel, and the Dart side responds to the messages passed from the channel.

2. In the project’s main.dart file, add this method:

        void setupConnectionWithNative() {
            channel.setMethodCallHandler((call) async {
            switch (call.method) {
            case 'msgDismissed':
                Fluttertoast.showToast(msg: "User dismissed the message");
            break;
            case 'actionLinkClicked':
                print('actionLinkClicked called');
                Map args = call.arguments;
                String link = args['link'];
                String type = args['type'];
                Fluttertoast.showToast(msg:
                "User clicked the push notification link: $link");
                if (link.contains('diagnostics')) {
                if (type == 'InAppMsg') {
                // diagnostics page has index of 3
                _tabController.animateTo(3);
                } else if (type == 'PushNotification') {
                if (Platform.isIOS) {
                _tabController.animateTo(3);
                } else if (Platform.isAndroid) {
                _pushNotificationReceived = true;
                }
                }
                }
                break;
                default:
                break;
            }
            });
        }


#### Configure Android

1. In the Firebase console, create a project and add your Flutter app’s Android package ID ('com.ronald.my_first_flutter_app' in this project) to the project.

2. Get the google-services.json file and put it in the project’s android/app folder.

3. From the project in the Firebase console, get the server key and give it to the SAS Customer Intelligence 360 user. The user will add it to the SAS Customer Intelligence 360 mobile application that is created for the project.

4. Under android/app/src/main/java/com/sas/SASIA/mobile_sdk_flutter_example, find MainActivity.java and add the following:
    - Add the setPushChannel method:

      Note: Android version Oreo and above requires a push notification channel. By creating it in the 
      application class, you can avoid having to re-create the channel. Slog can also be set in the 
      application, so it is not needed in MainActivity.java. 

        @RequiresApi(api = Build.VERSION_CODES.O)
        
        private void setPushChannel() {
            NotificationManager notificationManager = (NotificationManager)
            this.getSystemService(NOTIFICATION_SERVICE);
            String customAndroidChannel = "FlutterPushChannel";
            CharSequence channelName = "Flutter Channel";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel notificationChannel =
            new NotificationChannel(customAndroidChannel, channelName, importance);
            notificationChannel.enableLights(true);
            notificationChannel.setLightColor(Color.RED);
            notificationChannel.enableVibration(true); 
            notificationChannel.setShowBadge(true);
            notificationChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500,
            400, 300, 200, 400}
            );
            notificationManager.createNotificationChannel(notificationChannel);
            SASCollector.getInstance().setPushNotificationChannelId(customAndroidChannel);
        }
    - Also, add the setPushChannel method call to the onCreate method as follows:
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        setPushChannel();
        }

5. In the same folder where MainActivity resides, add AppFirebaseMessagingService.java with two override methods.
        public class AppFirebaseMessagingService extends FirebaseMessagingService {
        @Override
        public void onMessageReceived(RemoteMessage remoteMessage)
        {
            if (!SASCollector.getInstance().handleMobileMessage(
            remoteMessage.getData())) {
            //Handle non-SASCollector message
            }
            }
            @Override
            public void onNewToken(String token) {
                super.onNewToken(token);
                SLog.e("NEW_TOKEN",token);
                if(token != null) {
                SASCollector.getInstance().registerForMobileMessages(token);
                }
        }
        }

6. In the project level build.gradle file, add this line in dependencies section:
        classpath 'com.google.gms:google-services:4.3.13'

7. Find the app level build.gradle file and add these lines to the dependencies section:
        implementation 'com.google.firebase:firebase-core'
        implementation 'com.google.firebase:firebase-messaging'
   In the plugin section, add:
        apply plugin: 'com.google.gms:google-services'

8. In MainActivity.java write this code:

        public class MainActivity extends FlutterActivity {
            MethodChannel channel;
            String notificationLink;
            @Override
            public void configureFlutterEngine(
            @NonNull FlutterEngine flutterEngine) {
            super.configureFlutterEngine(flutterEngine);
            channel = new MethodChannel(
            flutterEngine.getDartExecutor().getBinaryMessenger(),"app_channel");
            }
            @Override
            protected void onCreate(
            @Nullable Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            SASCollector.getInstance().initialize(getApplicationContext());
            FirebaseMessaging.getInstance()
            .getToken().addOnSuccessListener(token -> {
            if(!TextUtils.isEmpty(token)) {
            SASCollector.getInstance().registerForMobileMessages(token);
            }
            });
            Intent intent = getIntent();
            notificationLink = intent.getStringExtra("notificationWithLink");

            SASCollector.getInstance().setMobileMessagingDelegate2(
            new SASMobileMessagingDelegate2() {
            @Override
            public void dismissed() {
            channel.invokeMethod("msgDismissed", null);
            }
            @Override
            public void action(String s,
            SASMobileMessageType sasMobileMessageType) {
            if(sasMobileMessageType.equals(
            SASMobileMessageType.IN_APP_MESSAGE)) {
            Map<String, String> args = new HashMap<>();
            args.put("link", s);
            args.put("type", "InAppMsg");
            channel.invokeMethod(
            "actionLinkClicked", args);
            }
            }
            @Override
            public Intent getNotificationIntent(String s) {
            SLog.i("getNotificationIntent", s);
            Intent intent = new Intent(
            MainActivity.this, MainActivity.class);
            intent.putExtra("notificationWithLink", s);
            intent.addFlags(
            Intent.FLAG_ACTIVITY_SINGLE_TOP);
            return intent;
            }
            });
            }
            @Override
            public void onPostResume() {
            super.onPostResume();
            if(notificationLink != null) {
            Map<String, String> args = new HashMap<>();
            args.put("link", notificationLink);
            args.put("type", "PushNotification");
            channel.invokeMethod("actionLinkClicked", args);
            notificationLink = null;
            }
            }
            }

9. In AndroidManifest.xml, add the Firebase Messaging service:
        <service
        android:name=".AppFirebaseMessagingService"
        android:exported="false">
        <intent-filter>
            <action android:name= "com.google.firebase.MESSAGING_EVENT" />
        </intent-filter>
        </service>

[Back to Top](#back-to-top)
</details>

### Get or Set Mobile App Version
<details><summary>Click to expand</summary>
<a name="get-app-version"></a>

**Native Kotlin**

You can get the version by including the string:
        
        SASCollector.getInstance().getApplicationVersion()

You can set the version by including the string:
        
        SASCollector.getInstance().setApplicationVersion(String);

**Hybrid Flutter Dart**

You can get the version by including the method:
        
        widget.mobileSdkFlutter
                        .getApplicationVersion()
                        .then((version) => setState(() {
                              appVersion = version;
                              txtversionController.text = appVersion;
                            }));

You can set the version by including the method:
        
        widget.mobileSdkFlutter
                        .setApplicationVersion()
                        .then((version) => setState(() {
                              appVersion = version;
                              txtversionController.text = appVersion;
                            }));

[Back to Top](#back-to-top)
</details>

### Reset Device ID
<details><summary>Click to expand</summary>
<a name="reset-deviceid"></a>

You can reset the mobile SDK's unique identifier for the user by adding this code somewhere in your app (for example, in About or Settings):

**Native Kotlin**

        SASCollector.getInstance().resetDeviceID();

**Hybrid Flutter Dart**

        widget.mobileSdkFlutter
                        .getDeviceId()
                        .then((device) => setState(() {
                                        deviceId = device;
                                        txtresetdeviceidController.text =
                                            deviceId;
                                      }));

[Back to Top](#back-to-top)
</details>

### Get SDK/Platform Version
<details><summary>Click to expand</summary>
<a name="get-sdk-version"></a>

The following string returns the SDK version:

**Native Kotlin**

        com.sas.mkt.mobile.sdk.BuildInfo.VERSION

**Hybrid Flutter Dart**

        widget.mobileSdkFlutter
                        .getPlatformVersion()
                        .then((version) => setState(() {
                              platVersion = version;
                              txtversionController.text = platVersion;
                            }));

[Back to Top](#back-to-top)
</details>

### Disable the SDK
<details><summary>Click to expand</summary>
<a name="disable-sdk"></a>

**Native Kotlin**

Typically, this capability is provided to support privacy requirements and enable more complicated mobile apps to turn on tracking when certain use cases are applied.

Run this code to turn off the mobile SDK:

        SASCollector.getInstance().shutdown();

Run this code to start the mobile SDK again:

        SASCollector.getInstance().initialize(Context context);

**Hybrid Flutter Dart**

         widget.mobileSdkFlutter.shutdown();

[Back to Top](#back-to-top)
</details>

