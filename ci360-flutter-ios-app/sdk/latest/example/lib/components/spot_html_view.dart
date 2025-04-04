import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter_example/main.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_sdk_flutter/mobile_sdk_flutter.dart';

class SpotHtmlView extends StatefulWidget {
  const SpotHtmlView(
      {super.key,
      required this.spotId,
      required this.spotData,
      required this.mobileSdkFlutter});

  final String spotId;
  final String spotData;
  final MobileSdkFlutter mobileSdkFlutter;

  @override
  State<SpotHtmlView> createState() => _SpotHtmlViewState();
}

class _SpotHtmlViewState extends State<SpotHtmlView> {
  late WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.spotData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mobileSdkFlutterPlugin.registerSpotViewable(widget.spotId);
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        Positioned.fill(
            child: GestureDetector(
          onTap: () {
            mobileSdkFlutterPlugin.registerSpotClicked(widget.spotId);
          },
          child: Container(color: Colors.transparent),
        ))
      ],
    );
  }
}
