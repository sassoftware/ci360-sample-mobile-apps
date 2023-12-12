import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';
import 'package:ron360flutterapp/initialize_route.dart';
import 'package:ron360flutterapp/login_page.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/messages_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ron360flutterapp/details_page.dart';
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
  runApp(MaterialApp(
      home: MyHomePage(title: 'SAS CI360 ANDROID DEMO APP - FLUTTER')));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAS CI360 ANDROID DEMO APP - FLUTTER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SAS CI360 ANDROID DEMO APP'),
    );
  }
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
  String _platformVersion = 'Unknown';
  static MethodChannel channel = const MethodChannel('app_channel');
  // ignore: unused_field
  bool _geofenceStarted = false;
  // ignore: unused_field
  bool _pushNotificationReceived = false;
  // ignore: unused_field
  late final _tabController = TabController(length: 5, vsync: this);

  // ignore: unused_fieldd
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Settings',
      style: optionStyle,
    ),
    Text(
      'Index 3: Config',
      style: optionStyle,
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MyHomePage(title: 'SAS CI360 ANDROID DEMO APP - FLUTTER')),
        );
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsPage(
                  userID: username, mobileSdkFlutter: mobileSdkFlutter)),
        );
      }
      if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage(mobileSdkFlutter: mobileSdkFlutter)),
        );
      }
      if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  InitializeRoute(mobileSdkFlutter: mobileSdkFlutter)),
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
              msg: "User clicked the push notification link: $link");
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
    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/SASCI360.png'),
                  const Text(
                    'Home Screen',
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  //const SizedBox(height: 30),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsPage(
                                userID: username,
                                mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.person,
                      size: 24.0,
                    ),
                    label: Text('Profile',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MessagesPage(
                                mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.message,
                      size: 24.0,
                    ),
                    label: Text('Messaging',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.pages,
                      size: 24.0,
                    ),
                    label: Text('Content',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.login,
                      size: 24.0,
                    ),
                    label: Text('Login',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginPage(mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 24.0,
                    ),
                    label: Text('Settings',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 1,
                    height: 1,
                    indent: 30,
                    endIndent: 30,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InitializeRoute(
                                mobileSdkFlutter: mobileSdkFlutter)),
                      );
                    },
                    icon: Icon(
                      Icons.start_rounded,
                      size: 24.0,
                    ),
                    label: Text('Initialize SAS CI360',
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                            color: Colors.black)),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Settings',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Config',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue[800],
              onTap: _onItemTapped,
            )));
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
              builder: (BuildContext context) => HomePage(
                    mobileSdkFlutter: mobileSdkFlutter,
                  ));
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
              builder: (BuildContext context) => LoginPage(
                    mobileSdkFlutter: mobileSdkFlutter,
                  ));
        },
      ),
    );
  }
}
