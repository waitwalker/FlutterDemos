import 'dart:io';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/common_api.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/model/config_model.dart';
import 'package:online_school/model/unread_count_model.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/config_reducer.dart';
import 'package:online_school/common/redux/unread_msg_count_reducer.dart';
import 'package:online_school/modules/my_course/assistance_verify/assistance_verify_page.dart';
import 'package:online_school/modules/personal/my_download_page.dart';
import 'package:online_school/modules/personal/order_list_manager_page.dart';
import 'package:online_school/modules/personal/settings/setting_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import '../../common/config/config.dart';
import 'activate_card/activate_card_page.dart';
import 'activate_card/activate_card_state_page.dart';
import '../widgets/common_webview.dart';
import 'error_book/error_book_enterence_page.dart';
import 'eye_protect_remind_page.dart';
import 'feedback_page.dart';
import 'message/message_list_page.dart';

///
/// @name PersonalPage
/// @description 我的页面
/// @author liuca
/// @date 2020-01-10
///
class PersonalPage extends StatefulWidget {
  PersonalPageState createState() => PersonalPageState();
}

class PersonalPageState extends State<PersonalPage> {

  UserInfoModel userInfo;
  ConfigModel config;

  Map<String, dynamic> centerList = {
    "title": "课程激活",
    "imageUrl": "static/images/personal_center_activate.png"
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_getStore().state.config?.data == null) {
      _getConfig();
    }
    getMsg().then((response) {
      if (response.result) {
        var model = response.model as UnreadCountModel;
        _getStore().dispatch(UpdateMsgAction(model?.data ?? 0));
      }
    });
  }

  Future getMsg() => CourseDaoManager.unreadMsgCount();

  @override
  Widget build(BuildContext context) {
    var store = _getStore();
    var state = _getStore().state;

    List<Map<String, dynamic>> bottomLists = [
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_my_card_record, "imageUrl": "static/images/personal_center_indent.png"},
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_eye_protection_reminder, "imageUrl": "static/images/personal_center_eye.png"},
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_feedback, "imageUrl": "static/images/personal_center_opinion.png"},
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_help, "imageUrl": "static/images/personal_center_help.png"},
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_setting, "imageUrl": "static/images/personal_center_set.png"},
      {"title": MTTLocalization.of(context).currentLocalized.personal_page_hubei_public_welfare_class, "imageUrl": "static/images/personal_center_public_welfare.png"},
      {"title": "备案内容承诺", "imageUrl": "static/images/personal_center_record.png"},
    ];

    List<String> titles = [
      MTTLocalization.of(context).currentLocalized.personal_page_my_download,
      MTTLocalization.of(context).currentLocalized.personal_page_study_report,
      MTTLocalization.of(context).currentLocalized.personal_page_error_book];
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      var len = store.state.unread ?? 0;
      return Scaffold(
          body: Container(
        color: Color(MyColors.background),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                height: 206,
                width: double.infinity,
                child: Image.asset(
                  "static/images/personal_center_bg.png",
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: <Widget>[
                  const SizedBox(height: 42),
                  _topContainer(store), // 头像昵称
                  _downloadContainerItem(titles), // 菜单
                  if (store.state.config?.data != null && store.state.config?.data?.ia == 0)
                    _courseActivate(store), // 课程激活
                  _bottomContainer(bottomLists), // 底部我的卡记录等容器
                ],
              ),
              Positioned.directional(
                textDirection: TextDirection.ltr,
                start: 0,
                child: InkWell(
                    child: Container(
                      width: 70,
                      height: 70,
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Positioned.directional(
                            start: 26,
                            top: 40,
                            child: Icon(MyIcons.MESSAGE,
                                color: Colors.white, size: 20),
                            textDirection: TextDirection.ltr,
                          ),
                          if (len > 0)
                            Positioned.directional(
                                child: Container(
                                  width: len < 10 ? 19 : null,
                                  height: 19,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(len.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5625C),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9.5), //设置圆角
                                    ),
                                  ),
                                ),
                                textDirection: TextDirection.ltr,
                                top: 31,
                                start: 38),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MessageListPage()));
                    }),
              )
            ],
          ),
        ),
      ));
    });
  }

  /**
   * @method  顶部容器
   * @description 描述一下方法的作用
   * @date: 2019-07-08 16:08
   * @author: lca
   * @param
   * @return
   */
  _topContainer(Store<AppState> store) {
    userInfo = store.state.userInfo;
    return Column(
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white, width: 2), // 边色与边宽度
              shape: BoxShape.circle, // 圆形，使用圆形时不可以使用borderRadius
            ),
            child: ClipOval(
              child: Image.network(
                store.state.userInfo.data.userPhoto,
                width: 69,
                height: 69,
                fit: BoxFit.cover,
              ),
            )),
        const SizedBox(height: 12),
        // 昵称
        Text(MTTLocalization.of(context).currentLocalized.personal_page_user_name_label + store.state.userInfo.data?.userName ?? MTTLocalization.of(context).currentLocalized.personal_page_user_name_label, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14, color: Color(MyColors.black333),)),
      ],
    );
  }

  /**
   * @method  生成我的下载等容器
   * @description 描述一下方法的作用
   * @date: 2019-07-08 11:49
   * @author: lca
   * @param
   * @return
   */


  _downloadContainerItem(List<String> titles) {
    return Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 25),
        child: Container(
            height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 90 : 78,
            width: MediaQuery.of(context).size.width - 32,
            decoration: _boxDecoration(),
            padding: EdgeInsets.only(top: 12, bottom: 4),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: titles.map(_item).toList())));
  }

  Widget _item(String title) {
    String imagePath;
    if (title == MTTLocalization.of(context).currentLocalized.personal_page_my_download) {
      imagePath = "static/images/personal_center_download.png";
    } else if (title == MTTLocalization.of(context).currentLocalized.personal_page_study_report) {
      imagePath = "static/images/personal_center_report.png";
    } else {
      imagePath = "static/images/personal_center_errors.png";
    }
    return GestureDetector(
      onTap: () {
        // JPush().setBadge(10);

        if (title == MTTLocalization.of(context).currentLocalized.personal_page_my_download) {
          //Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: MyDownloadPage()));
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyDownloadPage()));
        } else if (title == MTTLocalization.of(context).currentLocalized.personal_page_study_report) {
          var url = APIConst.studyReportall;
          var token = NetworkManager.getAuthorization();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CommonWebview(
                  initialUrl: '$url?token=$token&h=${userInfo.data.userPhoto}',
                  title: MTTLocalization.of(context).currentLocalized.personal_page_study_report,
                  action: InkWell(
                      child: Container(
                          padding: EdgeInsets.only(right: 7),
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 26,
                            width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 70 : 62,
                            child: Text('报告详情', style: TextStyle(color: Colors.white, fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 13 : 12),),
                            decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4))),
                                shadows: <BoxShadow>[
                                  BoxShadow(
                                      color: Color(0x466B8DFF),
                                      offset: Offset(0, 0),
                                      blurRadius: 10.0,
                                      spreadRadius: 0.0)
                                ],
                                color: Color(MyColors.primaryLightValue)),
                          ),
                      ),
                      onTap: () {
                        var url = APIConst.studyReport;
                        if (Platform.isAndroid) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CommonWebview(
                                        initialUrl:
                                            '$url?token=$token&cardtype=2',
                                        title: MTTLocalization.of(context).currentLocalized.personal_page_study_report,
                                      )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => CommonWebview(
                                    initialUrl: '$url?token=$token&cardtype=2',
                                    title: MTTLocalization.of(context).currentLocalized.personal_page_study_report,
                                  )));
                        }
                      }))));
        } else {
          /// 跳转到错题本页面
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ErrorBookEnterencePage(fromShuXiao: userInfo.data.schoolType == 2);
          }));
        }
      },
      child: Column(
        children: <Widget>[
          Image.asset(
            imagePath,
            width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 40 : 30,
            height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 40 : 30,
          ),
          Text(
            title,
            style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14, color: Colors.black87),
          )
        ],
      ),
    );
  }

  /**
   * @method  课程激活
   * @description 描述一下方法的作用
   * @date: 2019-07-08 13:52
   * @author: lca
   * @param
   * @return
   */
  _courseActivate(Store<AppState> store) {
    return InkWell(
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 12),
          child: Container(
            decoration: _boxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                  children: <Widget>[
                    Text(Platform.isIOS ? MTTLocalization.of(context).currentLocalized.personal_page_apply_for_course_card : MTTLocalization.of(context).currentLocalized.personal_page_activate_course, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 16, color: Color(MyColors.title_black), fontWeight: FontWeight.w600),),
                    Spacer(),
                    Image.asset(
                      "static/images/personal_center_return.png",
                      width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
                      height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
                    ),
                  ],),
            ),
          ),
        ),
        onTap: () {
          var userInfo = _getStore().state.userInfo;
          if (userInfo.data.bindingStatus == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => userInfo.data.stateType == 0
                ? ActivateCardStatePage()
                : ActivateCardPage())).then((r) {
              if (r ?? false) {
                debugLog('@@@@@@@@@@@--->CODE FIRE');
                ErrorCode.eventBus.fire(CardActivatedEvent());
              }
            });
          } else {
            // bind phone
            Navigator.of(context).pushNamed(RouteConst.bind_phone)
                .then((r) => (r ?? false) ? _toActivatePage(userInfo) : null);
          }
        });
  }

  void _toActivatePage(UserInfoModel userInfo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => userInfo.data.stateType == 0
            ? ActivateCardStatePage()
            : ActivateCardPage())).then((r) {
      if (r ?? false) {
        debugLog('@@@@@@@@@@@--->CODE FIRE');
        ErrorCode.eventBus.fire(CardActivatedEvent());
      }
    });
  }

  /**
   * @method  底部我的卡记录等容器
   * @description 描述一下方法的作用
   * @date: 2019-07-08 15:20
   * @author: lca
   * @param
   * @return
   */
  _bottomContainer(List<Map<String, dynamic>> bottomLists) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
        child: Container(
          decoration: _boxDecoration(),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: <Widget>[...bottomLists.map(_bottomItem)],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color(MyColors.shadow),
            offset: Offset(0, 2),
            blurRadius: 10.0,
            spreadRadius: 2.0)
      ],
    );
  }

  Widget _bottomItem(Map<String, dynamic> dic, {bool showDivider = true}) {
    if (dic == null) return null;

    var content = Container(
      padding: EdgeInsets.symmetric(vertical: SingletonManager.sharedInstance.screenWidth > 500.0 ? 20 : 15,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(
                dic["imageUrl"].toString(),
                width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
                height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
              ),
              Container(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  dic["title"].toString(),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14, color: Colors.black87),
                ),
              ),
              Spacer(),
              Image.asset(
                "static/images/personal_center_return.png",
                width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
                height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
              ),
            ],
          ),
        ],
      ),
    );
    return InkWell(
        onTap: () {
          if (dic["title"].toString() == MTTLocalization.of(context).currentLocalized.personal_page_my_card_record) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => OrderListManagerPage()));
          } else if (dic["title"].toString() == MTTLocalization.of(context).currentLocalized.personal_page_eye_protection_reminder) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EyeProtectRemindPage()));
          } else if (dic["title"].toString() == MTTLocalization.of(context).currentLocalized.personal_page_feedback) {
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return FeedBackPage(-1);
            }));
          } else if (dic["title"].toString() == MTTLocalization.of(context).currentLocalized.personal_page_help) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => CommonWebview(title: MTTLocalization.of(context).currentLocalized.help_page_navigator_title,initialUrl: '${APIConst.practiceHost}/help.html')));
          } else if (dic["title"].toString() == MTTLocalization.of(context).currentLocalized.personal_page_setting) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SettingPage()));
          } else if (dic["title"].toString() == "备案内容承诺") {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => CommonWebview(
                  initialUrl: Config.DEBUG ? "http://gw1.bj.etiantian.net:15688/recordm.html" : "https://www.etiantian.com/recordm.html",
                  title: "备案内容承诺",
                )));
          } else if (dic["title"].toString() == "课程激活") {

          } else if (dic["title"] == MTTLocalization.of(context).currentLocalized.personal_page_hubei_public_welfare_class) {
            if (SingletonManager.sharedInstance.isNewUser) {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AssistanceVerifyPage()));
            } else {
              Fluttertoast.showToast(msg: "该活动仅限新用户参加，您已经是老用户啦，继续学习吧^_^！");
            }
          }
        },
        child: showDivider
            ? Column(
                children: <Widget>[content, Divider(height: 0.5)],
              )
            : content);
  }

  Store<AppState> _getStore() => StoreProvider.of<AppState>(context);

  ///
  /// @name _getConfig
  /// @description 获取激活入口状态
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-05-07
  ///
  Future _getConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var versionName = packageInfo.version;
    var response = await CommonServiceDao.configs(ver: versionName);
    if (response.result) {
      config = response.model as ConfigModel;
      _getStore().dispatch(UpdateConfigAction(config));
    }
  }
}
