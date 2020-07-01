import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
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
    return await rootBundle
        .loadString(assetName)
        .then<Map<String, dynamic>>((String data) => jsonDecode(data))
        .then((Map<String, dynamic> map) => new LottieComposition.fromMap(map));
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
                downloadFile(downloadUrl);
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

  //https://cdn1.school.etiantian.net/wxpdf/security/d5addd7ba490395fd03d6bbd315f8b03/5ed857c7/ett20/resource/50b699e5ab3480baab8583b5765ed5f8/b.doc
  Future<String> _localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var pdfDir = Directory(directory.path + '/pdf');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return pdfDir.path;
  }

  Future<File> _localFile(String url) async {
    final dir = await _localPath();
    String fileName = getFileName(url);
    return File('$dir/$fileName');
  }

  Future<File> writeCounter(Uint8List stream, String url) async {
    final file = await _localFile(url);
    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  downloadFile(String url) async {
    final dir = await _localPath();
    String fileName = getFileName(url);
    String filePath = '$dir/$fileName';
    File file = File(filePath);
    bool isExist = await file.exists();

    Fluttertoast.showToast(msg: '已下载，可以在我的下载查看');
    // 文件不存在, 再去下载
    if (!isExist) {
      writeCounter(await fetchPost(url), url);
    }
  }

  getFileName(String url) {
    print("${url.split('/').last}");

    List strList = url.split("/");
    if (strList.length > 3) {
      return "学案+" + strList[strList.length - 2] + "+" + strList.last;
    } else {
      return strList.last;
    }
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
