import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorManager extends NavigatorObserver with ChangeNotifier {
  final _routeList = List<Route>();

  int get routeCounts => _routeList.length;

  List<Route> getRoutes() {
    return _routeList;
  }

  Route getFirst() {
    return _routeList.isEmpty?null:_routeList[0];
  }

  Route getLast() {
    return _routeList.isEmpty?null:_routeList[_routeList.length-1];
  }

  @override
  void didStopUserGesture() {
    print('didStopUserGesture');
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('didStartUserGesture:$route previousRoute:$previousRoute');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if(newRoute.isPageRoute()) {
      print('didReplace:$newRoute oldRoute:$oldRoute');
      //这个contains方法没有经过严格测试,
      // 一般被replace的Route都是已经存在的Route，所以先判断一下
      if(_routeList.contains(oldRoute)) {
        var index = _routeList.indexOf(oldRoute);
        _routeList[index] = newRoute;
      }else {
        _routeList.add(newRoute);
        _routeList.remove(oldRoute);
      }
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    if(route.isPageRoute()) {
      print('didRemove:$route previousRoute:$previousRoute');
      _routeList.remove(route);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if(route.isPageRoute()) {
      print('didPop:$route previousRoute:$previousRoute');
      _routeList.remove(route);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if(route.isPageRoute()) {
      print('didPush:$route previousRoute:$previousRoute');
      _routeList.add(route);
    }
  }
}

extension CupertinoOrMaterialPageRoute on Route {
  bool isPageRoute() {
    return this is MaterialPageRoute ||
        this is CupertinoPageRoute ||
        this is PageRouteBuilder;
  }
}
