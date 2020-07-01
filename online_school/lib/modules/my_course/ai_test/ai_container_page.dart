import 'dart:io';

import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// @name AIContainerPage
/// @description AI页面 容器页面
/// @author liuca
/// @date 2020-01-10
///
class AIContainerPage extends StatefulWidget {
  Widget innerWidget;
  String title;

  AIContainerPage({this.innerWidget, this.title});

  @override
  _AIContainerPageState createState() => _AIContainerPageState();
}

class _AIContainerPageState extends State<AIContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: widget.innerWidget,
    );
  }
}
