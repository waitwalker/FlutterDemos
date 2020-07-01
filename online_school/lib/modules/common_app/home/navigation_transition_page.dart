import 'package:flutter/material.dart';

class CommonNavigationTransitionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonNavigationTransitionState();
  }
}

class _CommonNavigationTransitionState extends State<CommonNavigationTransitionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("导航跳转动画"),
      ),
      body: Center(
        child: Text("导航跳转动画"),
      ),
    );
  }
}