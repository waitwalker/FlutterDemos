import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

///
/// @description 浏览页
/// @author waitwalker
/// @time 2/2/21 3:40 PM
///
class BrowsePage extends StatefulWidget {
  final String initialUrl;
  final String title;
  const BrowsePage({
    Key key,
    this.initialUrl,
    this.title,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _BrowseState();
  }
}

class _BrowseState extends State<BrowsePage> {

  bool isLoading = true;
  FlutterWebviewPlugin flutterWebviewPlugin;
  bool hasError = false;

  bool currentOrientationLandscape = true;
  double lineProgress = 0.0;

  _progressBar(double progress, BuildContext context) {

    return LinearProgressIndicator(
      minHeight: 5,
      backgroundColor: Colors.white70.withOpacity(0),
      value: progress == 1.0 ? 0 : progress,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
    );
  }


  @override
  void initState() {
    flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.onDestroy.listen((_) {
      flutterWebviewPlugin.dispose();
    });

    /// 监听加载状态
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.shouldStart) {
        print("应该加载");
      } else if (viewState.type == WebViewState.startLoad) {
        print("开始加载");
      } else if (viewState.type == WebViewState.finishLoad) {
        print("网页加载完成");
      }
    });

    /// 监听加载错误
    flutterWebviewPlugin.onHttpError.listen((event) {
      setState(() {
        hasError = true;
      });
    });

    flutterWebviewPlugin.onProgressChanged.listen((progress){
      print("当前加载进度:$progress");
      setState(() {
        lineProgress = progress;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool canGoBack = await flutterWebviewPlugin.canGoBack();
        if (canGoBack) {
          await flutterWebviewPlugin.goBack();
          return false;
        }
        flutterWebviewPlugin.evalJavascript('document.body.remove()');
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft
        ]);
        return true;
      },
      child: Scaffold(
        appBar: setupAppBar(),
        body: Column(
          children: <Widget>[
            SizedBox(height: 1),
            Expanded(child: setNewWebView(),)
          ],
        ),
      ),
    );
  }

  setNewWebView() {
    return WebviewScaffold(
      scrollBar: false,
      url: widget.initialUrl,
      javascriptChannels: <MTTJavascriptChannel>[
        _newAlertJavascriptChannel(context),
      ].toSet(),
      withJavascript: true,
      clearCookies: true,
      clearCache: true,
      withLocalStorage: true,
      resizeToAvoidBottomInset: true,
    );
  }

  /// 定制机js交互处理
  MTTJavascriptChannel _newAlertJavascriptChannel(BuildContext context) {
    return MTTJavascriptChannel(name: "native", onMessageReceived: (s) async{
      print("s:${s.message}");
    });
  }


  setupAppBar() {
    var actions = <Widget>[];
    if (!hasError || hasError) {
      var action3 = InkWell(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(
            Icons.refresh,
            size: 30.0,
          ),
        ),
        onTap: () {

          currentOrientationLandscape = ! currentOrientationLandscape;
          if (currentOrientationLandscape) {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft
            ]);
          } else {
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp
            ]);
          }

          // flutterWebviewPlugin.reloadUrl(widget.initialUrl);
          // setState(() {
          //   /// 没有错误
          //   hasError = false;
          // });

        },
      );
      actions.add(action3);
    }
    return AppBar(
      title: Text(widget.title),
      elevation: 1,
      //backgroundColor: Colors.white,
      centerTitle: true,
      actions: actions,
      bottom: PreferredSize(
        child: _progressBar(lineProgress, context),
        preferredSize: Size.fromHeight(3.0),
      ),
    );
  }


  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    flutterWebviewPlugin = null;
    super.dispose();
  }

}