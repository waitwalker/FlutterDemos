import 'package:flutter/material.dart';

class CommonAddPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonAddState();
  }
}

class _CommonAddState extends State<CommonAddPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加"),
      ),
      body: Center(
        child: Text("添加"),
      ),
    );
  }
}