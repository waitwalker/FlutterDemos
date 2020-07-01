import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/locale/locale_mamager.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/common/theme/theme_manager.dart';
import 'package:online_school/common/tools/timer_tool.dart';
import 'package:online_school/modules/enterence/navigation_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';

///
/// @name AdvertisementPage
/// @description 广告页
/// @author liuca
/// @date 2020-01-15
///
class AdvertisementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AdvertisementState();
  }
}

class _AdvertisementState extends State<AdvertisementPage> {
  TimerTool _timerTool;
  int _count = 3;
  File imageFile;
  bool shouldShowAD = false;

  int themeIndex = 0;
  int localeIndex = 0;

  MethodChannel methodChannel = const MethodChannel("aixue_wangxiao_channel");

  ///
  /// @MethodName 跳转处理状态1
  /// @Parameter
  /// @ReturnType
  /// @Description
  /// @Author waitwalker
  /// @Date 2020-02-03
  ///
  Future<dynamic> _handler(MethodCall methodCall) {
    print("${methodCall.method}");
    print("${methodCall.arguments}");
    if (SingletonManager.sharedInstance.isHaveLogined == false) {
      if (methodCall.arguments != null) {
        List<String> arguments = methodCall.arguments.toString().split("&");
        String account = arguments[0];
        String password = arguments[1];
        String isVip = arguments[2];
        String gradeId = arguments[3];
        /// 广告页启动:说明是冷启动
        /// 冷启动类型:1)正常冷启动
        ///          2)跳转过来触发的冷启动
        /// 如果跳转触发的是冷启动,直接进入登录页面,把账号密码带过去
        if (account != null && password != null) {
          SingletonManager.sharedInstance.isJumpColdStart = true;
          SingletonManager.sharedInstance.aixueAccount = account;
          SingletonManager.sharedInstance.aixuePassword = password;
          SingletonManager.sharedInstance.isVip = isVip;
          SingletonManager.sharedInstance.gradeId = gradeId;
        } else {
          SingletonManager.sharedInstance.isJumpColdStart = false;
        }
      }
      print("登录页处理跳转");
    }
    return null;
  }

  @override
  void initState() {
    methodChannel.setMethodCallHandler(_handler);
    _loadLocalImage();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    readLocalCacheData();
  }
  /// 读取本地缓存数据
  readLocalCacheData() async {
    Store<AppState> store = StoreProvider.of(context);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    /// 获取主题
    themeIndex = sharedPreferences.getInt("theme");
    if (themeIndex == null) {
      themeIndex = 0;
    }
    ThemeManager.pushTheme(store, themeIndex);

    /// 获取语言
    localeIndex = sharedPreferences.getInt("locale");

    if (localeIndex == null) {
      localeIndex = 0;
    }
    SingletonManager.sharedInstance.currentLocaleIndex = localeIndex;
    sharedPreferences.setInt("locale", localeIndex);
    LocaleManager.changeLocale(store, localeIndex);
  }

  ///
  /// @name 加载本地图片
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-17
  ///
  _loadLocalImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path; // 临时文件夹
    String appDocPath = appDocDir.path; // 应用文件夹
    String filePath = appDocPath + "/ad.png";

    bool isExist = await File(filePath).exists();
    if (isExist) {
      var file = File(filePath);
      print("图片路径:$filePath");
      _count = 3;
      imageFile = file;
      shouldShowAD = true;
      _startCountDown();
      setState(() {

      });
    } else {
      _count = 2;
      _startCountDown();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: shouldShowAD == false
            ? Container(
                child: Image.asset("static/images/ad_logo.png",width: 200,height: 50,),
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageFile == null ? AssetImage("static/images/logo.png") : FileImage(imageFile),),
                    color: Colors.white,),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(top: 60,right: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),),
                            child: Text("$_count 跳过",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                          )
                        ),
                    onTap: (){
                      _startLaunchAnimation();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// @name 倒计时
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-15
  ///
  void _startCountDown() {
    _timerTool = TimerTool(mTotalTime: 3 * 1000);
    _timerTool.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _count = _tick.toInt();
      });
      if (_tick == 0) {
        _startLaunchAnimation();
      }
    });
    _timerTool.startCountDown();
  }

  ///
  /// @name 开启启动动画
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-15
  ///
  void _startLaunchAnimation() {
    _stopTimer();
    NavigatorRoute.launch(context);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  ///
  /// @name _stopTimer
  /// @description 销毁定时器
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-17
  ///
  _stopTimer() {
    if (_timerTool != null) _timerTool.cancel();
  }
}
