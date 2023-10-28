import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_sdk_flutter/views/sas_collector_interstitial_ad_view_controller.dart';

typedef OnInterstitialAdViewCreatedCallback = void Function(
    SASCollectorInterstitialAdViewController controller);

// ignore: must_be_immutable
class SASCollectorInterstitialAdView extends StatefulWidget {
  String? spotID;
  OnInterstitialAdViewCreatedCallback? onCreated;

  SASCollectorInterstitialAdView({Key? key, this.spotID, this.onCreated})
      : super(key: key);

  @override
  State<SASCollectorInterstitialAdView> createState() =>
      _SASCollectorInterstitialAdViewState();
}

class _SASCollectorInterstitialAdViewState
    extends State<SASCollectorInterstitialAdView> {
  @override
  Widget build(BuildContext context) {
    const viewType = 'interstitialAdView';
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'spotID': widget.spotID
    };

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: viewType,
          onPlatformViewCreated: onPlatformViewCreated,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: onPlatformViewCreated,
        );

      default:
        throw UnsupportedError("Unsupported platform view");
    }
  }

  Future<void> onPlatformViewCreated(int id) async {
    if (widget.onCreated == null) {
      return;
    }
    widget
        .onCreated!(SASCollectorInterstitialAdViewController.init(id, widget));
  }
}
