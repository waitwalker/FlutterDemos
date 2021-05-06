import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:pdf_flutter/pdf_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:async/async.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class OnlineBrowsePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OnlineBrowseState();
  }
}

class _OnlineBrowseState extends State<OnlineBrowsePage> {
  FlutterWebviewPlugin flutterWebviewPlugin;
  bool hasError = false;
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
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: Text("浏览器", style: TextStyle(color: Colors.black),),
          centerTitle: true ,
          actions: <Widget>[
          ],
        ),
        body: Column(
          children: <Widget>[
            SizedBox(height: 1),
            Expanded(child: setNewWebView(),)
          ],
        ),
      ),
    );
  }

  /// 定制机初始化webview
  setNewWebView() {
    return WebviewScaffold(
      scrollBar: false,
      url: "https://www.etiantian.com/",
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
      print("消息message:${s.message}");
      bool type = s.message is String;
      Map map;
      print("type:$type");
      i0f (s.message is String) {
        map = json.decode(s.message);
        print("map:$map");
        if (map != null) {

        }
      } else if (s.message is Map) {

      }
    });
  }
}


class Home extends StatefulWidget {
  @override
  createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("浏览器"),),
      body: Column(
        children: [
          InkWell(
            child: Text("Webview1", style: TextStyle(fontSize: 30),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return MyHomePage(title: "web1",);
              })).then((value) => (){
                print("返回了");
              });
            },
          ),
          Padding(padding: EdgeInsets.only(top: 50)),
          InkWell(
            child: Text("Webview2",style: TextStyle(fontSize: 30),),
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return HomePage(title: "web2",);
              })).then((value) => (){
                print("返回了");
              });
            },
          ),

          Padding(padding: EdgeInsets.only(top: 50)),
          InkWell(
            child: Text("Webview3",style: TextStyle(fontSize: 30),),
            onTap: (){
              _navigateToPage(
                title: "Pdf from networkUrl",
                child: PDF.network(
                  'https://cdn-wxkm-files.etiantian.net/fpupload/xwx/%2F20210130%2Fzl_report%2F9615692%2F%E6%99%BA%E9%A2%86%E9%94%99%E9%A2%98%E6%8A%A5%E5%91%8A-210130171547.pdf',
                ),
              );
              //PDF.network("https://cdn-wxkm-files.etiantian.net/fpupload/xwx/%2F20210130%2Fzl_report%2F9615692%2F%E6%99%BA%E9%A2%86%E9%94%99%E9%A2%98%E6%8A%A5%E5%91%8A-210130171547.pdfrl");
              // Navigator.of(context).push(MaterialPageRoute(builder: (context){
              //   return HomePage3(title: "web3",);
              // })).then((value) {
              //   print("返回了");
              // });
            },
          ),
        ],
      ),
    );
  }

  void _navigateToPage({String title, Widget child}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: child),
        ),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterWebviewPlugin flutterWebviewPlugin;
  AsyncMemoizer memoizer;
  int code = 1;
  @override
  void initState() {
    flutterWebviewPlugin = FlutterWebviewPlugin();
    memoizer = AsyncMemoizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("web1"),
        actions: [
          InkWell(child: Container(
            width: 100,
            height: 40,
            child: Text("跳走"),
            color: Colors.red,
          ),onTap: (){
            flutterWebviewPlugin.close();
            flutterWebviewPlugin.dispose();
            flutterWebviewPlugin = null;
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return HomePage(title: "web2",);
            })).then((value) {
              setState(() {
                code = 2;
              });
              Future.delayed(Duration(seconds: 3),(){
                code = 1;
                setState(() {
                  flutterWebviewPlugin = FlutterWebviewPlugin();
                  flutterWebviewPlugin.reloadUrl("https://www.etiantian.com/");
                });
              });

            });
          },),
        ],
      ),
      body: Column(
        children: [
          code == 1 ? Expanded(child: WebviewScaffold(
            scrollBar: false,
            url: "https://www.etiantian.com/",
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
          )) : Text("234")
        ],
      ),
    );
  }
}



class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FlutterWebviewPlugin webviewPlugin;
  @override
  void initState() {
    webviewPlugin = FlutterWebviewPlugin();
    super.initState();
  }

  @override
  void dispose() {

    webviewPlugin.close();
    webviewPlugin.dispose();
    webviewPlugin = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: [
          Expanded(child: WebviewScaffold(
            scrollBar: false,
            url: "https://www.etiantian.com/",
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
          )),
        ],
      ),
    );
  }
}



class HomePage3 extends StatefulWidget {
  HomePage3({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePage3State createState() => _HomePage3State();
}

class _HomePage3State extends State<HomePage3> {

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: [
          Text("data")
        ],
      ),
    );
  }
}