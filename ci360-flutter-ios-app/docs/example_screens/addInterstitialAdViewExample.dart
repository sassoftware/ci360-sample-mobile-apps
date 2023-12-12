import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class InterstitialAdView extends StatefulWidget {
  const InterstitialAdView({Key? key}) : super(key: key);

  @override
  State<InterstitialAdView> createState() => _InterstitialAdViewState();
}
  //Interstitial spots work similar to pop-up adds. A window pops up to show HTML content served from CI360
class _InterstitialAdViewState extends State<InterstitialAdView>
    with AutomaticKeepAliveClientMixin<InterstitialAdView> {
  final interstitialAdTextFieldController = TextEditingController();

  //We initialize an object here from /base/lib/views/sas_collector_interstitial_ad.* to handle this function.
  late SASCollectorInterstitialAdViewController interstitialAdController;

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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
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
                spotID: 'SPOT_ID_HERE',
                onCreated: onInterstitialAdCreated),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
