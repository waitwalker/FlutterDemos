
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_route_test/fourth_test_page.dart';
import 'package:flutter_route_test/routes_config.dart';
import 'package:provider/provider.dart';

import 'observer/navigator_manager.dart';

class ThirdTestPage extends StatefulWidget {

  @override
  State createState() {
    return _ThirdTestState();
  }
}

class _ThirdTestState extends State<ThirdTestPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第三个界面"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("关闭当前页面并返回结果"),
            onPressed: (){
              //返回的结果并不会被第一个页面接收到
              var navigatorState = Navigator.of(context);
              navigatorState.pop("第三个页面的返回结果");
            },
          ),
          RaisedButton(
            child: Text("跳转到第四个页面"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                return FourthTestPage();
              }));
            },
          ),
          RaisedButton(
            child: Text("removeRoute remove最后一个Route，删除当前页面"),
            onPressed: () {
              //执行后会抛出控制台异步
              var navigatorManager = Provider.of<NavigatorManager>(context);
              Navigator.removeRoute(context, navigatorManager.getLast());
            },
          ),
        ],
      ),
    );
  }
}