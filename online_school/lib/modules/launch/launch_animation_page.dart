import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/locale/locale_mamager.dart';
import 'package:online_school/common/dao/original_dao/ccuser_info_dao.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/common/theme/theme_manager.dart';
import 'package:online_school/model/cc_login_model.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:online_school/modules/enterence/navigation_route.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// @name LaunchAnimationPage
/// @description 启动动画页
/// @author liuca
/// @date 2020-01-10
///

class LaunchAnimationPage extends StatefulWidget {
  @override
  _LaunchAnimationState createState() => new _LaunchAnimationState();
}

class _LaunchAnimationState extends State<LaunchAnimationPage>
    with SingleTickerProviderStateMixin {
  var isLogin = false;
  var isBind = false;
  LottieComposition _composition;
  AnimationController _controller;
  int localeIndex = 0;
  int themeIndex = 0;

  /// 安卓跳转是否冷启动
  //bool isJumpColdStarted = false;

  //MethodChannel methodChannel = const MethodChannel("aixue_wangxiao_channel");
  MethodChannel _methodChannel = const MethodChannel("polyv");

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
        /// 如果跳转触发的是冷启动,直接进入登录页面
        if (account != null && password != null) {
          //isJumpColdStarted = true;
          SingletonManager.sharedInstance.aixueAccount = account;
          SingletonManager.sharedInstance.aixuePassword = password;
          SingletonManager.sharedInstance.isVip = isVip;
          SingletonManager.sharedInstance.gradeId = gradeId;
        }
      }
      print("登录页处理跳转");

    }
    return null;
  }


  @override
  void initState() {
    super.initState();

    _localPath();

    initPolyvSDK();

    // 注释掉启动动画页的消息通道:这个通道用来处理跳转到网校App业务
    //methodChannel.setMethodCallHandler(_handler);
    /// 加载lottie 动画
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    loadAsset('assets/app.json').then((composition) {
      _composition = composition;
      setState(() {});
    }).then((_) {
      _controller.forward();
    });

    /// 动画完成后进入主界面
    initLaunch();
  }

  Future<Void> _localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var pdfDir = Directory(directory.path + '/com_alibaba_aliyun_crash_defend_sdk_info');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return null;
  }

  ///
  /// @name initPolyvSDK
  /// @description 初始化保利威SDK
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020/6/12
  ///
  initPolyvSDK() async {
    MethodChannel channel = MethodChannel("com.etiantian/flutter_channel");
    bool result = await channel.invokeMethod("init_sdk");
    print("保利威SDK初始化回调结果:$result");
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
    LocaleManager.changeLocale(store, localeIndex);
  }


  ///
  /// @name initLaunch
  /// @description 进入主界面:区分是否有登录缓存数据
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-24
  ///
  Future initLaunch() async {
    var loginJson = SharedPrefsUtils.getString(Config.LOGIN_JSON);
    var ccLoginModel;
    if (loginJson == null || loginJson.isEmpty) {
      isLogin = false;
    } else {
      try {
        ccLoginModel = CcLoginModel.fromJson(jsonDecode(loginJson));
      } on Exception catch (e) {
        isLogin = false;
      }
    }
    isLogin = ccLoginModel != null;
    var isExpire = false;
    if (isLogin) {
      isExpire = DateTime.now().millisecondsSinceEpoch >=
          (ccLoginModel.expiration ?? 0);
      if (isExpire) {
        // noop
      } else {
        var info = await CCUserInfoDao.getUserInfo();
        if (info.result && info.model != null && info.model.code == 1) {
          var model = info.model as UserInfoModel;
          isBind = model.data.bindingStatus == 1;
          _getStore().dispatch(UpdateUserAction(model));
        }
      }
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      /// 首页弹框置为默认值
      SingletonManager.sharedInstance.isHaveLoadedAlert = false;
      /// 如果是冷启动跳转
      if (SingletonManager.sharedInstance.isJumpColdStart) {
        //isJumpColdStarted = false;
        SingletonManager.sharedInstance.isHaveLogined = false;
        SingletonManager.sharedInstance.isJumpColdStart = true;
        NavigatorRoute.login(context);
      } else {
        if (isLogin && !isExpire && isBind) {
          SingletonManager.sharedInstance.isHaveLogined = true;
          NavigatorRoute.goHome(context);
        } else {
          SingletonManager.sharedInstance.isHaveLogined = false;
          NavigatorRoute.login(context);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    readLocalCacheData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(height: 640, width: 360)..init(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return _buildPage(context, store);
    });
  }

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  Widget _buildPage(BuildContext context, Store<AppState> store) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    if (w / h < 9 / 16.0) {
      h = (16 / 9) * w;
    }
    return Container(
      // alignment: Alignment.center,
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: w,
              height: h,
              // color: Colors.red,
              child: Lottie(
                composition: _composition,
                size: Size(w, h),
                controller: _controller,
              ),
            ),
            Positioned(
              bottom: 58,
              child: Image.asset(
                  'static/images/img_Start_zhongxia_logo.png.png',
                  width: 183,
                  height: 43),
            )
          ],
        ));
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) => new LottieComposition.fromMap(map));
}
