import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';

import 'package:flutter/material.dart';

//ignore: must_be_immutable
class ConfigPage extends StatefulWidget {
  ConfigPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final appIdController = TextEditingController();
  final tagServerController = TextEditingController();
  final tenantIdController = TextEditingController();

  @override
  void initState() {
    tenantIdController.text = '652335ef4d00013c6c2ca636';
    appIdController.text = '123';
    tagServerController.text = 'https://execution-training.ci360.sas.com/t/mobile';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          const Text('Config CI360 SDK'),
          TextField(
              decoration: const InputDecoration(
                labelText: 'Tenant ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              autofocus: false,
              controller: tenantIdController),
          const SizedBox(height: 20),
          TextField(
              decoration: const InputDecoration(
                labelText: 'App ID',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              autofocus: false,
              controller: appIdController),
          const SizedBox(height: 20),
          TextField(
              decoration: const InputDecoration(
                labelText: 'Tag Server URL',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
              ),
              autofocus: false,
              controller: tagServerController),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
              onPressed: () {
                if (tenantIdController.text.isNotEmpty &&
                    tagServerController.text.isNotEmpty &&
                    appIdController.text.isNotEmpty) {
                  widget.mobileSdkFlutter
                      .setTenant(tenantIdController.text, tagServerController.text, appIdController.text);
                }
              },
              child: const Text('Apply Config')),
        ],
      ),
    );
  }
}
