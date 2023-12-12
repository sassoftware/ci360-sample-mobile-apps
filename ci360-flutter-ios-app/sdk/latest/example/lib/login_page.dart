import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'details_page.dart';

//ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with AutomaticKeepAliveClientMixin<LoginPage> {
  final identityTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();

  String _dropdownValue = identityTypeCustomerId;

  @override
  void dispose() {
    identityTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  List<DropdownMenuItem<String>> get identityType {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: identityTypeCustomerId, child: Text("Customer ID")),
      const DropdownMenuItem(value: identityTypeEmail, child: Text("Email ID")),
      const DropdownMenuItem(value: identityTypeLogin, child: Text("Login ID")),
    ];
    return menuItems;
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column( children: [
        const SizedBox(
          height: 20,
        ),
        const Image(image: AssetImage('assets/images/sas-ci-360-logo1.png')),
        const SizedBox(
          height: 20,
        ),
          const Text(
            'Sign In',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(
                labelText: 'Enter ID', border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
            autofocus: true,
            controller: identityTextFieldController,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5)))),
            autofocus: true,
            controller: passwordTextFieldController,
          ),
        ),
        const SizedBox(height: 20),
        DropdownButton(items: identityType, onChanged: dropdownCallback, value: _dropdownValue),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 40),
          ),
          onPressed: () {
            widget.mobileSdkFlutter.identity(identityTextFieldController.text, _dropdownValue).then((success) => {
                  if (success)
                    {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return DetailsPage(identityTextFieldController.text, widget.mobileSdkFlutter);
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
          child: const Text("Login"),
        ),
      ]),
    );
  }
}
