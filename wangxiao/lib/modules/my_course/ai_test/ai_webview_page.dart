import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lottie/lottie.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/ai_score_model.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

/// AI测试web页
class AIWebPage extends StatefulWidget {
  final String initialUrl;
  final String title;
  final Set<JavascriptChannel> javascriptChannels;
  String currentDirId;
  String subjectId;
  String versionId;

  AIWebPage({
    Key key,
    this.currentDirId,
    this.subjectId,
    this.versionId,
    this.initialUrl,
    this.title,
    this.javascriptChannels,
  }) : super(key: key);

  @override
  _AIWebPageState createState() => _AIWebPageState();
}

class _AIWebPageState extends State<AIWebPage>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  LottieComposition _composition;
  AnimationController _lottieController;

  var _index = 1;

  Timer _timer;
  static const int COUNT_DOWN = 10 * 60;
  int remain = COUNT_DOWN;

  FlutterWebviewPlugin flutterWebviewPlugin;

  @override
  void initState() {
    _lottieController = new AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );
    loadAsset('assets/riding.json').then((composition) {
      _composition = composition;
      _lottieController.repeat(period: Duration(seconds: 2));
      setState(() {});
    });
    WidgetsBinding.instance.addObserver(this);

    flutterWebviewPlugin = new FlutterWebviewPlugin();
    // HACK of issue: https://github.com/fluttercommunity/flutter_webview_plugin/issues/162
    flutterWebviewPlugin.onDestroy.listen((_) {
      debugLog('DISTROY!!!');
      flutterWebviewPlugin.dispose();
      // if (Navigator.canPop(context)) {
      //   Navigator.of(context).pop();
      // }
    });
    // _startTimer();
    flutterWebviewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        setState(() {
          _index = 1;
          _startTimer();
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      _safeCancelTimer();
    } else {
      _startTimer();
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<LottieComposition> loadAsset(String assetName) async {
    var assetData = await rootBundle.load(assetName);
    return await LottieComposition.fromByteData(assetData);
  }

  var score;

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'native',
        onMessageReceived: (JavascriptMessage message) {
          onJsMessage(message.message);
        });
  }

  @override
  Future dispose() async {
    super.dispose();
    _safeCancelTimer();
    flutterWebviewPlugin.dispose();
  }

  void _safeCancelTimer() {
    _timer?.cancel();
  }

  void _startTimer() {
    if (remain < 1) {
      return;
    }
    if (_timer?.isActive ?? false) {
      return;
    }
    var lastRemain = remain;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      remain = lastRemain - timer.tick;
      if (remain <= 0) {
        _safeCancelTimer();
        _onCountdownOver();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        flutterWebviewPlugin.evalJavascript('document.body.remove()');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          actions: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.center,
                child: Text(secToHMS(remain < 0 ? 0 : remain) ?? '', style: textStyle25Primary))
          ],
        ),
        body: Container(
          // padding: EdgeInsets.all(32.0),
          child: IndexedStack(
            index: _index,
            children: <Widget>[
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Lottie(
                          composition: _composition,
                          controller: _lottieController,
                          width: 200,
                          height: 200,),
                      const SizedBox(height: 20),
                      Text('10分钟内，你能答对多少？\n出发吧！刷题鸭！',
                          style: textStyleContentMid333,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 200),
                    ]),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 1),
                  Expanded(child: WebviewScaffold(
                    scrollBar: false,
                    url: widget.initialUrl,
                    withJavascript: true,
                    clearCookies: true,
                    clearCache: true,
                    withLocalStorage: true,
                    resizeToAvoidBottomInset: true,
                    // appBar: new AppBar(
                    //   elevation: 0,
                    //   backgroundColor: Colors.white,
                    //   title: new Text(widget.title ?? 'webview course'),
                    // ),
                  ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onJsMessage(String s) {
    var decode = jsonDecode(s);
    // Fluttertoast.showToast(msg: s);
    if (decode['coursescore'] != null) {
      score = decode['coursescore'].toString();
      setState(() {});
    } else if ('ai' == decode['goto']) {
      Navigator.of(context).pop();
    }
  }

  Future _onCountdownOver() async {
    ResponseData aiScore = await CourseDaoManager.aiScore(
        currentDirId: widget.currentDirId,
        subjectId: widget.subjectId,
        versionId: widget.versionId);
    if (aiScore.result) {
      AiScoreModel model = aiScore.model as AiScoreModel;

      flutterWebviewPlugin.hide();
      if (model.data != null) {
        showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('提示'),
            content:
                new Text('时间到啦，您当前得分是${model.data.completeData.courseScore}'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('确定'),
              ),
            ],
          ),
        ).then((_) {
          Navigator.of(context).pop(true);
        });
      }
    }
  }
}
