//
//#*************************************************************************************************************#
//# Application Name: SAS CI360 Flutter Demo Application                                                        #
//# File Name: initialize_route.dart                                                                            #
//# File Description: Navigator wrapper that hosts the InitializePage within a routed navigator, used as a bottom navigation tab in the main app. #
//# Author: SAS Global CX-CI                                                                                    #
//# Date: 31-October-2023                                                                                       #
//# Updated: 5-May-2026                                                                                         #
//# Copyright  2026, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.                                   #
//# SPDX-License-Identifier: Apache-2.0                                                                         #
//#*************************************************************************************************************#
//
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'initialize_page.dart';

import 'package:flutter/material.dart';

//ignore: must_be_immutable
class InitializeRoute extends StatelessWidget {
  InitializeRoute({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => InitializePage(
                    mobileSdkFlutter: mobileSdkFlutter,
                  ));
        },
      ),
    );
  }
}
