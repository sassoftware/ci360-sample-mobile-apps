//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: diagnostic_page.dart                                                                             #
//# File Description: Provides a diagnostic testing view for loading and displaying SAS CI360 inline spot ads, used for QA and troubleshooting purposes. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DiagnosticPage extends StatefulWidget {
  MobileSdkFlutter mobileSdkFlutter;

  DiagnosticPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  @override
  State<DiagnosticPage> createState() => _DiagnosticPageState();
}

class _DiagnosticPageState extends State<DiagnosticPage> {
  bool shouldViewSpot = false;
  bool spotIsShown = false;

  late SASCollectorInlineAdViewController inlineAdController;

  void onInlineAdCreated(SASCollectorInlineAdViewController controller) {
    inlineAdController = controller;
    inlineAdController.onLoadedHandler = () {
      widget.mobileSdkFlutter
          .addAppEvent('smInApp_Event_WW', null); //Wei_Wen_InApp_Event
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
              onPressed: () {
                setState(() {
                  shouldViewSpot = true;
                });
              },
              child: const Text('View Spot'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(150, 40)),
              onPressed: () {
                setState(() {
                  shouldViewSpot = false;
                });
              },
              child: const Text('Close Spot'),
            ),
          ],
        ),
        (shouldViewSpot)
            ? SizedBox(
                height: 430,
                width: 330,
                child: SASCollectorInlineAdView(
                  spotID: 'stethoscope_spot_WW', //'flower_spot_WW',
                  onCreated: onInlineAdCreated,
                ),
              )
            : Container()
      ],
    );
  }
}
