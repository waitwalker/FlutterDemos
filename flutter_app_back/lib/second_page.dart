import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SecondState();
  }
}

class _SecondState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Text("第二页", ),
        ),
        resizeToAvoidBottomPadding: true,
        body: Center(child: Container(
          // padding: EdgeInsets.all(32.0),
          child: Text("第二页"),
        ),),
      ),
    );
  }
}