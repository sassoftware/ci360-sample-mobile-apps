import 'package:flutter/material.dart';
import 'package:mobile_sdk_flutter/sas_collector_sdk.dart';

//ignore: must_be_immutable
class NewPage extends StatefulWidget {
  NewPage({Key? key, required this.mobileSdkFlutter}) : super(key: key); 

  MobileSdkFlutter mobileSdkFlutter; //add 'final mobileSdkFlutterPlugin = MobileSdkFlutter(); from main.dart' or higher state screen to share object state between screens

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage>
  with AutomaticKeepAliveClientMixin<NewPage> {

  String _currentPageUri = '/home/NewPageScreen';

  @override
  void initState() {
    newPage(_currentPageUri); //initState runs when the screen is first shown so it's a good place to record page visited analytics
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
  }
  @override
  bool get wantKeepAlive => true;
}