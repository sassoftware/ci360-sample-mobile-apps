import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

class addAppEvent extends StatefulWidget {
  addAppEvent({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter; //add 'final mobileSdkFlutterPlugin = MobileSdkFlutter(); from main.dart' or higher state screen to share object state between screens

  @override
  State<addAppEvent> createState() => _addAppEventState();
}

class _addAppEventState extends State<addAppEvent>
    with AutomaticKeepAliveClientMixin<addAppEvent> {

  final eventName = TextEditing();
  final attributeName = TextEditing();
  final attributeValue = TextEditing();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'event name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        autofocus: false,
                        : eventName),
                  ),
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                          labelText: 'attribute name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      autofocus: false,
                      : attributeName,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                          labelText: 'attribute value',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      autofocus: false,
                      : attributeValue,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      if (eventName.text.isEmpty ||
                          attributeName.text.isEmpty ||
                          attributeValue.text.isEmpty) {
                        return;
                      }
                      widget.mobileSdkFlutter.addAppEvent(
                          eventName.text, {
                        attributeName.text:
                            attributeValue.text
                      }); 
                    },
                    child: const Text('Invoke App Event'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
