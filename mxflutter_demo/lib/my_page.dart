import 'package:flutter/material.dart';


class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyState();
  }
}

class _MyState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("标题"),
      ),

      body: Column(
        children: <Widget>[
          Text("测试"),
        ],
      ),
    );
  }
}