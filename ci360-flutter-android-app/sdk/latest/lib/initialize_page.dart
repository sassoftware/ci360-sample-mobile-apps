import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/login_page.dart';
import 'package:ron360flutterapp/initialize_route.dart';

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
    //return SingleChildScrollView(
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 200,
                ),
                Image.asset('assets/SASCI360.png'),
                const Text('Connect to a 360 Tenant'),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                      decoration: const InputDecoration(
                          labelText: 'Enter Tenant ID',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      autofocus: true,
                      controller: TenantIDFieldController,
                      onTap: (() {
                        TenantIDFieldController.clear();
                      })),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter Tag server URL',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    autofocus: true,
                    controller: TagServerURLFieldController,
                    onTap: (() {
                      TagServerURLFieldController.clear();
                    }),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText:
                            'Enter Mobile Application ID as defined in 360',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    autofocus: true,
                    controller: MobileAppIDFieldController,
                    onTap: (() {
                      MobileAppIDFieldController.clear();
                    }),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(300, 40),
                        backgroundColor: Color.fromARGB(255, 7, 226, 255),
                        foregroundColor: Colors.black),
                    onPressed: () {
                      if (TenantIDFieldController.text.isEmpty)
                        TenantIDFieldController.text =
                            "Please enter a 360 Tenant ID!";
                      if (TagServerURLFieldController.text.isEmpty)
                        TagServerURLFieldController.text =
                            "Please enter a 360 Tag Server URL!";
                      if (MobileAppIDFieldController.text.isEmpty)
                        MobileAppIDFieldController.text =
                            "Please enter a 360 Mobile Application ID!";
                      widget.mobileSdkFlutter
                          .setTenant(
                              TenantIDFieldController.text,
                              TagServerURLFieldController.text,
                              MobileAppIDFieldController.text)
                          /*
                        .then((value) =>
                            {ResultFieldController.text = "Success!"});
                        */
                          .then((success) => {
                                if (success)
                                  {
                                    ResultFieldController.text =
                                        "Successfully connected to the Tenant!"
                                  }
                                else
                                  {
                                    ResultFieldController.text =
                                        "360 Tenant connection could not be established!",
                                    showDialog(
                                        context: context,
                                        builder: (_) => const AlertDialog(
                                              title: Text("Error"),
                                              content: Text(
                                                  "360 Tenant connection could not be established!"),
                                            ))
                                  }
                              });
                    },
                    child: const Text("Connect")),
                SizedBox(
                  width: 300,
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    autofocus: true,
                    controller: ResultFieldController,
                  ),
                ),
                SizedBox(
                    child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(250, 40),
                      backgroundColor: Color.fromARGB(255, 7, 226, 255),
                      foregroundColor: Colors.black),
                  child: const Text('Login to this 360 Tenant'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginRoute(mobileSdkFlutter: mobileSdkFlutter)),
                    );
                  },
                ))
              ]),
        )),
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
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ));
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
