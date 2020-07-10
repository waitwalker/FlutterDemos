import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/eye_protection_timer.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

///
/// @name
/// @description
/// @author liuca
/// @date 2020-01-11
///
class EyeProtectRemindPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EyeProtectRemindPageState();
  }
}

class _EyeProtectRemindPageState extends State<EyeProtectRemindPage> {
  bool isOpen = SharedPrefsUtils.get<bool>('eye_protect_on', true);

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: _appBar(),
        body: _body(),
      );
    });
  }

  /// 导航栏
  _appBar() {
    return AppBar(
      elevation: 1,
      ///阴影高度
      titleSpacing: 0,
      title: Text(MTTLocalization.of(context).currentLocalized.eye_protection_reminder_page_navigator_title, style: TextStyle(fontSize: 20, color: Color.fromRGBO(0, 0, 0, 0.87)),),
      backgroundColor: Color(MyColors.white),
      centerTitle: Platform.isIOS ? true : false,
    );
  }

  /// body
  _body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 18, left: 16, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      MTTLocalization.of(context).currentLocalized.eye_protection_reminder_page_navigator_title,
                      style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 20 : 16, color: Color(MyColors.eyeProtectRemindBlack),),),
                    CupertinoSwitch(
                      activeColor: Color(0xFF52D257),
                      value: isOpen,
                      onChanged: (bool current) {
                        isOpen = current;
                        setState(() {
                          if (isOpen) {
                            SharedPrefsUtils.put<bool>('eye_protect_on', true);
                            EyeProtectionTimer.startEyeProtectionTimer(context);
                          } else {
                            SharedPrefsUtils.put<bool>('eye_protect_on', false);
                            EyeProtectionTimer.stopTimer();
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25, left: 16, right: 16),
                child: Text(MTTLocalization.of(context).currentLocalized.eye_protection_reminder_page_content, maxLines: 5, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 15, color: Color(0xff333333)),),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 50, left: 40, right: 40),
              child: Image.asset(
                "static/images/set_eyeshield.png",
                height: 230,
              ),
            ),
          ],
        )
      ],
    );
  }
}
