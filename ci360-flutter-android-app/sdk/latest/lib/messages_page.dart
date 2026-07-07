//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: messages_page.dart                                                                               #
//# File Description: Provides controls to trigger small and large in-app message events via the SAS CI360 SDK for mobile messaging testing. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';

import 'package:flutter/material.dart';
import 'package:ron360flutterapp/app_theme.dart';

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
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Messaging')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // \u2500\u2500 Small In-App Message \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
            const SectionHeader('In-App Messages'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Small In-App Message',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Trigger a small in-app message from CI360.',
                        style: tt.bodySmall?.copyWith(color: kTextMuted)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: smallInAppMsgController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        prefixIcon: Icon(Icons.chat_bubble_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (smallInAppMsgController.text.isNotEmpty) {
                          widget.mobileSdkFlutter
                              .addAppEvent(smallInAppMsgController.text, null);
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Trigger Small In-App Message'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // \u2500\u2500 Large In-App Message \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Large In-App Message',
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Trigger a full-screen in-app message from CI360.',
                        style: tt.bodySmall?.copyWith(color: kTextMuted)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: largeInAppMsgController,
                      decoration: const InputDecoration(
                        labelText: 'Event Name',
                        prefixIcon: Icon(Icons.open_in_full_rounded),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (largeInAppMsgController.text.isNotEmpty) {
                          widget.mobileSdkFlutter
                              .addAppEvent(largeInAppMsgController.text, null);
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text('Trigger Large In-App Message'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
