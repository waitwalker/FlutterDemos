
import 'package:flutter/material.dart';

class CommonPage extends StatefulWidget {

  final String content;

  CommonPage({this.content});

  @override
  State createState() {
    return _CommonState();
  }
}

class _CommonState extends State<CommonPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("测试页面"),
      ),
      body: Center(
        child: Text(widget.content==null?"这里什么都没有":widget.content),
      ),
    );
  }
}