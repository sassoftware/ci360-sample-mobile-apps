import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  // MobileSdkFlutter mobileSdkFlutter = MobileSdkFlutter();
  bool isEnabled = false;
  String bindingParam = '';
  String tagServer = '';
  String tenantId = '';
  String deviceId = '';
  String appVersion = '';

  final pageUriController = TextEditingController();
  final eventNameController = TextEditingController();
  final attributeNameController = TextEditingController();
  final attributeValueController = TextEditingController();
  final inAppMsgController = TextEditingController();

  @override
  void initState() {
    inAppMsgController.text = 'Wei_Wen_InApp_Event';
    super.initState();
  }

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
                              .getApplicationVersion()
                              .then((version) => setState(() {
                                    appVersion = version;
                                  }));
                        },
                        child: const Text('Get App Version')),
                    Text(appVersion),
                  ]),
            ),
          ),
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
                              .getTagServer()
                              .then((server) => setState(() {
                                    tagServer = server;
                                  }));
                        },
                        child: const Text('Get TagServer')),
                    Text(tagServer),
                  ]),
            ),
          ),
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
                              .getTenantId()
                              .then((tenant) => setState(() {
                                    tenantId = tenant;
                                  }));
                        },
                        child: const Text('Get Tenant ID')),
                    Text(tenantId),
                  ]),
            ),
          ),
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
          SizedBox(
            width: 300,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      widget.mobileSdkFlutter
                          .getSessionBindingParameter()
                          .then((param) => setState(() {
                                bindingParam = param;
                              }));
                    },
                    child: const Text('Check Binding Param'),
                  ),
                  Text(bindingParam),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'page uri',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        autofocus: false,
                        controller: pageUriController),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      if (pageUriController.text.isNotEmpty) {
                        print("new page url: " + pageUriController.text);
                        widget.mobileSdkFlutter.newPage(pageUriController.text);
                      }
                    },
                    child: const Text('Invoke New Page Event'),
                  ),
                ],
              ),
            ),
          ),
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
                        controller: eventNameController),
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
                      controller: attributeNameController,
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
                      controller: attributeValueController,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 40)),
                    onPressed: () {
                      if (eventNameController.text.isEmpty ||
                          attributeNameController.text.isEmpty ||
                          attributeValueController.text.isEmpty) {
                        return;
                      }
                      widget.mobileSdkFlutter.addAppEvent(
                          eventNameController.text, {
                        attributeNameController.text:
                            attributeValueController.text
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
