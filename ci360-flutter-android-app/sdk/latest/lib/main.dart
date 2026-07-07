//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: main.dart                                                                                        #
//# File Description: Entry point of the SAS CI360 Flutter Demo Application. Initialises Flutter, sets up Firebase, and launches the root MaterialApp with the HomeRoute as the starting page. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//

import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';
import 'package:ron360flutterapp/constants.dart';
import 'package:ron360flutterapp/initialize_route.dart';
import 'package:ron360flutterapp/login_page.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/messages_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ron360flutterapp/details_page.dart';
import 'package:ron360flutterapp/app_theme.dart';
import 'dart:io';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

final mobileSdkFlutterPlugin = MobileSdkFlutter();
MobileSdkFlutter mobileSdkFlutter = new MobileSdkFlutter();
String username = '';

void main() {
  runApp(
    MaterialApp(
      title: 'SAS CI360 Demo',
      theme: buildAppTheme(),
      home: MyHomePage(title: 'SAS CI360 Demo'),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

/*
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
*/
class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int _selectedIndex = 0;
  // ignore: unused_field
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  // ignore: unused_field
  String _platformVersion = 'Unknown';
  static MethodChannel channel = const MethodChannel('app_channel');
  // ignore: unused_field
  bool _geofenceStarted = false;
  // ignore: unused_field
  bool _pushNotificationReceived = false;
  // ignore: unused_field
  late final _tabController = TabController(length: 5, vsync: this);

  // ignore: unused_field
  static const List<Widget> _widgetOptions = <Widget>[];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route.isFirst);
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              userID: username,
              mobileSdkFlutter: mobileSdkFlutter,
            ),
          ),
        );
      }
      if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(mobileSdkFlutter: mobileSdkFlutter),
          ),
        );
      }
    });
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
        gravity: ToastGravity.CENTER,
      );
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
          Fluttertoast.showToast(
            msg: "User clicked the push notification link: $link",
          );
          if (link.contains('diagnostics')) {
            if (type == 'InAppMsg') {
              // diagnostics page has index of 3
              //_tabController.animateTo(3);
            } else if (type == 'PushNotification') {
              _pushNotificationReceived = true;
              //_tabController.animateTo(3);
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
    final tt = Theme.of(context).textTheme;
    final loggedInUser = AppState.instance.loggedInUser;
    final connectedTenant = AppState.instance.connectedTenantId;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAS CI360 Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Image.asset('assets/SASCI360.png', height: 30),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome banner ──────────────────────────────────────────
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: kPrimary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.phone_android_rounded,
                          color: kPrimary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CI360 Mobile SDK',
                              style: tt.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(
                              loggedInUser.isNotEmpty
                                  ? 'Signed in as $loggedInUser'
                                  : 'Flutter Demo Application',
                              style: tt.bodySmall?.copyWith(color: kTextMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SectionHeader('Features'),

            // ── Navigation cards ────────────────────────────────────────
            Card(
              child: Column(
                children: [
                  NavTile(
                    icon: Icons.person_outline_rounded,
                    iconColor: kIconBlue,
                    title: 'Profile',
                    subtitle: loggedInUser.isNotEmpty
                        ? 'Signed in as $loggedInUser'
                        : 'SDK details and connection info',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsPage(
                          userID: AppState.instance.loggedInUser,
                          mobileSdkFlutter: mobileSdkFlutter,
                        ),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                  NavTile(
                    icon: Icons.forum_outlined,
                    iconColor: kIconTeal,
                    title: 'Messaging',
                    subtitle: 'In-app and push notification demos',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MessagesPage(mobileSdkFlutter: mobileSdkFlutter),
                      ),
                    ),
                  ),
                  NavTile(
                    icon: Icons.widgets_outlined,
                    iconColor: kIconPurple,
                    title: 'Content & Ads',
                    subtitle: 'Inline/interstitial ads, events, spot requests',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            HomePage(mobileSdkFlutter: mobileSdkFlutter),
                      ),
                    ),
                  ),
                  NavTile(
                    icon: loggedInUser.isNotEmpty
                        ? Icons.verified_user_outlined
                        : Icons.login_rounded,
                    iconColor: kIconGreen,
                    title: loggedInUser.isNotEmpty
                        ? 'Identity'
                        : 'Login / Identity',
                    subtitle: loggedInUser.isNotEmpty
                        ? 'Logged in as $loggedInUser'
                        : 'Identify a user with CI360',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LoginPage(mobileSdkFlutter: mobileSdkFlutter),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                  NavTile(
                    icon: connectedTenant.isNotEmpty
                        ? Icons.cloud_done_outlined
                        : Icons.settings_outlined,
                    iconColor: kIconAmber,
                    title: 'Initialize CI360',
                    subtitle: connectedTenant.isNotEmpty
                        ? 'Connected: $connectedTenant'
                        : 'Configure tenant, tag server and app ID',
                    isLast: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            InitializeRoute(mobileSdkFlutter: mobileSdkFlutter),
                      ),
                    ).then((_) => setState(() {})),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.tune_rounded), label: 'Features'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// ignore: must_be_immutable
class HomeRoute extends StatelessWidget {
  HomeRoute({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                HomePage(mobileSdkFlutter: mobileSdkFlutter),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class LoginRoute extends StatelessWidget {
  LoginRoute({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) =>
                LoginPage(mobileSdkFlutter: mobileSdkFlutter),
          );
        },
      ),
    );
  }
}
