import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/locale/localizations_delegate.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/middleware.dart';
import 'package:online_school/common/theme/theme_manager.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:online_school/model/app_info.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/model/video_source_model.dart';
import 'package:online_school/modules/personal/activate_card/bind_phone_page.dart';
import 'package:online_school/modules/login/forget_password_page.dart';
import 'package:online_school/modules/enterence/tabbar_container_page.dart';
import 'package:online_school/modules/login/login_page.dart';
import 'package:online_school/modules/login/login_sms.dart';
import 'package:online_school/modules/login/register_page.dart';
import 'package:online_school/modules/launch/launch_animation_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_channels/package_channels.dart';
import 'package:redux/redux.dart';

///
/// @name App
/// @description app 入口
/// @author liuca
/// @date 2020-01-13
///
class PadApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PadAppState();
}

class _PadAppState extends State<PadApp> {
  final JPush jpush = JPush();
  String debugLable = 'Unknown';
  final store = Store<AppState>(appReducer,
      middleware: [loggingMiddleware],
      initialState: AppState(
          theme: ThemeManager.defaultTheme(),
          locale: Locale("zh","CH"),
          appInfo: AppInfo(
              backgroundPlay: SharedPrefsUtils.get('background_play', false),
              line: SharedPrefsUtils.getString('video_source', null) == null
                  ? null
                  : VideoSource.fromJson(jsonDecode(
                  SharedPrefsUtils.getString('video_source', null)))),
          userInfo: UserInfoModel(),
          themeData: ThemeData(
            primarySwatch: MyColors.primarySwatch,
            primaryColor: Color(MyColors.primaryValue),
          )));

  @override
  void initState() {

    if (Platform.isIOS) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight
      ]);
      //setOrientation();
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft
      ]);
    }
    super.initState();
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });
    jpush.setup(
      appKey: "b0efe61a28a3d5ecb5ee1f22",
      channel: (await PackageChannels.getChannel) ?? 'dev',
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        NotificationSettingsIOS(sound: true, alert: true, badge: true));

    jpush.addTags(['dev1']).then((id) {
      debugLog(id);
    });
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(builder: (context,store){
        return MaterialApp(
          title: RouteConst.app_name,
          home: LaunchAnimationPage(),
          ///多语言实现代理
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            MTTLocalizationsDelegate.delegate,
            ChineseCupertinoLocalizations.delegate, // 自定义的delegate
            DefaultCupertinoLocalizations.delegate, // 目前只包含英文
          ],
          locale: store.state.locale,
          supportedLocales: [store.state.locale,Locale('zh', 'Hans'),],
          theme: store.state.themeData,
          routes: <String, WidgetBuilder>{
            RouteConst.launch: (BuildContext context) => LaunchAnimationPage(),
            RouteConst.register: (BuildContext context) => RegisterPage(),
            RouteConst.forget_password: (BuildContext context) => ForgetPasswordPage(),
            RouteConst.bind_phone: (BuildContext context) => BindPhonePage(),
            RouteConst.login: (BuildContext context) => LoginPage(),
            RouteConst.login_sms: (BuildContext context) => LoginSmsPage(),
            RouteConst.tab_bar_home: (BuildContext context) => TabBarHomePage(),
          },
        );
      }),
    );
  }
}

Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
  return Container(
      color: Colors.white,
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!Config.DEBUG) Image.asset('static/images/empty.png'),
              Text(
                Config.DEBUG ? error.toString() : "该页面似乎被外星人抢走了",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.grey),
              )
            ]),
      ));
}

///
/// @name MTTLocalizations
/// @description 国际化语言
/// @author liuca
/// @date 2020-01-13
///
class MTTLocalizations extends StatefulWidget {
  final Widget child;

  MTTLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<MTTLocalizations> createState() {
    return _LocalizationsState();
  }
}

class _LocalizationsState extends State<MTTLocalizations> {

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      ///通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
