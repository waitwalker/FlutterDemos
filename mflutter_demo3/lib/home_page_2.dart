import 'package:flutter/material.dart';

class HomePage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState2();
  }
}

class _HomeState2 extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页2"),
      ),
      body: Column(
        children: <Widget>[
          Text("首页展示2"),
        ],
      ),
    );
  }
}