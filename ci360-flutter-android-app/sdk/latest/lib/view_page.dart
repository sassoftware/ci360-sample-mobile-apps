import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage>
    with AutomaticKeepAliveClientMixin<ViewPage> {
  final inlineAdTextFieldController = TextEditingController();
  final interstitialAdTextFieldController = TextEditingController();
  late SASCollectorInterstitialAdViewController interstitialAdController;
  late SASCollectorInlineAdViewController inlineAdController;

  void onInlineAdCreated(SASCollectorInlineAdViewController controller) {
    inlineAdController = controller;
    inlineAdController.onLoadedHandler = () {
      Fluttertoast.showToast(
          msg: 'Inline Ad is loaded',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER);
    };
  }

  void onInterstitialAdCreated(
      SASCollectorInterstitialAdViewController controller) {
    interstitialAdController = controller;
    interstitialAdController.onLoadedHandler = () {
      print('onLoadedHandler is overriden on the client side');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      }
    };

    interstitialAdController.onDefaultLoadedHandler = () {
      print('onDefaultLoadedHandler is overriden on the client side');
    };
    interstitialAdController.onLoadFailedHandler = () {
      print('onLoadFailedHandler is overriden on the client side');
    };
    interstitialAdController.onExpandFinishedHandler = () {
      print('onExpandFinishedHandler is overriden on the client side');
    };
    interstitialAdController.onActionFinishedHandler = () {
      print('actionFinishedHandler is overriden on the client side');
    };
    interstitialAdController.onClosedHandler = () {
      print("The closedHandler is overriden on the client side");
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
      Fluttertoast.showToast(
        msg: "The interstitial ad is closed by user",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 18,
      );
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  // ignore: must_call_super
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
                      spotID: 'wei_wen_spot3',
                      onCreated: onInlineAdCreated,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Interstitial Ad View'),
                  ElevatedButton(
                      onPressed: () {
                        interstitialAdController.showAd();
                      },
                      child: const Text('Show Interstitial Ad')),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 3,
            height: 4,
            child: SASCollectorInterstitialAdView(
                spotID: 'interstitial_spot',
                onCreated: onInterstitialAdCreated),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
