import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage(this.userId, this.mobileSdkFlutter, {super.key});

  final MobileSdkFlutter mobileSdkFlutter;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 200,
        ),
        Text(
          'Welcome, $userId',
          style: GoogleFonts.lato(
              fontStyle: FontStyle.italic,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
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
                                  content:
                                      const Text("Detach identity failed."),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK')),
                                  ],
                                ))
                      }
                  });
            },
            child: const Text('Detach Identity')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(250, 30),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Go Back"),
        ),
      ],
    );
  }
}
