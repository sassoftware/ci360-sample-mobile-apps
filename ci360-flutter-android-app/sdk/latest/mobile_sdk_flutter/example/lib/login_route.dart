import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'login_page.dart';

import 'package:flutter/material.dart';

//ignore: must_be_immutable
class LoginRoute extends StatelessWidget {
  LoginRoute({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => LoginPage(
                    mobileSdkFlutter: mobileSdkFlutter,
                  ));
        },
      ),
    );
  }
}
