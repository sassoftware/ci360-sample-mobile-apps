//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';

import 'package:flutter/material.dart';

//ignore: must_be_immutable
class MessagesPage extends StatefulWidget {
  MessagesPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  // MobileSdkFlutter mobileSdkFlutter = MobileSdkFlutter();
  final smallInAppMsgController = TextEditingController();
  final largeInAppMsgController = TextEditingController();

  @override
  void initState() {
    smallInAppMsgController.text = 'RMFlutterSInAppEvent';
    largeInAppMsgController.text = 'RMFlutterLInAppEvent';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 300,
                  child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Small In-App Msg Event',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      autofocus: false,
                      controller: smallInAppMsgController),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      if (smallInAppMsgController.text.isNotEmpty) {
                        widget.mobileSdkFlutter
                            .addAppEvent(smallInAppMsgController.text, null);
                      }
                    },
                    child: const Text('Get In-App Msg')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  width: 300,
                  child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Large In-App Msg Event',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      autofocus: false,
                      controller: largeInAppMsgController),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      if (largeInAppMsgController.text.isNotEmpty) {
                        widget.mobileSdkFlutter
                            .addAppEvent(largeInAppMsgController.text, null);
                      }
                    },
                    child: const Text('Get In-App Msg')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
