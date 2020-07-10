import 'dart:async';
import 'dart:io';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';

///
/// @name CheckError
/// @description 故障排查页面
/// @author liuca
/// @date 2020-01-11
///
class CheckErrorPage extends StatefulWidget {
  @override
  _CheckErrorPageState createState() => _CheckErrorPageState();
}

class _CheckErrorPageState extends State<CheckErrorPage> {
  Map<String, String> urls = {
    'm3u8-1服务器': 'web.etiantian.com',
    'm3u8-2服务器': 'i.m.etiantian.com',
    'mp4服务器': 'cdn5.hd.etiantian.net',
    '文档预览服务器': 'ow365.cn',
    '文档下载服务器': 'video.etiantian.com'
  };

  String output = '';

  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {});
  }

  @override
  Future didChangeDependencies() async {
    super.didChangeDependencies();
    var tasks = urls.entries
        .map(
            (u) => Task(input: u.value, description: u.key, runnable: pingHost))
        .toList()
          ..add(Task(description: '获取设备信息：', runnable: deviceInfo))
          ..add(Task(description: '获取包信息：', runnable: packageInfo))
          ..add(Task(description: '获取账户信息', runnable: accountInfo))
          ..add(Task(description: '获取网络信息', runnable: networkInfo));

    for (var t in tasks.reversed) {
      output += t.description;
      output += '\n';
      print(t.description);
      setState(() {});
      await t.run();
      print(t.result.toString());
      output += t.result.toString();
      output += '\n';
      print('###\n');
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('故障排查'),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: Platform.isIOS ? true : false,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.black54,
                width: double.infinity,
                child: SingleChildScrollView(
                    child: Text(output, style: textStyleSubWhite)),
              ),
              const SizedBox(height: 10),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    disabledColor: Color(MyColors.ccc),
                    disabledElevation: 0,
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      "提交",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    color: Color(MyColors.primaryValue),
                    onPressed: () async {
                      PackageInfo packageInfo =
                          await PackageInfo.fromPlatform();
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      var osVer, devModel;
                      if (Platform.isAndroid) {
                        var androidInfo = await deviceInfo.androidInfo;
                        osVer = androidInfo.version.release;
                        devModel = androidInfo.model;
                      } else {
                        var iosInfo = await deviceInfo.iosInfo;
                        osVer = iosInfo.systemName;
                        devModel = iosInfo.name;
                      }
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      var report = await AnalysisDao.report(
                          packageInfo.version,
                          Platform.isAndroid ? 2 : 1,
                          osVer,
                          devModel,
                          connectivityResult.toString(),
                          output);
                      if (report.result) {
                        Fluttertoast.showToast(msg: '谢谢反馈');
                        Navigator.of(context).pop();
                      }
                    },
                  ))
            ],
          ),
        ));
  }
}

class Result {
  bool success;
  String msg;

  Result.success(message)
      : msg = message,
        success = true;

  Result.fail(message)
      : msg = message,
        success = false;

  @override
  String toString() {
    return msg;
  }
}

class HeadResult extends Result {
  int timeMs;

  HeadResult.success(time, message)
      : timeMs = time,
        super.success(message);

  @override
  String toString() {
    if (success) {
      return msg;
    }
    return super.toString();
  }
}

class Task {
  Task({this.input, this.description, this.runnable});

  TaskStatus status = TaskStatus.ready;
  String description;
  dynamic input;
  Function runnable;
  Result result;

  run() async {
    status = TaskStatus.running;
    result = (input != null ? await runnable(input) : await runnable());
    status = TaskStatus.finished;
    return result;
  }
}

enum TaskStatus {
  ready,
  running,
  finished,
}

Future pingHost(String url) async {
  url = !url.startsWith('http') ? 'http://$url' : url;
  var tik = DateTime.now();
  Response response;
  try {
    response = await http.head(url);
    var tok = DateTime.now();
    bool connected = response.statusCode != 404;
    if (connected) {
      var timeCost = tok.difference(tik).inMilliseconds;
      // output += '\n$url \t$timeCost ms';
      // print('$url \t$timeCost ms');
      // setState(() {});
      return HeadResult.success(timeCost, '耗时${timeCost}ms');
    } else {
      // output += '\n$url disconnected! ${response.statusCode}';
      // print('$url disconnected! ${response.statusCode}');
      // setState(() {});
      return Result.fail('访问失败');
    }
  } on Exception catch (e) {
    // output += '\n 连接已断开';
    return Result.fail('网络断开');
  }
}

Future deviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return Result.success(printAndroidDeviceInfo(androidInfo));
  } else {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // print('Running on ${iosInfo.utsname.machine}');
    return Result.success(printIosDeviceInfo(iosInfo));
  }
}

packageInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  // print('$appName, $packageName, $version, $buildNumber');
  return Result.success('$appName \n$packageName \n$version+$buildNumber');
}

accountInfo() {
  var nm = SharedPrefsUtils.getString('username');
  // var pwd = SharedPrefsUtils.getString('password');
  // print(nm);
  return Result.success(nm);
}

networkInfo() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  // print(connectivityResult);
  String netStr = connectivityResult == ConnectivityResult.mobile
      ? '移动网络'
      : (connectivityResult == ConnectivityResult.wifi ? 'WIFI' : '没有网络');
  return Result.success('$netStr');
}

printAndroidDeviceInfo(AndroidDeviceInfo info) {
  var sb = StringBuffer();
  sb.writeln('品牌: ${info.brand}');
  sb.writeln('CPU: ${info.hardware}');
  sb.writeln('制造商: ${info.manufacturer}');
  sb.writeln('型号: ${info.display}');
  sb.writeln('Android ${info.version.release}');
  sb.writeln('SDK Level: ${info.version.sdkInt}');
  sb.writeln(info.supportedAbis);
  return sb.toString();
}

printIosDeviceInfo(IosDeviceInfo info) {
  var sb = StringBuffer();
  sb.writeln('型号: ${info.name}');
  sb.writeln('系统: ${info.systemName} ${info.systemVersion}');
  return sb.toString();
}
