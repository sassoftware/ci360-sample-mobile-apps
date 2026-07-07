//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: initialize_page.dart                                                                             #
//# File Description: Handles SAS CI360 SDK tenant initialisation, allowing the user to enter Tenant ID, Tag Server URL, and Mobile App ID to configure the SDK. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/constants.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/login_page.dart';
import 'package:ron360flutterapp/app_theme.dart';

//ignore: must_be_immutable
class InitializePage extends StatefulWidget {
  InitializePage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<InitializePage> createState() => _InitializePageState();
}

class _InitializePageState extends State<InitializePage>
    with AutomaticKeepAliveClientMixin<InitializePage> {
  final textFieldController = TextEditingController();
  final typeList = [identityTypeCustomerId, identityTypeLogin];
  String selectedType = '';
  int _selectedIndex = 0;

  final TenantIDFieldController = TextEditingController();
  final TagServerURLFieldController = TextEditingController();
  final MobileAppIDFieldController = TextEditingController();
  final ResultFieldController = TextEditingController();

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
        Navigator.of(context, rootNavigator: true)
            .popUntil((route) => route.isFirst);
      }
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  LoginRoute(mobileSdkFlutter: mobileSdkFlutter)),
        );
      }
    });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final connectedTenant = AppState.instance.connectedTenantId;
    final connectedServer = AppState.instance.connectedTagServer;

    // ── Already connected ────────────────────────────────────────────────
    if (connectedTenant.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Initialize CI360')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/SASCI360.png', height: 56),
                      const SizedBox(height: 12),
                      Text('Connected to CI360',
                          style: tt.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('This app is connected to a CI360 tenant',
                          style: tt.bodyMedium?.copyWith(color: kTextMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: kPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.cloud_done_rounded,
                                  color: kPrimary, size: 26),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Active Tenant',
                                      style: tt.labelSmall
                                          ?.copyWith(color: kTextMuted)),
                                  Text(connectedTenant,
                                      style: tt.titleSmall?.copyWith(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        InfoRow(label: 'Tag Server', value: connectedServer),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                AppState.instance.connectedTenantId = '';
                                AppState.instance.connectedTagServer = '';
                              });
                            },
                            icon: const Icon(Icons.cloud_off_rounded),
                            label: const Text('Disconnect'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              side: BorderSide(color: Colors.red.shade300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LoginRoute(mobileSdkFlutter: mobileSdkFlutter),
                    ),
                  ),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      );
    }

    // ── Not connected — show config form ─────────────────────────────────
    return Scaffold(
      appBar: AppBar(title: const Text('Initialize CI360')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // \u2500\u2500 Header \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/SASCI360.png', height: 56),
                    const SizedBox(height: 12),
                    Text('Connect to a Tenant',
                        style: tt.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Enter your CI360 tenant configuration',
                        style: tt.bodyMedium?.copyWith(color: kTextMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // \u2500\u2500 Config card \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tenant Configuration',
                          style: tt.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 16),
                      TextField(
                        controller: TenantIDFieldController,
                        onTap: TenantIDFieldController.clear,
                        decoration: const InputDecoration(
                          labelText: 'Tenant ID',
                          hintText: 'e.g. da1a105f5300013b...',
                          prefixIcon: Icon(Icons.business_outlined),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: TagServerURLFieldController,
                        onTap: TagServerURLFieldController.clear,
                        decoration: const InputDecoration(
                          labelText: 'Tag Server URL',
                          hintText: 'https://...',
                          prefixIcon: Icon(Icons.link_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: MobileAppIDFieldController,
                        onTap: MobileAppIDFieldController.clear,
                        decoration: const InputDecoration(
                          labelText: 'Mobile Application ID',
                          hintText: 'As defined in CI360',
                          prefixIcon: Icon(Icons.apps_rounded),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (TenantIDFieldController.text.trim().isEmpty) {
                            TenantIDFieldController.text =
                                'Please enter a Tenant ID';
                            return;
                          }
                          if (TagServerURLFieldController.text.trim().isEmpty) {
                            TagServerURLFieldController.text =
                                'Please enter a Tag Server URL';
                            return;
                          }
                          if (MobileAppIDFieldController.text.trim().isEmpty) {
                            MobileAppIDFieldController.text =
                                'Please enter a Mobile Application ID';
                            return;
                          }
                          widget.mobileSdkFlutter
                              .setTenant(
                            TenantIDFieldController.text.trim(),
                            TagServerURLFieldController.text.trim(),
                            MobileAppIDFieldController.text.trim(),
                          )
                              .then((success) {
                            if (success) {
                              setState(() {
                                AppState.instance.connectedTenantId =
                                    TenantIDFieldController.text.trim();
                                AppState.instance.connectedTagServer =
                                    TagServerURLFieldController.text.trim();
                                ResultFieldController.text =
                                    'Successfully connected to the tenant!';
                              });
                            } else {
                              ResultFieldController.text =
                                  'Connection could not be established.';
                              showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  title: Text('Connection Failed'),
                                  content: Text(
                                      'Could not connect to the CI360 tenant. Please check your configuration.'),
                                ),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.cloud_done_outlined),
                        label: const Text('Connect'),
                      ),
                      const SizedBox(height: 12),
                      // Result field
                      TextField(
                        controller: ResultFieldController,
                        readOnly: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.info_outline),
                          hintText: 'Connection status will appear here',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // \u2500\u2500 Login shortcut \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        LoginRoute(mobileSdkFlutter: mobileSdkFlutter),
                  ),
                ),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Continue to Login'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    TenantIDFieldController.dispose();
    TagServerURLFieldController.dispose();
    MobileAppIDFieldController.dispose();
    ResultFieldController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
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
