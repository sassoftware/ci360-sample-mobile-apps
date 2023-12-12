import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class DetachIdentity extends StatelessWidget {
  DetachIdentity(this.userId, this.mobileSdkFlutter);

  final MobileSdkFlutter mobileSdkFlutter; //add 'final mobileSdkFlutterPlugin = MobileSdkFlutter(); from main.dart' or higher state screen to share object state between screens
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(250, 30),
            ),
            onPressed: () {
              mobileSdkFlutter.detachIdentity().then((success) => {
                    if (success)
                      {Navigator.of(context).pop()}
                    else
                      {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: const Text("Error"),
                                  content: const Text("Detach identity failed."),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
                                  ],
                                ))
                      }
                  });
            },
            child: const Text('Detach Identity')),
      ],
    );
  }
}
