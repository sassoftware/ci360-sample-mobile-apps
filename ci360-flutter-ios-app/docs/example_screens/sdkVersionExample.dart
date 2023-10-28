import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter; //add 'final mobileSdkFlutterPlugin = MobileSdkFlutter(); from main.dart' or higher state screen to share object state between screens

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  String sdkVersion = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            width: 300,
            child: Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(250, 40)),
                        onPressed: () {
                          widget.mobileSdkFlutter
                              .getSDKVersion()
                              .then((version) => setState(() {
                                    sdkVersion = version;
                                  }));
                        },
                        child: const Text('Get SDK Version')),
                    Text(sdkVersion),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
