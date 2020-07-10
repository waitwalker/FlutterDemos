import 'dart:io';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/cclogin_dao.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/check_update_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/course_reducer.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/modules/common_app/enterance/common_bottom_tabbar_page.dart';
import 'package:online_school/modules/personal/settings/change_language.dart';
import 'package:online_school/modules/personal/settings/check_version_page.dart';
import 'package:online_school/modules/personal/settings/about_page.dart';
import 'package:online_school/modules/personal/settings/change_password_page.dart';
import 'package:online_school/modules/personal/settings/check_error_page.dart';
import 'package:online_school/modules/personal/settings/personal_info_page.dart';
import 'package:online_school/modules/personal/settings/qr_page.dart';
import 'package:online_school/modules/personal/settings/scan_qr_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/setting_row.dart';
import 'package:online_school/common/tools/eye_protection_timer.dart';
import 'package:online_school/common/tools/report_timer.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:redux/redux.dart';
import 'battery_page.dart';
import 'change_mobile_number_page.dart';


///
/// @name SettingPage
/// @description 设置页面
/// @author liuca
/// @date 2020-01-11
///
class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> with CheckVersionPage {
  bool _wifi_only;
  CheckUpdateModel versionInfo;

  @override
  void initState() {
    super.initState();
    _wifi_only = SharedPrefsUtils.get('wifi_only', true);
    checkVersionSilence().then((r) {
      if (r != null) {
        setState(() {
          versionInfo = r;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var store = _getStore();
    var state = _getStore().state;
    var userInfo = _getStore().state.userInfo;
    if (userInfo != null) {
      var hasBindMobile = _getStore().state.userInfo.data.bindingStatus == 1;
      return StoreBuilder(
        builder: (BuildContext context, Store<AppState> vm) {
          return Scaffold(
            appBar: AppBar(
              elevation: 1.0,
              title: Text(MTTLocalization.of(context).currentLocalized.setting_page_navigator_title),
              backgroundColor: Colors.white,
              centerTitle: Platform.isIOS ? true : false,
            ),
            backgroundColor: Color(MyColors.background),
            body: settingContent(hasBindMobile, userInfo),
          );
        },
      );
    } else {
      return Scaffold(
        body: Container(),
      );
    }
  }

  Widget settingContent(bool hasBindMobile, UserInfoModel userInfoModel) {
    if (SingletonManager.sharedInstance.mobileName == Config.DEVICE_NAME) {
      return Container(
        child: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_personal_info,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PersonalInfoPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_change_password,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangePasswordPage()));
                },
              ),
              if (hasBindMobile)
                Divider(height: 0.5, color: Colors.black12),
              if (hasBindMobile)
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.setting_page_change_mobile_num,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChangeMobileNumberPage()));
                  },
                ),
              Divider(height: 0.5, color: Colors.black12),
              // SettingRow(
              //   '修改手机',
              // ),
              // Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_about,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_trouble_shoot,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CheckErrorPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_wifi_download_only,
                rightCustomWidget: CupertinoSwitch(
                  onChanged: _toggleWifiOnly,
                  value: _wifi_only,),
                showRightArrow: false,
                onPress: () => _toggleWifiOnly(!_wifi_only),
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                  MTTLocalization.of(context).currentLocalized.setting_page_check_version,
                  showRightArrow: false,
                  onPress: () {
                    checkUpdate(showToast: true);
                  },
                  subText: versionInfo?.data?.forceType == 1
                      ? '发现新版本'
                      : versionInfo?.data?.message ?? '已是最新版本',
                  subTextStyle: TextStyle(
                      fontSize: 12, color: Color(MyColors.black666))),
              Divider(height: 0.5, color: Colors.black12),

              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_change_language,
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChangeLanguagePage();
                  }));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),

              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_change_theme,
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ChangeLanguagePage();
                  }));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),

              SettingRow(
                "二维码",
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return QRPage();
                  }));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),

//              SettingRow(
//                "扫描二维码",
//                onPress: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context){
//                    return ScanQRPage();
//                  }));
//                },
//              ),
//              Divider(height: 0.5, color: Colors.black12),
//
//              SettingRow(
//                "电池",
//                onPress: () {
//                  Navigator.push(context, MaterialPageRoute(builder: (context){
//                    return BatteryPage();
//                  }));
//                },
//              ),
//              Divider(height: 0.5, color: Colors.black12),

              SettingRow(
                "App",
                onPress: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return CommonBottomTabBarPage();
                  }));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
            ],
          ),
          Positioned(
            bottom: 53,
            left: 32,
            right: 32,
            child: Container(
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                disabledColor: Color(MyColors.ccc),
                disabledElevation: 0,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  MTTLocalization.of(context).currentLocalized.setting_page_sign_out,
                  style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal,
                  ),
                ),
                color: Color(MyColors.ccc),
                onPressed: _logout,
              ),
            ),
          )
        ]),
      );
    } else {
      return Container(
        child: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_personal_info,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => PersonalInfoPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_change_password,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ChangePasswordPage()));
                },
              ),
              if (hasBindMobile)
                Divider(height: 0.5, color: Colors.black12),
              if (hasBindMobile)
                SettingRow(
                  MTTLocalization.of(context).currentLocalized.setting_page_change_mobile_num,
                  onPress: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ChangeMobileNumberPage()));
                  },
                ),
              Divider(height: 0.5, color: Colors.black12),
              // SettingRow(
              //   '修改手机',
              // ),
              // Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_about,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => AboutPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_trouble_shoot,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => CheckErrorPage()));
                },
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                MTTLocalization.of(context).currentLocalized.setting_page_wifi_download_only,
                rightCustomWidget: CupertinoSwitch(
                  onChanged: _toggleWifiOnly,
                  value: _wifi_only,),
                showRightArrow: false,
                onPress: () => _toggleWifiOnly(!_wifi_only),
              ),
              Divider(height: 0.5, color: Colors.black12),
              SettingRow(
                  MTTLocalization.of(context).currentLocalized.setting_page_check_version,
                  showRightArrow: false,
                  onPress: () {
                    checkUpdate(showToast: true);
                  },
                  subText: versionInfo?.data?.forceType == 1
                      ? '发现新版本'
                      : versionInfo?.data?.message ?? '已是最新版本',
                  subTextStyle: TextStyle(fontSize: 12, color: Color(MyColors.black666))),
              Divider(height: 0.5, color: Colors.black12),
            ],
          ),
          Positioned(
            bottom: 53,
            left: 32,
            right: 32,
            child: Container(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                disabledColor: Color(MyColors.ccc),
                disabledElevation: 0,
                padding: EdgeInsets.only(top: 12, bottom: 12),
                child: Text(
                  MTTLocalization.of(context).currentLocalized.setting_page_sign_out,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                color: Color.fromRGBO(220, 220, 220, 1.0),
                onPressed: _logout,
              ),
            ),
          )
        ]),
      );
    }
  }

  _toggleWifiOnly(bool value) {
    _wifi_only = value;
    SharedPrefsUtils.put('wifi_only', _wifi_only);
    setState(() {});
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  void _logout() {
    // NavigatorUtils.goLoginCC(context);
    CCLoginDao.logout();
    ReportTimer.stopTimer();
    EyeProtectionTimer.stopTimer();
    SharedPrefsUtils.remove(Config.LOGIN_JSON);
    _getStore().dispatch(UpdateUserAction(null));
    _getStore().dispatch(UpdateCCCourseAction(null));
    JPush().deleteAlias();
    /// 首页弹框置为默认值
    SingletonManager.sharedInstance.isHaveLoadedAlert = false;
    SingletonManager.sharedInstance.isJumpFromAixue = false;
    SingletonManager.sharedInstance.isJumpColdStart = false;
    SingletonManager.sharedInstance.isHaveLogined = false;
    SingletonManager.sharedInstance.shouldShowActivityCourse = true;
    SingletonManager.sharedInstance.aixueAccount = "";
    SingletonManager.sharedInstance.aixuePassword = "";
    SingletonManager.sharedInstance.isVip = "";
    SingletonManager.sharedInstance.gradeId = "";
    Navigator.pushNamedAndRemoveUntil(
        context, RouteConst.login, (Route<dynamic> route) => false);
  }

  _onEyeProtection() {
    Fluttertoast.showToast(msg: '即将上线');
  }
}
