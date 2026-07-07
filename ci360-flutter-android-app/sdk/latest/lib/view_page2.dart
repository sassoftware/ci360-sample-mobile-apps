//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: view_page2.dart                                                                                  #
//# File Description: Displays SAS CI360 spot content retrieved via the SDK, supporting both HTML WebView rendering and JSON creative card rendering. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_html/flutter_html.dart';
// import 'package:webview_flutter/webview_flutter.dart';

import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:ron360flutterapp/json_creative_view.dart';
import 'package:ron360flutterapp/models/Json_Creative.dart';
import 'package:ron360flutterapp/spot_html_view.dart';

class ViewPage2 extends StatefulWidget {
  const ViewPage2({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  final MobileSdkFlutter mobileSdkFlutter;

  @override
  State<ViewPage2> createState() => _ViewPage2State();
}

class _ViewPage2State extends State<ViewPage2>
    with AutomaticKeepAliveClientMixin<ViewPage2> {
  String jsonSpotId = 'JsonSpot';
  String htmlSpotId = 'HtmlSpot';
  String jsonSpotData = '';
  String htmlSpotData = '';
  JsonCreative? jsonCreative;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Expanded(
      child: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.bottom,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 280,
                        width: 280,
                        child: (jsonCreative == null)
                            ? Text(jsonSpotData)
                            : JsonCreativeView(
                                jsonCreative: jsonCreative!,
                                spotId: jsonSpotId,
                                mobileSdkFlutter: widget.mobileSdkFlutter,
                              ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          widget.mobileSdkFlutter
                              .loadSpotData('JsonSpot', null)
                              .then((data) => setState(() {
                                    if (data.startsWith('No data:') ||
                                        data.startsWith('Error:')) {
                                      jsonSpotData = data;
                                      jsonCreative = null;
                                    } else {
                                      jsonSpotData = '';
                                      jsonCreative = JsonCreative.fromJson(
                                          jsonDecode(data));
                                    }
                                  }));
                        },
                        child: const Text(
                          'Get & Show "JsonSpot" Spot Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.grey,
                height: 2,
                width: double.infinity,
              ),
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      SizedBox(
                          height: 330,
                          width: 250,
                          child: (htmlSpotData == '' ||
                                  htmlSpotData.startsWith('No data:') ||
                                  htmlSpotData.startsWith('Error:'))
                              ? Text(htmlSpotData)
                              : SpotHtmlView(
                                  spotId: htmlSpotId,
                                  spotData: htmlSpotData,
                                  mobileSdkFlutter: widget.mobileSdkFlutter)),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          widget.mobileSdkFlutter
                              .loadSpotData(htmlSpotId, null)
                              .then((data) => setState(() {
                                    htmlSpotData = data;
                                  }));
                        },
                        child: const Text(
                          'Get & Show "HtmlSpot" Spot Data',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
