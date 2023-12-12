import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/home_page.dart';
import 'package:ron360flutterapp/login_route.dart';
import 'package:ron360flutterapp/initialize_route.dart';

String userID = '';

//ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  DetailsPage({Key? key, required this.userID, required this.mobileSdkFlutter})
      : super(key: key);
  final String userID;
  MobileSdkFlutter mobileSdkFlutter;

  var singl = Singleton.instance;

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
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: new Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Image.asset('assets/SASCI360.png'),
        Text(
          'Welcome, ${widget.userID}!',
          style: GoogleFonts.lato(
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue),
        ),
        const SizedBox(height: 20),
        Text('Connection Details:',
            style: GoogleFonts.lato(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
                //textStyle: TextStyle(decoration: TextDecoration.underline),
                )),
        const SizedBox(height: 20),
        DataTable(
          columns: [
            DataColumn(
                label: Text('Attribute',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Value',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Tenant ID')),
              DataCell(Text('$tenantId'))
            ]),
            DataRow(cells: [
              DataCell(Text('Device ID')),
              DataCell(Text('$deviceId'))
            ]),
            DataRow(cells: [
              DataCell(Text('App Version')),
              DataCell(Text('$appVersion'))
            ]),
            DataRow(cells: [
              DataCell(Text('Platform Version')),
              DataCell(Text('$platformVersion'))
            ]),
            DataRow(cells: [
              DataCell(Text('Tag Server')),
              DataCell(Text('$tagServer'))
            ]),
          ],
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(250, 30),
            ),
            onPressed: () {
              mobileSdkFlutter.detachIdentity().then((success) => {
                    if (success)
                      {Navigator.of(context).pop()}
                    else
                      {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text("Error"),
                                  content:
                                      const Text("Detach identity failed."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK')),
                                  ],
                                ))
                      }
                  });
            },
            child: const Text('Detach Identity/Logout')),        
      ],
    )
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
        )
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

class Singleton {
  String myUsername = '';
  Singleton._private();

  static Singleton _instance = Singleton._private();
  static Singleton get instance => _instance;
}
