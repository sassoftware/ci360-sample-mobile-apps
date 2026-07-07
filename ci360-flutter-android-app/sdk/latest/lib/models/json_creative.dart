//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: json_creative.dart                                                                               #
//# File Description: Data model class for deserialising JSON-format SAS CI360 creative content including title, subtitle, bullet points, and button text. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
class JsonCreative {
  final String title;
  final String subTitle;
  final List<String> bullets;
  final String buttonText;

  JsonCreative(
      {required this.title,
      required this.subTitle,
      required this.bullets,
      required this.buttonText});

  factory JsonCreative.fromJson(Map<String, dynamic> json) {
    return JsonCreative(
        title: json['title'] as String,
        subTitle: json['subTitle'] as String,
        bullets: List<String>.from(json['bullets'] as List),
        buttonText: json['buttonText']);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subTitile': subTitle,
      'bullets': bullets,
      'buttonText': buttonText
    };
  }
}
