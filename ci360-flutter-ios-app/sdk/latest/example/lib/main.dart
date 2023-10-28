import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

import 'home_page.dart';
import 'login_route.dart';
import 'config_page.dart';
import 'settings_page.dart';
import 'messages_page.dart';

import 'package:flutter/services.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

final mobileSdkFlutterPlugin = MobileSdkFlutter();
const Color primaryColor = Color(0xFF0379CE);
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static MethodChannel channel = const MethodChannel('app_channel');

  late final tabController = TabController(length: 4, vsync: this);

  bool _geofenceStarted = false;
  String _platformVersion = 'Unknown';
  bool _pushNotificationReceived = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    await Future.delayed(const Duration(seconds: 1), () {});
    if (!_geofenceStarted) {
      getLocationPermissionsAndStartGeofence();
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();
    if (Platform.isAndroid) {
      getLocationPermissionsAndStartGeofence();
    } else if (Platform.isIOS) {
      getLocationPermissionsIOSAndStartGeofence();
    }
    setupConnectionWithNative();
    super.initState();
  }

  void getLocationPermissionsAndStartGeofence() async {
    if (await Permission.locationAlways.isGranted) {
      mobileSdkFlutterPlugin.startMonitoringLocation();
      _geofenceStarted = true;
      return;
    }
    if (await Permission.locationAlways.isDenied || await Permission.locationAlways.isPermanentlyDenied) {
      Fluttertoast.showToast(
          msg: 'For location-related features to work,  '
              'please always allow "appname" to '
              ' access your location',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER);
      await Future.delayed(const Duration(seconds: 2), () {});
      openAppSettings();
    }
  }

  void getLocationPermissionsIOSAndStartGeofence() async {
    loc.Location location = loc.Location();
    bool isServiceEnabled = await location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await location.requestService();
      if (!isServiceEnabled) {
        return;
      }
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    mobileSdkFlutterPlugin.startMonitoringLocation();
    _geofenceStarted = true;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await mobileSdkFlutterPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void setupConnectionWithNative() {
    channel.setMethodCallHandler((call) async {
      print('setMethodCallHandler, method: ${call.method}');
      switch (call.method) {
        case 'msgDismissed':
          print('Message Dismissed');
          Fluttertoast.showToast(msg: "User dismissed the message");
          break;
        case 'actionLinkClicked':
          print('actionLinkClicked called');
          Map args = call.arguments;
          String link = args['link'];
          String type = args['type'];
          Fluttertoast.showToast(msg: "User clicked the push notification link: $link");
          if (link.contains('diagnostics')) {
            if (type == 'InAppMsg') {
              tabController.animateTo(3); // diagnostics page has index of 3
            } else if (type == 'PushNotification') {
              _pushNotificationReceived = true;
              tabController.animateTo(3);
            }
          }
          break;

        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: primaryColor,
            onPrimary: Colors.white,
            // Colors that are not relevant to AppBar in LIGHT mode:
            secondary: primaryColor,
            onSecondary: Colors.white,
            background: Colors.grey,
            onBackground: Colors.grey,
            surface: Colors.grey,
            onSurface: Colors.grey,
            error: Colors.grey,
            onError: Colors.grey,
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter - CI360 Example App'),
          ),
          bottomNavigationBar: Container(
            color: primaryColor,
            child: SafeArea(
              child: Container(
                color: primaryColor,
                child: TabBar(
                  controller: tabController,
                  tabs: const <Widget>[
                    Tab(
                      text: 'Home',
                      icon: Icon(Icons.home),
                    ),
                    Tab(
                      text: 'Login',
                      icon: Icon(Icons.person),
                    ),
                    Tab(
                      text: 'Settings',
                      icon: Icon(Icons.settings),
                    ),
                    Tab(
                      text: 'Config',
                      icon: Icon(Icons.handyman_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              HomePage(
                mobileSdkFlutter: mobileSdkFlutterPlugin,
              ),
              LoginRoute(
                mobileSdkFlutter: mobileSdkFlutterPlugin,
              ),
              SettingsPage(
                mobileSdkFlutter: mobileSdkFlutterPlugin,
              ),
              ConfigPage(
                mobileSdkFlutter: mobileSdkFlutterPlugin,
              )
            ],
          ),
        ));
    if (_pushNotificationReceived) {
      tabController.animateTo(3);
      _pushNotificationReceived = false;
    }
    return app;
  }
}
