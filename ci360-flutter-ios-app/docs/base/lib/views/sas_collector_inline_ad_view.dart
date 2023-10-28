import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sas_collector_inline_ad_view_controller.dart';

typedef OnInlineAdViewCreatedCallback = void Function(
    SASCollectorInlineAdViewController controller);

//ignore: must_be_immutable
class SASCollectorInlineAdView extends StatefulWidget {
  String? spotID;
  SASCollectorInlineAdView({Key? key, this.spotID, this.onCreated})
      : super(key: key);
  OnInlineAdViewCreatedCallback? onCreated;

  @override
  State<SASCollectorInlineAdView> createState() =>
      _SASCollectorInlineAdViewState();
}

class _SASCollectorInlineAdViewState extends State<SASCollectorInlineAdView> {
  @override
  Widget build(BuildContext context) {
    const String viewType = 'inlineAdView';
    final Map<String, dynamic> creationParams = <String, dynamic>{
      "spotID": widget.spotID
    };

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return AndroidView(
          viewType: viewType,
          creationParams: creationParams,
          onPlatformViewCreated: onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          onPlatformViewCreated: onPlatformViewCreated,
          creationParamsCodec: const StandardMessageCodec(),
        );

      default:
        throw UnsupportedError('Unsupported platform view');
    }
  }

  Future<void> onPlatformViewCreated(int id) async {
    if (widget.onCreated == null) {
      return;
    }
    widget.onCreated!(SASCollectorInlineAdViewController.init(id, widget));
  }
}
