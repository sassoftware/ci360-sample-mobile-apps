import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_sdk_flutter_example/diagnostic_page.dart';
import 'package:mobile_sdk_flutter_example/messages_page.dart';
import 'package:mobile_sdk_flutter_example/view_page.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;

import 'home_page.dart';
import 'login_route.dart';

import 'package:flutter/services.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

final mobileSdkFlutterPlugin = MobileSdkFlutter();

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  String _platformVersion = 'Unknown';
  static MethodChannel channel = const MethodChannel('app_channel');
  bool _geofenceStarted = false;
  bool _pushNotificationReceived = false;
  late final _tabController = TabController(length: 5, vsync: this);

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
    if (await Permission.locationAlways.isDenied ||
        await Permission.locationAlways.isPermanentlyDenied) {
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
      platformVersion = await mobileSdkFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
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

  @override
  Widget build(BuildContext context) {
    MaterialApp app = MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Login',
              icon: Icon(Icons.login),
            ),
            Tab(
              text: 'Home',
              icon: Icon(Icons.home),
            ),
            Tab(
              text: 'Spots',
              icon: Icon(Icons.view_compact),
            ),
            Tab(
              text: 'Diagnostics',
              icon: Icon(Icons.checklist),
            ),
            Tab(
              text: 'Msg',
              icon: Icon(Icons.message),
            ),
          ],
        ),
        title: const Text('Flutter Demo App'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginRoute(
            mobileSdkFlutter: mobileSdkFlutterPlugin,
          ),
          HomePage(
            mobileSdkFlutter: mobileSdkFlutterPlugin,
          ),
          const ViewPage(),
          DiagnosticPage(
            mobileSdkFlutter: mobileSdkFlutterPlugin,
          ),
          MessagesPage(
            mobileSdkFlutter: mobileSdkFlutterPlugin,
          )
        ],
      ),
    ));
    if (_pushNotificationReceived) {
      _tabController.animateTo(3);
      _pushNotificationReceived = false;
    }
    return app;
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
          Fluttertoast.showToast(
              msg: "User clicked the push notification link: $link");
          if (link.contains('diagnostic')) {
            if (type == 'InAppMsg') {
              _tabController.animateTo(3); // diagnostic page has index of 2

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
}
