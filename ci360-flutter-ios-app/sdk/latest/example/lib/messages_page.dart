import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';

import 'package:plain_notification_token/plain_notification_token.dart';

import 'package:flutter/material.dart';

import 'dart:io' show Platform;

//ignore: must_be_immutable
class MessagesPage extends StatefulWidget {
  MessagesPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final largeInAppMsgController = TextEditingController();
  final smallInAppMsgController = TextEditingController();

  final plainNotificationToken = PlainNotificationToken();

  @override
  Future<String?> getAPNToken() async {
    if (Platform.isIOS) {
      plainNotificationToken.requestPermission();
      
      // If you want to wait until Permission dialog close,
      // you need wait changing setting registered. 
      await plainNotificationToken.onIosSettingsRegistered.first;
    }

    return await plainNotificationToken.getToken();
  }

  @override
  void initState() {
    smallInAppMsgController.text = 'small_event_name';
    largeInAppMsgController.text = 'large_event_name';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GCI App - Messages'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
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
            const SizedBox(height: 20),
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
                  if (smallInAppMsgController.text.isNotEmpty) {
                    widget.mobileSdkFlutter
                        .addAppEvent(largeInAppMsgController.text, null);
                  }
                },
                child: const Text('Get In-App Msg')),
          ],
        ),
      ),
    );
  }
}
