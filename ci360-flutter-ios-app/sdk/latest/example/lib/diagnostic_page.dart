import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class DiagnosticPage extends StatefulWidget {
  DiagnosticPage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<DiagnosticPage> createState() => _DiagnosticPageState();
}

class _DiagnosticPageState extends State<DiagnosticPage> {
  late SASCollectorInlineAdViewController inlineAdController;
  bool shouldViewSpot = false;
  bool spotIsShown = false;

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
