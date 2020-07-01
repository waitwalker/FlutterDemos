import 'dart:async';
import 'dart:io';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/modules/enterence/app.dart';
import 'package:online_school/common/tools/global.dart';
import 'package:online_school/pad_app/modules/enterence/pad_app.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'common/config/config.dart';
import 'common/network/error_code.dart';

void reportErrorAndLog(FlutterErrorDetails details) {
  ///上报错误和日志逻辑
  /// FlutterError.dumpErrorToConsole(details);
  UMengAnalytics.reportError(details.toString());
  if (!Config.DEBUG) {

  }
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  // 构建错误信息
  return FlutterErrorDetails(stack: stack);
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    reportErrorAndLog(details);
  };

  /// 初始化友盟统计
  await Global.init();

  /// event 监听事件
  ErrorCode.eventBus.on<dynamic>().listen((event) {
    errorHandleFunction(event.code, event.message);
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  DeviceInfoPlugin plugin = DeviceInfoPlugin();
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await plugin.iosInfo;
    SingletonManager.sharedInstance.mobileName = iosDeviceInfo.name;
    if (iosDeviceInfo.model == "iPad") {
      SingletonManager.sharedInstance.isPadDevice = true;
      runZoned(() => runApp(App()),
        onError: (Object obj, StackTrace stack) {
          var details = makeDetails(obj, stack);
          reportErrorAndLog(details);
        },
      );
    } else {
      // debugPaintSizeEnabled = true;
      SingletonManager.sharedInstance.isPadDevice = false;
      runZoned(() => runApp(App()),
        onError: (Object obj, StackTrace stack) {
          var details = makeDetails(obj, stack);
          reportErrorAndLog(details);
        },
      );
    }

  } else if (Platform.isAndroid){
    MethodChannel channel = MethodChannel("com.etiantian/flutter_channel");
    bool result = await channel.invokeMethod("deviceType") ?? false;
    print("device is pad:$result");
    if (result) {
      SingletonManager.sharedInstance.isPadDevice = true;
      runZoned(() => runApp(App()),
        onError: (Object obj, StackTrace stack) {
          var details = makeDetails(obj, stack);
          reportErrorAndLog(details);
        },
      );
    } else {
      SingletonManager.sharedInstance.isPadDevice = false;
      runZoned(() => runApp(App()),
        onError: (Object obj, StackTrace stack) {
          var details = makeDetails(obj, stack);
          reportErrorAndLog(details);
        },
      );
    }
  }
}

///
/// @name errorHandleFunction
/// @description event 监听消息
/// @parameters
/// @return
/// @author liuca
/// @date 2020-01-14
///
errorHandleFunction(int code, message) {
  switch (code) {
    case ErrorCode.NETWORK_ERROR:
      Fluttertoast.showToast(msg: '网络错误');
      break;
    case 401:
      Fluttertoast.showToast(msg: '授权失败');
      break;
    case 403:
      Fluttertoast.showToast(msg: '禁止访问');
      break;
    case 404:
      Fluttertoast.showToast(msg: '网络错误404');
      break;
    case 413:
      Fluttertoast.showToast(msg: '上传文件太大');
      break;
    case ErrorCode.NETWORK_TIMEOUT:
      //超时
      Fluttertoast.showToast(msg: '网络超时');
      break;
    case ErrorCode.EXPIRED:
      //超时
      // Fluttertoast.showToast(msg: 'xxx');
      break;
    default:
      // Fluttertoast.showToast(msg: '网络请求失败');
      break;
  }
}
