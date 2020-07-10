import 'package:online_school/modules/personal/settings/setting_page.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// @name WifiOnlyCheckMixin
/// @description 只有wifi组件
/// @author liuca
/// @date 2020-01-11
///
mixin WifiOnlyCheckWidget {
  /// 是否wifi网络
  Future<bool> isWifi() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  /// 是否移动网络
  Future<bool> isMobile() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult == ConnectivityResult.wifi;
  }

  bool isWifiDownloadOnly() {
    return SharedPrefsUtils.get('wifi_only', true);
  }

  checkWifiVideo(BuildContext context, Function f,
      [List<dynamic> positionalArguments,
      Map<Symbol, dynamic> namedArguments]) async {
    var wifi_only = SharedPrefsUtils.get('wifi_only', true);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: '网络已断开');
    } else if (connectivityResult == ConnectivityResult.mobile) {
      Fluttertoast.showToast(msg: '您正在使用流量播放', gravity: ToastGravity.CENTER);
    } else {
      Function.apply(f, positionalArguments, namedArguments);
    }
  }

  checkWifiOnly(BuildContext context, Function f,
      [List<dynamic> positionalArguments,
      Map<Symbol, dynamic> namedArguments,
      String prompt,
      String refuse]) async {
    var wifi_only = SharedPrefsUtils.get('wifi_only', true);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Fluttertoast.showToast(msg: '网络已断开');
    } else if (connectivityResult == ConnectivityResult.mobile && !wifi_only) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                  title: new Text('提示'),
                  content: new Text(prompt ?? '您正在使用流量，是否继续'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('继续'),
                        onPressed: () {
                          // if (!wifi_only) {
                          Navigator.of(context).pop(true);
                          // }
                        }),
                    FlatButton(
                      child: Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  ]),
            );
          }).then((agree) {
        if (agree) {
          Function.apply(f, positionalArguments, namedArguments);
        } else {
          Fluttertoast.showToast(msg: refuse ?? '下载已取消');
        }
      });
    } else if (connectivityResult == ConnectivityResult.mobile && wifi_only) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return WillPopScope(
              onWillPop: () => Future.value(false),
              child: AlertDialog(
                  title: new Text('提示'),
                  content:
                      new Text(prompt ?? '您设置了仅WIFI下载，请前往设置关闭设置，或者连接WIFI后再试'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('打开设置'),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SettingPage()))
                            .then((_) {
                          var wifi_only =
                              SharedPrefsUtils.get('wifi_only', true);
                          // if (!wifi_only) {
                          Navigator.of(context).pop(!wifi_only);
                          // }
                        });
                      },
                    ),
                    FlatButton(
                      child: Text('取消'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  ]),
            );
          }).then((agree) {
        if (agree) {
          Function.apply(f, positionalArguments, namedArguments);
        } else {
          Fluttertoast.showToast(msg: refuse ?? '下载已取消');
        }
      });
    } else {
      Function.apply(f, positionalArguments, namedArguments);
    }
  }
}
