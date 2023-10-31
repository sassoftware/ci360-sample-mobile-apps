import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/initialize_page.dart';
import 'package:ron360flutterapp/view_page.dart';
import 'package:ron360flutterapp/initialize_route.dart';
import 'package:fluttertoast/fluttertoast.dart';

MobileSdkFlutter mobileSdkFlutter = new MobileSdkFlutter();

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  // MobileSdkFlutter mobileSdkFlutter = MobileSdkFlutter();
  bool isEnabled = false;
  String bindingParam = '';
  String tagServer = '';
  String tenantId = '';
  String deviceId = '';
  String rstdeviceId = '';
  String appVersion = '';
  int _selectedIndex = 0;

  final pageUriController = TextEditingController();
  final eventNameController = TextEditingController();
  final attributeNameController = TextEditingController();
  final attributeValueController = TextEditingController();
  final inAppMsgController = TextEditingController();
  final txtversionController = TextEditingController();
  final txttagsvrController = TextEditingController();
  final txttenantidController = TextEditingController();
  final txtdeviceidController = TextEditingController();
  final txtresetdeviceidController = TextEditingController();
  final txtbndgparamController = TextEditingController();
  final inlineAdTextFieldController = TextEditingController();
  final interstitialAdTextFieldController = TextEditingController();
  late SASCollectorInterstitialAdViewController interstitialAdController;
  late SASCollectorInlineAdViewController inlineAdController;

  void onInlineAdCreated(SASCollectorInlineAdViewController controller) {
    inlineAdController = controller;
    inlineAdController.onLoadedHandler = () {
      Fluttertoast.showToast(
          msg: 'Inline Ad is loaded',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    };
  }

  void onInterstitialAdCreated(
      SASCollectorInterstitialAdViewController controller) {
    interstitialAdController = controller;
    interstitialAdController.onLoadedHandler = () {
      print('onLoadedHandler is overriden on the client side');
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
      Fluttertoast.showToast(
        msg: "The interstitial ad is closed by user",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18,
      );
    };
  }

  @override
  void initState() {
    inAppMsgController.text = 'flutter360InAppEvent';
    super.initState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
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
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeRoute(mobileSdkFlutter: mobileSdkFlutter)),
        );
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginRoute(mobileSdkFlutter: mobileSdkFlutter)),
        );
      }
      if (_selectedIndex == 2) {
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
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/SASCI360.png'),
              const Text('Inline Ad View'),
              SizedBox(
                  height: 400,
                  width: 400,
                  child: SASCollectorInlineAdView(
                    spotID: 'flutter360Spot',
                    onCreated: onInlineAdCreated,
                  )),
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
                    spotID: 'flutter360InterstitialSpot',
                    onCreated: onInterstitialAdCreated),
              ),
              //const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    widget.mobileSdkFlutter
                        .getApplicationVersion()
                        .then((version) => setState(() {
                              appVersion = version;
                              txtversionController.text = appVersion;
                            }));
                  },
                  child: const Text('Get App Version')),
              Material(
                  child: SizedBox(
                      width: 300,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txtversionController)
                      ]))),

              Divider(color: Colors.white),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    widget.mobileSdkFlutter
                        .getTagServer()
                        .then((server) => setState(() {
                              tagServer = server;
                              txttagsvrController.text = tagServer;
                            }));
                  },
                  child: const Text('Get TagServer')),
              Material(
                  child: SizedBox(
                      width: 250,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txttagsvrController)
                      ]))),

              Divider(color: Colors.white),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    widget.mobileSdkFlutter
                        .getTenantId()
                        .then((tenant) => setState(() {
                              tenantId = tenant;
                              txttenantidController.text = tenantId;
                            }));
                  },
                  child: const Text('Get Tenant ID')),
              Material(
                  child: SizedBox(
                      width: 250,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txttenantidController)
                      ]))),

              Divider(color: Colors.white),

              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    widget.mobileSdkFlutter
                        .getDeviceId()
                        .then((device) => setState(() {
                              deviceId = device;
                              txtdeviceidController.text = deviceId;
                            }));
                  },
                  child: const Text('Get Device ID')),
              Material(
                  child: SizedBox(
                      width: 250,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txtdeviceidController)
                      ]))),

              Divider(color: Colors.white),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  onPressed: () {
                    widget.mobileSdkFlutter
                        .resetDeviceId()
                        .then((rstdevice) => setState(() {
                              widget.mobileSdkFlutter
                                  .getDeviceId()
                                  .then((device) => setState(() {
                                        deviceId = device;
                                        txtresetdeviceidController.text =
                                            deviceId;
                                      }));
                              //txtresetdeviceidController.text = 'Device ID reset successfully!';
                            }));
                  },
                  child: const Text('Reset Device ID')),
              Material(
                  child: SizedBox(
                      width: 250,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txtresetdeviceidController)
                      ]))),

              Divider(color: Colors.white),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 40),
                    backgroundColor: Color.fromARGB(255, 7, 226, 255),
                    foregroundColor: Colors.black),
                onPressed: () {
                  widget.mobileSdkFlutter
                      .getSessionBindingParameter()
                      .then((param) => setState(() {
                            bindingParam = param;
                            txtbndgparamController.text = bindingParam;
                          }));
                },
                child: const Text('Check Binding Param'),
              ),
              Material(
                  child: SizedBox(
                      width: 250,
                      child: Column(children: [
                        TextField(
                            readOnly: true,
                            style: TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.black,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                            autofocus: true,
                            controller: txtbndgparamController)
                      ]))),

              Divider(color: Colors.white),

              Card(
                color: Colors.black,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'page uri',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            autofocus: false,
                            controller: pageUriController),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 40),
                            backgroundColor: Color.fromARGB(255, 7, 226, 255),
                            foregroundColor: Colors.black),
                        onPressed: () {
                          if (pageUriController.text.isNotEmpty) {
                            print("new page url: " + pageUriController.text);
                            widget.mobileSdkFlutter
                                .newPage(pageUriController.text);
                          }
                        },
                        child: const Text('Invoke New Page Event'),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(color: Colors.black),
              const SizedBox(height: 20),
              Card(
                color: Colors.black,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextField(
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'event name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ),
                            autofocus: false,
                            controller: eventNameController),
                      ),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'attribute name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          autofocus: false,
                          controller: attributeNameController,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextField(
                          decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'attribute value',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          autofocus: false,
                          controller: attributeValueController,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 40),
                            backgroundColor: Color.fromARGB(255, 7, 226, 255),
                            foregroundColor: Colors.black),
                        onPressed: () {
                          if (eventNameController.text.isEmpty ||
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
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: const Size(250, 40),
                    backgroundColor: Color.fromARGB(255, 7, 226, 255),
                    foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return ViewPage();
                  }));
                },
                child: const Text('360 Spots Page'),
              ),
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
              icon: Icon(Icons.business),
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
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
  }

  @override
  bool get wantKeepAlive => true;
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
