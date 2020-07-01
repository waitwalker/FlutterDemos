import 'dart:io';

import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'activate_card_page.dart';
import 'activate_card_state_page.dart';


///
/// @name ActivateCardTypePage
/// @description 激活卡类型
/// @author liuca
/// @date 2020-01-11
///
class ActivateCardTypePage extends StatefulWidget {
  ActivateCardTypePage({Key key}) : super(key: key);

  _ActivateCardTypePageState createState() => _ActivateCardTypePageState();
}

class _ActivateCardTypePageState extends State<ActivateCardTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择激活卡类型'),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _cardOne(),
            const SizedBox(height: 20),
            _cardTwo(),
          ],
        ),
      ),
    );
  }

  _cardOne() {
    return InkWell(
        child: Container(
          // width: 328,
          height: 201,
          padding: EdgeInsets.only(left: 32, top: 24),
          decoration: BoxDecoration(
              // color: Colors.grey,
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              image: DecorationImage(
                  image: AssetImage('static/images/zhilingka.png'),
                  fit: BoxFit.cover)),
        ),
        onTap: _onTap);
  }

  _cardTwo() {
    return InkWell(
        child: Container(
          width: 328,
          height: 201,
          padding: EdgeInsets.only(left: 32, top: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            image: DecorationImage(
                image: AssetImage('static/images/zhixueka.png'),
                fit: BoxFit.cover),
          ),
        ),
        onTap: _onTap);
  }

  void _toActivate() {
    var userInfo = _getStore().state.userInfo;
    if (userInfo.data.bindingStatus == 1) {
      _toActivatePage(userInfo);
    } else {
      // bind phone
      Navigator.of(context)
          .pushNamed(RouteConst.bind_phone)
          .then((r) => (r ?? false) ? _toActivatePage(userInfo) : null);
    }
  }

  void _toActivatePage(UserInfoModel userInfo) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => userInfo.data.stateType == 0
            ? ActivateCardStatePage()
            : ActivateCardPage()));
  }

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  void _onTap() => _toActivate();
}
