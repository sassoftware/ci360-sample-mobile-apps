import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

//ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin<SettingsPage> {
  String appVersion = '';
  final attributeNameController = TextEditingController();
  final attributeValueController = TextEditingController();
  String bindingParam = '';
  String deviceId = '';
  final eventNameController = TextEditingController();
  final inAppMsgController = TextEditingController();
  // MobileSdkFlutter mobileSdkFlutter = MobileSdkFlutter();
  bool isEnabled = false;

  final pageUriController = TextEditingController();
  String tagServer = '';
  String tenantId = '';

  @override
  void initState() {
    inAppMsgController.text = 'Wei_Wen_InApp_Event';
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text('SDK Initialization and Identity'),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
                onPressed: () {
                  widget.mobileSdkFlutter.initializeCollection();
                },
                child: const Text('Initialize CI360')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
                onPressed: () {
                  widget.mobileSdkFlutter.detachIdentity();
                },
                child: const Text('Detach Identity')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
                onPressed: () {
                  widget.mobileSdkFlutter.shutdownAndDetachIdentity();
                },
                child: const Text('Detach and Shutdown')),
            ElevatedButton(
                style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
                onPressed: () {
                  widget.mobileSdkFlutter.shutdown();
                  widget.mobileSdkFlutter.initializeCollection();
                },
                child: const Text('New Session')),
            const SizedBox(height: 25),
            const Text('Send CI360 Event'),
            const SizedBox(height: 5),
            TextField(
                  decoration: const InputDecoration(
                    labelText: 'event name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                  autofocus: false,
                  controller: eventNameController),
            const SizedBox(height: 10),
            TextField(
                decoration: const InputDecoration(
                    labelText: 'attribute name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                autofocus: false,
                controller: attributeNameController,
            ),
            const SizedBox(height: 10),
            TextField(
                decoration: const InputDecoration(
                    labelText: 'attribute value',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)))),
                autofocus: false,
                controller: attributeValueController,
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
              onPressed: () {
                if (eventNameController.text.isEmpty ||
                    attributeNameController.text.isEmpty ||
                    attributeValueController.text.isEmpty) {
                  return;
                }
                widget.mobileSdkFlutter.addAppEvent(eventNameController.text, {
                  attributeNameController.text: attributeValueController.text
                });
              },
              child: const Text('Submit Event'),
            ),
          ],
        ),
      ),
    );
  }
}
