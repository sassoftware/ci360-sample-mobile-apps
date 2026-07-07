//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: spot_html_view.dart                                                                              #
//# File Description: Renders SAS CI360 spot HTML content inside an embedded WebView and registers spot viewable and click events via the SDK. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       # 
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:flutter/material.dart';
import 'package:ron360flutterapp/main.dart';
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
