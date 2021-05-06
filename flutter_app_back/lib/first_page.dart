import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstState();
  }
}

class _FirstState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text("第一页", style: TextStyle(color: Colors.red),),
      ),
      resizeToAvoidBottomPadding: true,
      body: WillPopScope(child: Center(child: Container(
        // padding: EdgeInsets.all(32.0),
        child: Text("第一页"),
      ),), onWillPop: () async{
        return true;
      }),
    );
  }
}