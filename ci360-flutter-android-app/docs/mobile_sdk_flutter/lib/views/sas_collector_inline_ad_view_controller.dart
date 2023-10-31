import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:mobile_sdk_flutter/views/sas_collector_ad_base_controller.dart';

class SASCollectorInlineAdViewController extends SASCollectorAdBaseController {
  late SASCollectorInlineAdView inlineAdView;

  SASCollectorInlineAdViewController.init(
      int id, SASCollectorInlineAdView adView)
      : super("inline_ad_controller_channel") {
    inlineAdView = adView;
  }

  void setView(SASCollectorInlineAdView view) {
    inlineAdView = view;
  }
}
