//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: details_page.dart                                                                                #
//# File Description: Displays the logged-in user's profile details and the connected tenant/SDK configuration information after a successful identity login. #
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
import 'package:ron360flutterapp/login_route.dart';
import 'package:ron360flutterapp/app_theme.dart';

String userID = '';

//ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.userID, required this.mobileSdkFlutter})
      : super(key: key);
  final String userID;
  MobileSdkFlutter mobileSdkFlutter;

  var singl = AppState.instance;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  var tenantId;
  var tagServer;
  var appVersion;
  var platformVersion;
  var deviceId;
  int _selectedIndex = 0;

  void init() {
    mobileSdkFlutter.getTenantId().then((tenant) => setState(() {
          tenantId = tenant;
        }));
    mobileSdkFlutter.getTagServer().then((tagserver) => setState(() {
          tagServer = tagserver;
        }));
    mobileSdkFlutter.getApplicationVersion().then((appversion) => setState(() {
          appVersion = appversion;
        }));
    mobileSdkFlutter.getPlatformVersion().then((platversion) => setState(() {
          platformVersion = platversion;
        }));
    mobileSdkFlutter.getDeviceId().then((deviceid) => setState(() {
          deviceId = deviceid;
        }));
  }

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
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final hasUser = widget.userID.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (hasUser)
            TextButton.icon(
              onPressed: () {
                mobileSdkFlutter.detachIdentity().then((success) {
                  if (success) {
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Detach identity failed.'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK')),
                        ],
                      ),
                    );
                  }
                });
              },
              icon: const Icon(Icons.logout_rounded,
                  color: Colors.white, size: 18),
              label:
                  const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // \u2500\u2500 User banner \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
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
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: kPrimary, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasUser ? widget.userID : 'Guest',
                            style: tt.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            hasUser ? 'Identified user' : 'Not logged in',
                            style: tt.bodySmall?.copyWith(color: kTextMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // \u2500\u2500 Connection details \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
            const SectionHeader('Connection Details'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    InfoRow(label: 'Tenant ID', value: '${tenantId ?? ""}'),
                    const Divider(height: 16),
                    InfoRow(label: 'Tag Server', value: '${tagServer ?? ""}'),
                    const Divider(height: 16),
                    InfoRow(label: 'Device ID', value: '${deviceId ?? ""}'),
                    const Divider(height: 16),
                    InfoRow(label: 'App Version', value: '${appVersion ?? ""}'),
                    const Divider(height: 16),
                    InfoRow(
                        label: 'Platform', value: '${platformVersion ?? ""}'),
                  ],
                ),
              ),
            ),
            if (hasUser) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  mobileSdkFlutter.detachIdentity().then((success) {
                    if (success) {
                      Navigator.of(context).pop();
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Detach identity failed.'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK')),
                          ],
                        ),
                      );
                    }
                  });
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Detach Identity / Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                ),
              ),
            ],
          ],
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
