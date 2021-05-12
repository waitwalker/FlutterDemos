import 'package:flutter/material.dart';
import 'package:flutter_route_test/routes_config.dart';
import 'package:flutter_route_test/third_test_page.dart';
import 'package:provider/provider.dart';

import 'observer/navigator_manager.dart';
class SecondTestPage extends StatefulWidget {

  SecondTestPage();

  @override
  State createState() {
    return _SecondTestState();
  }
}

class _SecondTestState extends State<SecondTestPage> {


  @override
  Widget build(BuildContext context) {
    print('second build');
    return Scaffold(
      appBar: AppBar(
        title: Text("第二个页面"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(width: 10),
          RaisedButton(
            child: Text("跳转到第三个页面"),
            onPressed: () async {
              var reslut = await Navigator.push(context,MaterialPageRoute(builder: (BuildContext context){
                return ThirdTestPage();
              }));
              print('第三个页面的返回值:$reslut');
            },
          ),
          SizedBox(width: 10),
          RaisedButton(
            child: Text('pushReplacement-使用第三个页面替换当前页面'),
            onPressed: (){
              //替换当前页面，返回null给前一个页面
//              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
//                return ThirdTestPage();
//              }));
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                return ThirdTestPage();
              }),result:"pushReplacement resule");
            },
          ),
          RaisedButton(
            child: Text("popAndPushNamed"),
            onPressed: (){
              Navigator.popAndPushNamed(context, commonPage);
            },
          ),
          RaisedButton(
            child: Text("removeRoute"),
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

  @override
  void initState() {
    super.initState();
    print('second initState');
  }

  @override
  void didUpdateWidget(SecondTestPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('second didUpdateWidget');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('second didChangeDependencies');
  }

  @override
  void dispose() {
    super.dispose();
    print('second dispose');
  }

  @override
  void deactivate() {
    super.deactivate();
    print('second deactivate');
  }


}