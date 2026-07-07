//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: json_creative_view.dart                                                                          #
//# File Description: Renders a JSON-format SAS CI360 creative as a styled card widget and registers the spot as viewable upon display in the UI. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ron360flutterapp/models/Json_Creative.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class JsonCreativeView extends StatelessWidget {
  final JsonCreative jsonCreative;
  final String spotId;
  final MobileSdkFlutter mobileSdkFlutter;

  const JsonCreativeView(
      {Key? key,
      required this.jsonCreative,
      required this.spotId,
      required this.mobileSdkFlutter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => mobileSdkFlutter.registerSpotViewable(spotId));

    return Card(
      margin: const EdgeInsets.all(4.0),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jsonCreative.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 2.0,
            ),
            Text(
              jsonCreative.subTitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(
              height: 4.0,
            ),
            ...jsonCreative.bullets.map(
              (bullet) => Padding(
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 4.0,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Expanded(
                      child: Text(
                        bullet,
                        style: const TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      mobileSdkFlutter.registerSpotClicked(spotId);
                    },
                    child: Text(jsonCreative.buttonText)))
          ],
        ),
      ),
    );
  }
}
