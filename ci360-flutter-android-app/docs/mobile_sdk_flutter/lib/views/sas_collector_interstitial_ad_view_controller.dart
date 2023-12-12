import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:mobile_sdk_flutter/views/sas_collector_ad_base_controller.dart';

class SASCollectorInterstitialAdViewController
    extends SASCollectorAdBaseController {
  late SASCollectorInterstitialAdView interstitalAdView;

  SASCollectorInterstitialAdViewController.init(
      int id, SASCollectorInterstitialAdView adView)
      : super('interstitial_controller_channel') {
    interstitalAdView = adView;
  }

  Future<void> showAd() async {
    return await channel.invokeMethod('showAd');
  }
}
