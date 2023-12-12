import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/details_page.dart';
import 'package:ron360flutterapp/initialize_page.dart';
import 'package:ron360flutterapp/initialize_route.dart';
import 'package:ron360flutterapp/home_page.dart';

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
  // ignore: must_call_super, override_on_non_overriding_member
  IDType? _type = IDType.customer_id;
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
                const Text('Please Log In'),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: const InputDecoration(
                        labelText: 'Enter ID',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))),
                    autofocus: true,
                    controller: textFieldController,
                  ),
                ),
                /*
        const SizedBox(height: 20),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
                width: 320,
                child: Container(
                    height: 200.0,
                    child: CupertinoPicker(
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedType = typeList[index];
                          });
                        },
                        children: typeList
                            .map(
                              (t) => Center(
                                child: Text(
                                  t,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList()))),
                           
            ],
        ), 
        */
                Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Customer ID'),
                      leading: Radio<IDType>(
                        value: IDType.customer_id,
                        groupValue: _type,
                        onChanged: (IDType? value) {
                          setState(() {
                            _type = value;
                            selectedType = 'customer_id';
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Login ID'),
                      leading: Radio<IDType>(
                        value: IDType.login_id,
                        groupValue: _type,
                        onChanged: (IDType? value) {
                          setState(() {
                            _type = value;
                            selectedType = 'login_id';
                          });
                        },
                      ),
                    ),
                  ],
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
                    widget.mobileSdkFlutter
                        .identity(textFieldController.text, selectedType)
                        .then((success) => {
                              if (success)
                                {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return DetailsPage(
                                        userID: textFieldController.text,
                                        mobileSdkFlutter:
                                            widget.mobileSdkFlutter);
                                  }))
                                }
                              else
                                {
                                  showDialog(
                                      context: context,
                                      builder: (_) => const AlertDialog(
                                            title: Text("Error"),
                                            content: Text("Login failed."),
                                          ))
                                }
                            });
                  },
                  child: const Text("Log In"),
                ),
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
