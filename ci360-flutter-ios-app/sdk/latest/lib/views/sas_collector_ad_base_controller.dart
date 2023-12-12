import 'package:flutter/services.dart';

class SASCollectorAdBaseController {
  late MethodChannel channel;
  late Function onDefaultLoadedHandler;
  late Function onLoadedHandler;
  late Function onLoadFailedHandler;
  late Function onWillBeginActionHandler;
  late Function onActionFinishedHandler;
  late Function onWillExpandHandler;
  late Function onExpandFinishedHandler;
  late Function onWillCloseHandler;
  late Function onClosedHandler;
  late Function onWillResizeHandler;
  late Function onResizeFinishedHandler;

  SASCollectorAdBaseController(String channelId) {
    channel = MethodChannel(channelId);
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'adLoaded':
          onLoadedHandler();
          break;
        case 'adDefaultLoaded':
          onDefaultLoadedHandler();
          break;
        case 'adLoadFailed':
          String err = call.arguments["error"];
          String failingUrl = call.arguments["url"];
          onLoadFailedHandler(err, failingUrl);
          break;
        case 'adWillClose':
          bool willClose = call.arguments["willClose"];
          onWillCloseHandler(willClose);
          break;
        case 'adClosed':
          onClosedHandler();
          break;
        case 'adWillBeginAction':
          bool willBeginAction = call.arguments["willBeginAction"];
          onWillBeginActionHandler(willBeginAction);
          break;
        case 'adActionFinished':
          onActionFinishedHandler();
          break;
        case 'adWillResize':
          bool willResize = call.arguments["willResize"];
          onWillResizeHandler(willResize);
          break;
        case 'adResizeFinished':
          onResizeFinishedHandler();
          break;
        case 'adWillExpand':
          String url = call.arguments["url"];
          bool willExpand = call.arguments["willExpand"];
          onWillExpandHandler(url, willExpand);
          break;
        case 'adExpandFinished':
          onExpandFinishedHandler();
          break;
        default:
          break;
      }
    });

    onLoadedHandler = () {
      print('onLoadedHandler');
    };

    onDefaultLoadedHandler = () {
      print('onDefaultLoadedHandler');
    };

    onLoadFailedHandler = (String err, String url) {
      print('onLoadFailedHandler with error: $err and failing url: $url');
    };

    onWillBeginActionHandler = (bool willBeginAction) {
      print("onWillBeginActionHandler: $willBeginAction");
    };

    onActionFinishedHandler = () {
      print('actionFinishedHandler');
    };

    onResizeFinishedHandler = () {
      print('onResizeFinishedHandler');
    };

    onExpandFinishedHandler = () {
      print('onExpandFinishedHandler');
    };

    onWillExpandHandler = (String url, bool willExpand) {
      print('onWillExpandHandler: $url, $willExpand');
    };

    onWillCloseHandler = (bool willClose) {
      print("onWillCloseHandler: $willClose");
    };

    onClosedHandler = () {
      print('closedHandler');
    };
  }
}
