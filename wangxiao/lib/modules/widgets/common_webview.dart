import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:online_school/common/common_tool_manager/common_tool_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'common_webview_page.dart';

///
/// @name CommonWebview
/// @description 通用Webview 组件
/// @author liuca
/// @date 2020-01-10
///
class CommonWebview extends StatefulWidget {
  final String initialUrl;
  final String title;
  final Set<JavascriptChannel> javascriptChannels;
  final Widget action;

  const CommonWebview({
    Key key,
    this.initialUrl,
    this.title,
    this.javascriptChannels,
    this.action,
  }) : super(key: key);

  @override
  _CommonWebviewState createState() => _CommonWebviewState();
}

class _CommonWebviewState extends State<CommonWebview> with SingleTickerProviderStateMixin {

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var _index = 0;

  Future<LottieComposition> loadAsset(String assetName) async {
    var assetData = await rootBundle.load(assetName);
    return await LottieComposition.fromByteData(assetData);
  }

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'native', onMessageReceived: (JavascriptMessage message) {
          print("消息message:${message.message}");
          bool type = message.message is String;
          Map map;
          print("type:$type");
          if (message.message is String) {
            map = json.decode(message.message);
            print("map:$map");
            if (map != null) {
              String downloadUrl = map["xiazai"];
              String checkXueAn = map["xuean"];
              if (downloadUrl != null) {
                print("学案下载地址:$downloadUrl");
                CommonToolManager.downloadXueAnFile(downloadUrl);
                //downloadFile(downloadUrl);
              }

              if (checkXueAn != null) {
                print("查看学案的地址:$checkXueAn");
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return WebviewPage(checkXueAn, title: '学案');
                }));
              }
            }
          } else if (message.message is Map) {

          }

    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title ?? '';
    return WillPopScope(
      onWillPop: () async {
        _controller.future.then((controller) {
          controller.evaluateJavascript('document.body.remove()');
        });
        var ctl = await _controller.future;
        if (await ctl.canGoBack()) {
          ctl.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[widget.action ?? Container()],
          centerTitle: Platform.isIOS ? true : false,
          elevation: 1,
          title: Text(title,),
          backgroundColor: Colors.white,
        ),
        resizeToAvoidBottomPadding: true,
        body: Container(
            // padding: EdgeInsets.all(32.0),
            child: IndexedStack(index: _index, children: <Widget>[
          Center(child: CircularProgressIndicator()),
          WebView(
            initialUrl: widget.initialUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptChannels: widget.javascriptChannels ??
                <JavascriptChannel>[
                  _alertJavascriptChannel(context),
                ].toSet(),
            onPageFinished: (String url) {
              print('Page finished loading: $url');
              setState(() {
                _index = 1;
              });
            },
          ),
        ])),
      ),
    );
  }
}
