import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';
import 'package:mobile_sdk_flutter_example/messages_page.dart';
import 'view_page.dart';

//ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.mobileSdkFlutter}) : super(key: key);

  MobileSdkFlutter mobileSdkFlutter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  String appVersion = '';
  final attributeNameController = TextEditingController();
  final attributeValueController = TextEditingController();
  String bindingParam = '';
  String deviceId = '';
  final eventNameController = TextEditingController();
  // MobileSdkFlutter mobileSdkFlutter = MobileSdkFlutter();
  bool isEnabled = false;

  final pageUriController = TextEditingController();
  String tagServer = '';
  String tenantId = '';

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
          const SizedBox(height: 50),
          const Text(
            'Home Screen',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.mark_email_unread),
            style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
            label: const Text('Notifications'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return MessagesPage(mobileSdkFlutter: widget.mobileSdkFlutter);
                          }));
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.description),
            style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
            label: const Text('Content'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const ViewPage();
                          }));
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.search),
            style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
            label: const Text('Search'),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const ViewPage();
                          }));
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.extension),
            style: ElevatedButton.styleFrom(fixedSize: const Size(250, 40)),
            label: const Text('Initialize CI360'),
            onPressed: () {
              widget.mobileSdkFlutter.initializeCollection();
            },
          ),
        ],
      ),
    );
  }
}
