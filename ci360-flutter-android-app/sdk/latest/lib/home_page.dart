//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: home_page.dart                                                                                   #
//# File Description: Main dashboard page displaying SDK status, session binding parameters, and navigation tabs to the app's core features. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/initialize_page.dart';
import 'package:ron360flutterapp/spot_request_page.dart';
import 'package:ron360flutterapp/view_page.dart';
import 'package:ron360flutterapp/initialize_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ron360flutterapp/app_theme.dart';

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
        gravity: ToastGravity.CENTER,
      );
    };
  }

  void onInterstitialAdCreated(
    SASCollectorInterstitialAdViewController controller,
  ) {
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

  // ignore: unused_field
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

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
            builder: (context) =>
                LoginRoute(mobileSdkFlutter: mobileSdkFlutter),
          ),
        );
      }
      if (_selectedIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                InitializeRoute(mobileSdkFlutter: mobileSdkFlutter),
          ),
        );
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Content & Ads')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // -- SDK Info ---------------------------------------------------
            const SectionHeader('SDK Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InfoRow(
                      label: 'App Version',
                      value: appVersion,
                      onRefresh: () => widget.mobileSdkFlutter
                          .getApplicationVersion()
                          .then((v) => setState(() {
                                appVersion = v;
                              })),
                    ),
                    const Divider(height: 16),
                    InfoRow(
                      label: 'Tag Server',
                      value: tagServer,
                      onRefresh: () => widget.mobileSdkFlutter
                          .getTagServer()
                          .then((v) => setState(() {
                                tagServer = v;
                                txttagsvrController.text = v;
                              })),
                    ),
                    const Divider(height: 16),
                    InfoRow(
                      label: 'Tenant ID',
                      value: tenantId,
                      onRefresh: () => widget.mobileSdkFlutter
                          .getTenantId()
                          .then((v) => setState(() {
                                tenantId = v;
                              })),
                    ),
                    const Divider(height: 16),
                    InfoRow(
                      label: 'Device ID',
                      value: deviceId,
                      onRefresh: () => widget.mobileSdkFlutter
                          .getDeviceId()
                          .then((v) => setState(() {
                                deviceId = v;
                              })),
                    ),
                    const Divider(height: 16),
                    InfoRow(
                      label: 'Binding Param',
                      value: bindingParam,
                      onRefresh: () => widget.mobileSdkFlutter
                          .getSessionBindingParameter()
                          .then((v) => setState(() {
                                bindingParam = v;
                              })),
                    ),
                    const Divider(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () => widget.mobileSdkFlutter
                            .resetDeviceId()
                            .then((_) => widget.mobileSdkFlutter
                                .getDeviceId()
                                .then((v) => setState(() {
                                      deviceId = v;
                                      txtresetdeviceidController.text = v;
                                    }))),
                        icon: const Icon(Icons.restart_alt_rounded, size: 18),
                        label: const Text('Reset Device ID'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          textStyle: const TextStyle(fontSize: 13),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Event Tracking --------------------------------------------
            const SectionHeader('Event Tracking'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('New Page Event',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: pageUriController,
                      decoration: const InputDecoration(
                        labelText: 'Page URI',
                        hintText: 'e.g. app://home',
                        prefixIcon: Icon(Icons.link_rounded),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (pageUriController.text.isNotEmpty) {
                          widget.mobileSdkFlutter
                              .newPage(pageUriController.text);
                          Fluttertoast.showToast(msg: 'New page event sent');
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Send New Page Event'),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text('App Event',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: eventNameController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        prefixIcon: Icon(Icons.event_note_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: attributeNameController,
                            decoration: const InputDecoration(
                              labelText: 'Attribute Name',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: attributeValueController,
                            decoration: const InputDecoration(
                              labelText: 'Value',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (eventNameController.text.isEmpty ||
                            attributeNameController.text.isEmpty ||
                            attributeValueController.text.isEmpty) {
                          return;
                        }
                        widget.mobileSdkFlutter
                            .addAppEvent(eventNameController.text, {
                          attributeNameController.text:
                              attributeValueController.text,
                        });
                        Fluttertoast.showToast(msg: 'App event sent');
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Send App Event'),
                    ),
                  ],
                ),
              ),
            ),

            // -- Ad Spots --------------------------------------------------
            const SectionHeader('Ad Spots'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Inline Ad',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: inlineAdTextFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Inline Ad Spot ID',
                        hintText: 'flutter360Spot',
                        prefixIcon: Icon(Icons.image_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 200,
                        child: SASCollectorInlineAdView(
                          spotID: 'flutter360Spot',
                          onCreated: onInlineAdCreated,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text('Interstitial Ad',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: interstitialAdTextFieldController,
                      decoration: const InputDecoration(
                        labelText: 'Interstitial Ad Spot ID',
                        hintText: 'flutter360InterstitialSpot',
                        prefixIcon: Icon(Icons.fullscreen_rounded),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => interstitialAdController.showAd(),
                      icon: const Icon(Icons.play_circle_outline_rounded),
                      label: const Text('Show Interstitial Ad'),
                    ),
                    SizedBox(
                      width: 1,
                      height: 1,
                      child: SASCollectorInterstitialAdView(
                        spotID: 'flutter360InterstitialSpot',
                        onCreated: onInterstitialAdCreated,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // -- Content navigation ----------------------------------------
            const SectionHeader('Content Pages'),
            Card(
              child: Column(
                children: [
                  NavTile(
                    icon: Icons.grid_view_rounded,
                    iconColor: kIconPurple,
                    title: '360 Spots Page',
                    subtitle: 'Browse and preview CI360 ad spots',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ViewPage()),
                    ),
                  ),
                  NavTile(
                    icon: Icons.api_rounded,
                    iconColor: kIconTeal,
                    title: 'Content Server Request',
                    subtitle: 'Spot SDK calls and direct HTTP CSR API',
                    isLast: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SpotRequestPage(
                          mobileSdkFlutter: widget.mobileSdkFlutter,
                        ),
                      ),
                    ),
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
            builder: (BuildContext context) =>
                HomePage(mobileSdkFlutter: mobileSdkFlutter),
          );
        },
      ),
    );
  }
}
