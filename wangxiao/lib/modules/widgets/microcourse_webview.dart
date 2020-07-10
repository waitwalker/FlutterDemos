import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

///
/// @name MicrocourseWebPage
/// @description 做题web页面
/// @author liuca
/// @date 2020-01-11
///
class MicrocourseWebPage extends StatefulWidget {
  final String initialUrl;
  num resourceId;
  String resourceName;
  bool isReport;
  bool isAb;
  String srcABPaperQuesIds;
  final Set<JavascriptChannel> javascriptChannels;

  /// [isAb]true 如果是AB卷，反之false
  /// [srcABPaperQuesIds]只有在[isAb]为true才有效
  MicrocourseWebPage({
    Key key,
    @required this.resourceId,
    @required this.resourceName,
    @required this.initialUrl,
    this.javascriptChannels,
    this.isReport = false,
    this.isAb = false,
    this.srcABPaperQuesIds,
  }) : super(key: key);

  @override
  _MicrocourseWebPageState createState() => _MicrocourseWebPageState();
}

class _MicrocourseWebPageState extends State<MicrocourseWebPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'native',
        onMessageReceived: (JavascriptMessage message) {
          onJsCallback(message.message);
        });
  }

  @override
  void initState() {
    //setupOrientation();
    super.initState();
  }

  setupOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
    ]);
  }

  setupOrientationPortraitUp() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    //setupOrientationPortraitUp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actions = <Widget>[
      InkWell(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            MyIcons.ANSWER_CARD,
            size: 20.0,
          ),
        ),
        onTap: () {
          _controller.future.then((controller) {
            if (widget.isReport) {
              controller.evaluateJavascript('showReport()');
            } else {
              controller.evaluateJavascript('showAnswerCard()');
            }
          });
        },
      ),
    ];
    var editAction = InkWell(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Icon(
          MyIcons.PENCIL,
          size: 20.0,
        ),
      ),
      onTap: () {
        _controller.future.then(
            (controller) => controller.evaluateJavascript('showDraftCard()'));
      },
    );
    if (!widget.isReport) {
      actions.add(editAction);
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(widget.isReport ? '练习报告' : widget.resourceName),
        actions: actions,
      ),
      body: Container(
          child: WebView(
        initialUrl: widget.initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          _webViewController = webViewController
            ..clearCache(); // DO NOT USE CACHE
        },
        javascriptChannels: widget.javascriptChannels ??
            <JavascriptChannel>[
              _alertJavascriptChannel(context),
            ].toSet(),
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('js://webview')) {
            onJsCallback('JS调用了Flutter By navigationDelegate');
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
      )),
    );
  }

  Future onJsCallback(String s) async {
    var decode = jsonDecode(s);
    if (decode['paperid'] != null) {
      var paperId = decode['paperid'].toString();
      var token = await NetworkManager.getAuthorization();
      var resourceId = widget.resourceId;
      var url;
      if (!widget.isAb) {
        url =
            '${APIConst.practiceHost}/report.html?token=$token&resourceid=$resourceId&paperid=$paperId';
      } else {
        url =
            '${APIConst.practiceHost}/abreport.html?token=$token&abpid=$resourceId&paperid=$paperId';
      }
      // 去报告页，新开页面，直接加载url，android不生效
      if (Platform.isIOS) {
        _controller.future.then((controller) => controller.loadUrl(url));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return MicrocourseWebPage(
              initialUrl: url,
              isReport: true,
              resourceId: widget.resourceId,
              resourceName: widget.resourceName,
              isAb: widget.isAb,
              srcABPaperQuesIds: widget.srcABPaperQuesIds);
        }));
      }
    } else if (decode['goto'] == 'ab') {
      // ab测试
      var token = await NetworkManager.getAuthorization();
      var abpid = widget.resourceId;
      var abpname = Uri.encodeComponent(widget.resourceName);
      var abpqids = widget.srcABPaperQuesIds;
      var url =
          '${APIConst.practiceHost}/ab.html?token=$token&abpid=$abpid&abpname=$abpname&abpqids=$abpqids';

      // 再次做题，本页加载
      _controller.future.then((controller) => controller.loadUrl(url));
      widget.isReport = false;
      setState(() {});
    } else if (decode['goto'] == 'practice') {
      var token = await NetworkManager.getAuthorization();
      var resourceId = widget.resourceId;
      var url =
          '${APIConst.practiceHost}/practice.html?token=$token&resourceid=$resourceId';

      // 再次做题，本页加载
      _controller.future.then((controller) => controller.loadUrl(url));
      widget.isReport = false;
      setState(() {});
    }
  }
}
