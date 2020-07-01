import 'dart:io';

import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

///
/// @name WebviewPage
/// @description 通用网页页面
/// @author liuca
/// @date 2020-01-10
///
class WebviewPage extends StatefulWidget {
  final String url;
  Map<String, String> headers = {};
  final String title;

  WebviewPage(this.url, {this.headers, this.title});

  @override
  _WebviewPageState createState() => _WebviewPageState(url, headers: headers);
}

class _WebviewPageState extends State<WebviewPage> {
  var url;

  Map<String, String> headers;

  FlutterWebviewPlugin flutterWebviewPlugin;

  _WebviewPageState(this.url, {this.headers});

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin = new FlutterWebviewPlugin();
    // HACK of issue: https://github.com/fluttercommunity/flutter_webview_plugin/issues/162
    flutterWebviewPlugin.onDestroy.listen((_) {
      debugLog('DISTROY!!!');
      flutterWebviewPlugin.dispose();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
    flutterWebviewPlugin.onBack.listen((_) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    debugLog('DISPOSE!!!');
    // flutterWebviewPlugin.goBack();
    flutterWebviewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      scrollBar: false,
      headers: headers,
      url: url,
      // userAgent:
      //     'Mozilla/5.0 (Linux; Android 9; TNY-AL00 Build/HUAWEITNY-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/71.0.3578.98 Mobile Safari/537.36 EDX/org.edx.mobile/2.15.1',
      withJavascript: true,
      clearCookies: true,
      clearCache: true,
      withLocalStorage: true,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        elevation: 0,
        title: new Text(widget.title ?? 'webview course'),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
    );
  }
}
