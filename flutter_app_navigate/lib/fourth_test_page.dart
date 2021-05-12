import 'package:flutter/material.dart';
import 'package:flutter_route_test/common_page.dart';
import 'package:provider/provider.dart';

import 'not_found_page.dart';
import 'observer/navigator_manager.dart';

class FourthTestPage extends StatefulWidget {
  @override
  State createState() {
    return _FourthTestState();
  }
}

class _FourthTestState extends State<FourthTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第四个页面"),
      ),
      body: Column(
        children: <Widget>[
          RaisedButton(
            child: Text("继续跳转到第四个页面"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(BuildContext context){
                return FourthTestPage();
              }));
            },
          ),
          RaisedButton(
            child: Text("NavigatorState"),
            onPressed: () {
              var navigatorState = Navigator.of(context);
              print('navigatorState.canPop:${navigatorState.canPop()}');
              var routes = Provider.of<NavigatorManager>(context).getRoutes();
              for(var r in routes) {
                print('${r.settings.name}\t${r.hashCode}');
              }
              print('${Provider.of<NavigatorManager>(context).getRoutes()}');
            },
          ),
          RaisedButton(
            child: Text("popUntil"),
            onPressed: () {
              Navigator.popUntil(context, (Route route) {
                print('route$route');
                //到首页时停下，不要销毁首页，
                //如果想整个应用只剩当前页面，可以省略下面逻辑 return route==null; 即可
                if (route?.settings?.name == "/") {
                  return true;
                }
                return false;
              });
            },
          ),
          RaisedButton(
            child: Text('pushAndRemoveUntil'),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) {
                return CommonPage();
              }), (Route route) {
                //一直关闭，直到首页时停止，停止时，整个应用只有首页和当前页面
                if (route.settings?.name == "/") {
                  return true; //停止关闭
                }
                return false; //继续关闭
                //return route==null; //一直关闭页面，直到全部Route都关闭，效果就是整个应用，只剩下当前页面，按返回键会直接回系统桌面
              });
            },
          ),
          RaisedButton(
            child: Text("显示路由线路"),
            onPressed: () {
              var navigatorManager = Provider.of<NavigatorManager>(context);
              print('navigatorManager.size:${navigatorManager.routeCounts}');
              print('navigatorManager.size:${navigatorManager.getRoutes()}');
            },
          ),
          RaisedButton(
            child: Text("replace 把首页替换成CommonPage"),
            onPressed: () {
              var navigatorManager = Provider.of<NavigatorManager>(context);
              var oldRoute = navigatorManager.getFirst();
              if (oldRoute == null) {
                return;
              }
              Navigator.replace(context, oldRoute: oldRoute,
                  newRoute: MaterialPageRoute(builder: (BuildContext context) {
                return CommonPage(
                  content: "这是被替换掉的页面",
                );
              }));
            },
          ),
          RaisedButton(
            child: Text("replace 被替换的页面不能是当前可见的页面"),
            onPressed: () {
              //执行后会抛出控制台异步
              var navigatorManager = Provider.of<NavigatorManager>(context);
              Navigator.replace(context, oldRoute: navigatorManager.getLast(),
                  newRoute: MaterialPageRoute(builder: (BuildContext context) {
                return NoFoundPage("Navigator.replace");
              }));
            },
          ),
          RaisedButton(
            child: Text("removeRoute  remove最后一个Route，即删除当前页面"),
            onPressed: () {
              //执行后会抛出控制台异步
              var navigatorManager = Provider.of<NavigatorManager>(context);
              //The given `route` must be in the history; this method will throw an exception if it is not.
              Navigator.removeRoute(context, navigatorManager.getLast());
            },
          ),
          RaisedButton(
            child: Text("removeRouteBelow 删除前一个路由"),
            onPressed: () {
              //执行后会抛出控制台异步
              var navigatorManager = Provider.of<NavigatorManager>(context);
              //The given `anchorRoute` must be in the history and must have a route below it;
              // this method will throw an exception if it is not or does not.
              //点击一次，第三个页面被删，点击第二次，第二个页页会被删，点击第三次时，首页会被删除，
              if (navigatorManager.routeCounts > 1) {
                Navigator.removeRouteBelow(context, navigatorManager.getLast());
              }
            },
          ),
          RaisedButton(
            child: Text("replaceRouteBelow 替换前一个路由，使第三个页面变成CommonPage"),
            onPressed: () {
              //执行后会抛出控制台异步
              var navigatorManager = Provider.of<NavigatorManager>(context);
              //The given `anchorRoute` must be in the history and must have a route below it;
              // this method will throw an exception if it is not or does not.
              //点击一次，第三个页面被删，点击第二次，第二个页页会被删，点击第三次时，首页会被删除，
              if (navigatorManager.routeCounts > 1) {
                Navigator.replaceRouteBelow(context,
                    anchorRoute: navigatorManager.getLast(), newRoute:
                        MaterialPageRoute(builder: (BuildContext context) {
                  return CommonPage(content: "这是调用replaceRouteBelow替换出来的页面");
                }));
              }
            },
          ),
          RaisedButton(
            child: Text("maybePop"),
            onPressed: (){
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
    );
  }
}
