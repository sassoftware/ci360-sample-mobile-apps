import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class inlineAdView extends StatefulWidget {
  const inlineAdView({Key? key}) : super(key: key); 

  @override
  State<inlineAdView> createState() => _inlineAdViewState();
}

class _inlineAdViewState extends State<inlineAdView>
    with AutomaticKeepAliveClientMixin<inlineAdView> {

  //Initialize Variables for in-line Ad (Spot)
  final inlineAdTextFieldController = TextEditingController();
  final interstitialAdTextFieldController = TextEditingController();
  late SASCollectorInlineAdViewController inlineAdController;

  //Function for checking success of in-line ad load from CI360 Tenant
  void onInlineAdCreated(SASCollectorInlineAdViewController controller) {
    inlineAdController = controller;
    inlineAdController.onLoadedHandler = () {
      Fluttertoast.showToast(
          msg: 'Inline Ad is loaded',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Inline Ad View'),
                  SizedBox(
                    height: 430,
                    width: 330,
                    child: SASCollectorInlineAdView(
                      spotID: 'SPOT_ID_HERE',
                      onCreated: onInlineAdCreated,
                    ), //a widget has been built to initiate the function of an in-line spot for use with the mobile SDK. You can find these widget at /base/views/
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
