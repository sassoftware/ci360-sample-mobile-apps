import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

//ignore: must_be_immutable
class DeviceId extends StatefulWidget {
  DeviceId({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter; //add 'final mobileSdkFlutterPlugin = MobileSdkFlutter(); from main.dart' or higher state screen to share object state between screens

  @override
  State<DeviceId> createState() => _DeviceIdState();
}

class _DeviceIdState extends State<DeviceId>
    with AutomaticKeepAliveClientMixin<DeviceId> {
  String deviceId = '';

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
                              .getDeviceId()
                              .then((device) => setState(() {
                                    deviceId = device;
                                  }));
                        },
                        child: const Text('Get Device ID')),
                    Text(deviceId),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
