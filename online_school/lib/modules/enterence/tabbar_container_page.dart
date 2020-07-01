import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/common_api.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/event/HttpErrorEvent.dart';
import 'package:online_school/model/check_update_model.dart';
import 'package:online_school/model/unread_count_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/unread_msg_count_reducer.dart';
import 'package:online_school/modules/personal/personal_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/eye_protection_timer.dart';
import 'package:online_school/common/tools/report_timer.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';
import '../personal/message/message_detail_page.dart';
import '../my_course/my_course.dart';

///
/// @name TabBarHomePage
/// @description TabBar 容器页面 包含:1)我的课程;2)我的
/// @author liuca
/// @date 2020-01-10
///
class TabBarHomePage extends StatefulWidget {
  _TabBarHomePageState createState() => _TabBarHomePageState();
}

class _TabBarHomePageState extends State<TabBarHomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController controller;
  bool isSearch = false;
  String data2ThirdPage = '这是传给ThirdPage的值';
  String appBarTitle = tabData[0]['text'];
  static List tabData = [
    {'text': '我的课程', 'icon': Icon(MyIcons.COURSE_TAB)},
    {'text': '个人中心', 'icon': Icon(MyIcons.MINE_TAB)}
  ];

  List<Widget> myTabs = [];
  int last = 0;
  GlobalKey _tabNewKey = GlobalKey();

  MethodChannel methodChannel = const MethodChannel("aixue_wangxiao_channel");

  ///
  /// @MethodName 跳转处理状态3
  /// @Parameter
  /// @ReturnType
  /// @Description
  /// @Author waitwalker
  /// @Date 2020-02-03
  ///
  Future<dynamic> _handler(MethodCall methodCall) {
    print("${methodCall.method}");
    if (SingletonManager.sharedInstance.isHaveLogined == true) {
      SingletonManager.sharedInstance.shouldShowActivityCourse = false;
      /// 这里是否需要跳转到登录页处理一下  还是直接刷新token
      print("首页处理跳转");
      if (methodCall.arguments != null) {
        List<String> arguments = methodCall.arguments.toString().split("&");
        String account = arguments[0];
        String password = arguments[1];
        String isVip = arguments[2];
        String gradeId = arguments[3];
        if (account != null && password != null) {
          SingletonManager.sharedInstance.aixueAccount = account;
          SingletonManager.sharedInstance.aixuePassword = password;
          SingletonManager.sharedInstance.isVip = isVip;
          SingletonManager.sharedInstance.gradeId = gradeId;
        }
      }

      Navigator.pushNamedAndRemoveUntil(
          context, RouteConst.login, (Route<dynamic> route) => false);
    }
    return null;
  }

  Future<bool> doubleClickBack() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('提示'),
            content: new Text('确定要退出App吗？'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('取消'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('确定'),
              ),
            ],
          ),
        ) ??
        false;
  }

  final PageController _controller = PageController(initialPage: 0);
  int _currentIndex = 0;
  final Color _unselectedColor = Color(0xFF8E8E8E);
  final Color _selectedColor = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {

      return Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _controller,
          children: <Widget>[
            /// 我的课程页面
            MyCoursePage(key: _tabNewKey),

            /// 我的页面
            PersonalPage(),
          ],
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index){
            setState(() {
              _controller.jumpToPage(index);
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('static/images/tab_button_class.png', width: 30, height: 30,),
              activeIcon: Image.asset('static/images/tab_button_class_ selected.png', width: 30, height: 30,),
              title: Text("我的课程",style: TextStyle(color: _currentIndex == 0 ? Theme.of(context).primaryColor : _unselectedColor),),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('static/images/tab_button_personal_Center.png', width: 30, height: 30,),
              activeIcon: Image.asset('static/images/tab_button_personal_Center_ selected.png', width: 30, height: 30,),
              title: Text("个人中心",style: TextStyle(color: _currentIndex == 1 ? Theme.of(context).primaryColor : _unselectedColor),),
            ),
          ],
        ),
      );
    });
  }

  Store<AppState> _getStore() => StoreProvider.of<AppState>(context);

  @override
  void initState() {
    super.initState();

    methodChannel.setMethodCallHandler(_handler);
    WidgetsBinding.instance.addObserver(this);
    EyeProtectionTimer.startEyeProtectionTimer(context);
    ReportTimer.startReportTimer(context);

    final JPush jpush = new JPush();

    jpush.addEventHandler(
      onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");

        // 刷新未读消息数红点
        Future.delayed(Duration(seconds: 3), () {
          CourseDaoManager.unreadMsgCount().then((response) {
          if (response.result) {
            var model = response.model as UnreadCountModel;
            _getStore().dispatch(UpdateMsgAction(model?.data ?? 0));
          }
        });
        });
      },
      onOpenNotification: (Map<String, dynamic> message) async {
        var msgId;
        if (Platform.isAndroid) {
          msgId =
              jsonDecode(message['extras']['cn.jpush.android.EXTRA'])['msgId'];
        } else {
          msgId = message['extras']['msgId'];
        }
        var id = (msgId is String) ? int.parse(msgId) : msgId;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => MessageDetailPage(msgId: id)));
        print("flutter onOpenNotification: $message $msgId");
      },
      onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
      },
    );

    ///
    /// @name eventBus
    /// @description event 监听事件
    /// @parameters []
    /// @return void
    /// @author liuca
    /// @date 2020-01-14
    ///
    ErrorCode.eventBus.on<dynamic>().listen((e) {
      if (mounted) {
        if (e is HttpErrorEvent && e.code == ErrorCode.EXPIRED) {
          Fluttertoast.showToast(msg: e.message);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteConst.login, (Route<dynamic> route) => false);
        } else if (e is CardActivatedEvent) {
          _currentIndex = 0;
          controller.animateTo(_currentIndex);
          _tabNewKey = GlobalKey();
        }
      }
    });

    controller = new TabController(
        initialIndex: 0, vsync: this, length: 2); // 这里的length 决定有多少个底导 submenus
    for (int i = 0; i < tabData.length; i++) {
      myTabs.add(Tab(text: tabData[i]['text'], icon: tabData[i]['icon']));
    }
    controller.addListener(() {
      if (controller.indexIsChanging) {
        _onTabChange();
      }
    });
    // Application.controller = controller;
    checkUpdate();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    var last_login = SharedPrefsUtils.getString('last_login');
    var this_login =
        StoreProvider.of<AppState>(context).state.userInfo.data.userName;
    SharedPrefsUtils.putString('last_login',
        StoreProvider.of<AppState>(context).state.userInfo.data.userName);
    if (last_login != this_login) {
      SharedPrefsUtils.remove('record');
    }
  }

  @override
  void dispose() {
    // controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    EyeProtectionTimer.stopTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // 护眼模式，应用退到后台，再回来，重新计时
    // 和直播页面不同的是，观看直播，暂停计时，退出直播，继续计时
    if (state == AppLifecycleState.paused) {
      EyeProtectionTimer.stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      EyeProtectionTimer.startEyeProtectionTimer(context);
    }
    setState(() {});
  }

  void _onTabChange() {
    if (this.mounted) {
      this.setState(() {
        appBarTitle = tabData[controller.index]['text'];
      });
    }
  }

  void _onTap(int index) {
    if (index != _currentIndex) {
      _currentIndex = index;
      setState(() {});
    }
  }

  Future checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var versionName = 'V${packageInfo.version}';
    var checkUpdate = await CommonServiceDao.checkUpdate(version: versionName);
    if (checkUpdate.result && checkUpdate.model != null) {
      var model = checkUpdate.model as CheckUpdateModel;
      if (model.result == 1) {
        var data = model.data;
        if (data.forceType == 1 || model.data.forceType == 2) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                List<Widget> actions = <Widget>[
                  new FlatButton(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        await launch(APIConst.appstoreUrl);
                        if (data.forceType == 2) {
                        } else {
                          Navigator.of(context).pop();
                        }
                        return;
                      } else {
                        await launch(data.url);
                        if (data.forceType == 2) {
                        } else {
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: new Text('确定'),
                  ),
                ];
                if (model.data.forceType == 1) {
                  var cancel = new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: new Text('取消'),
                  );
                  actions.add(cancel);
                }
                return WillPopScope(
                  onWillPop: () => Future.value(model.data.forceType == 1),
                  child: AlertDialog(
                      title: new Text(data.title),
                      content: new Text(data.message),
                      actions: actions),
                );
              });
        }
      }
    }
  }
}
