//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: login_page.dart                                                                                  #
//# File Description: Handles user identity login by allowing the user to submit a Customer ID or Login ID to identify themselves with the SAS CI360 SDK. #
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
import 'package:ron360flutterapp/details_page.dart';
import 'package:ron360flutterapp/initialize_page.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/app_theme.dart';

enum IDType { customer_id, login_id }

//ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  final textFieldController = TextEditingController();
  final typeList = [identityTypeCustomerId, identityTypeLogin];
  String selectedType = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    selectedType = typeList[0];
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
  // ignore: must_call_super, override_on_non_overriding_member
  IDType? _type = IDType.customer_id;
  // ignore: must_call_super
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final loggedInUser = AppState.instance.loggedInUser;

    // ── Already logged in ────────────────────────────────────────────────
    if (loggedInUser.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login / Identity')),
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
                      Text('Signed In',
                          style: tt.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('This device is linked to a CI360 identity',
                          style: tt.bodyMedium?.copyWith(color: kTextMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: kPrimary, size: 32),
                        ),
                        const SizedBox(height: 12),
                        Text(loggedInUser,
                            style: tt.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Identified user',
                            style: tt.bodySmall?.copyWith(color: kTextMuted)),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              widget.mobileSdkFlutter
                                  .detachIdentity()
                                  .then((success) {
                                if (success) {
                                  setState(() =>
                                      AppState.instance.loggedInUser = '');
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
                                      title: Text('Logout Failed'),
                                      content: Text(
                                          'Could not detach identity from CI360.'),
                                    ),
                                  );
                                }
                              });
                            },
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text('Log Out'),
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

    // ── Not logged in — show login form ──────────────────────────────────
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Identity')),
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
                    Text('Identify a User',
                        style: tt.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Link this device to a CI360 identity',
                        style: tt.bodyMedium?.copyWith(color: kTextMuted)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // \u2500\u2500 Form card \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: textFieldController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: 'User ID',
                          hintText: 'Enter customer or login ID',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Identity Type',
                          style: tt.labelMedium?.copyWith(
                              color: kTextMuted, letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      // \u2500\u2500 Segmented radio choices \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kBorder),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            RadioListTile<IDType>(
                              value: IDType.customer_id,
                              groupValue: _type,
                              title: const Text('Customer ID'),
                              dense: true,
                              activeColor: kPrimary,
                              onChanged: (v) => setState(() {
                                _type = v;
                                selectedType = 'customer_id';
                              }),
                            ),
                            const Divider(height: 1),
                            RadioListTile<IDType>(
                              value: IDType.login_id,
                              groupValue: _type,
                              title: const Text('Login ID'),
                              dense: true,
                              activeColor: kPrimary,
                              onChanged: (v) => setState(() {
                                _type = v;
                                selectedType = 'login_id';
                              }),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (textFieldController.text.trim().isEmpty) return;
                          widget.mobileSdkFlutter
                              .identity(
                                  textFieldController.text.trim(), selectedType)
                              .then((success) {
                            if (success) {
                              setState(() {
                                AppState.instance.loggedInUser =
                                    textFieldController.text.trim();
                              });
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                builder: (_) => DetailsPage(
                                  userID: textFieldController.text.trim(),
                                  mobileSdkFlutter: widget.mobileSdkFlutter,
                                ),
                              ))
                                  .then((_) {
                                if (mounted) setState(() {});
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => const AlertDialog(
                                  title: Text('Login Failed'),
                                  content: Text(
                                      'Could not identify user with CI360. Please check your ID and try again.'),
                                ),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.login_rounded),
                        label: const Text('Log In'),
                      ),
                    ],
                  ),
                ),
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

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
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
