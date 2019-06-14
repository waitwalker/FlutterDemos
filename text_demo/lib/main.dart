import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() => runApp(TextApp());

class TextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Hello World",
      theme: ThemeData(
        brightness: Brightness.light,//设置状态栏颜色
        primarySwatch: Colors.orange,
      ),
      home: HomePage(title: "Hello World"),
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
  // @override
  // _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TapGestureRecognizer _tapGestureRecognizer = new TapGestureRecognizer();
  bool _toggle = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("这个是导航栏标题",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello World, flutter is coming" * 4,
              textAlign: TextAlign.center,//文本对齐方式
              maxLines: 10,//最大行数
              textScaleFactor: 1.5,//字体大小缩放倍数
              overflow: TextOverflow.ellipsis,//长度超过屏幕,显示方式
              style: TextStyle(
                color: Colors.black,//颜色
                fontSize: 18.0,//字体大小
                height: 1.5,//字体高度
                // fontFamily: 字体
                backgroundColor: Colors.orange,//背景颜色
                decoration: TextDecoration.underline,//装饰 下划线
                decorationColor: Colors.green,//下划线颜色
                decorationStyle: TextDecorationStyle.double,//下划线样式

              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Hello",
                    style: TextStyle(
                      color:Colors.purple,
                      fontSize: 25.0,
                      height: 2,
                     ),
                  ),
                  TextSpan(
                    text: "I am .",
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                  TextSpan(
                    text: "Flutter",
                    style: TextStyle(
                      color: _toggle ? Colors.lime : Colors.pink,
                      decoration: TextDecoration.underline,
                      fontSize: 30.0,
                      height: 2.5,
                    ),
                    recognizer: _tapGestureRecognizer
                      ..onTap = (){
                        setState(() {
                          _toggle = !_toggle;
                        });
                      }
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
