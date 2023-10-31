import 'package:flutter/cupertino.dart';
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

class _LoginPageState extends State<LoginPage>
    with AutomaticKeepAliveClientMixin<LoginPage> {
  final textFieldController = TextEditingController();
  final typeList = [identityTypeCustomerId, identityTypeLogin];
  String selectedType = '';

  @override
  void initState() {
    selectedType = typeList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 200,
        ),
        const Text('Please Log In'),
        const SizedBox(height: 10),
        SizedBox(
          width: 300,
          child: TextField(
            decoration: const InputDecoration(
                labelText: 'Enter ID',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)))),
            autofocus: true,
            controller: textFieldController,
          ),
        ),
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
                      .toList()),
            )
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(300, 40),
          ),
          onPressed: () {
            widget.mobileSdkFlutter
                .identity(textFieldController.text, selectedType)
                .then((success) => {
                      if (success)
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return DetailsPage(textFieldController.text,
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
