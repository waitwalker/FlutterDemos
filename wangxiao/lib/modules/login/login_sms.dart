import 'dart:async';
import 'package:online_school/common/dao/original_dao/cclogin_dao.dart';
import 'package:online_school/common/dao/original_dao/ccuser_info_dao.dart';
import 'package:online_school/common/dao/original_dao/sms_dao.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:online_school/modules/widgets/sms_code_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/rounded_gradient_ripple_button.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/modules/enterence/navigation_route.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:redux/redux.dart';

///
/// @name LoginSmsPage
/// @description 短信登录页面
/// @author liuca
/// @date 2020-01-10
///
class LoginSmsPage extends StatefulWidget {
  @override
  _LoginSmsPageState createState() => _LoginSmsPageState();
}

class _LoginSmsPageState extends State<LoginSmsPage> {
  TextEditingController _mobileController;
  TextEditingController _smsController;
  Future<Null> Function() _onPressed;
  bool _hidePassword;
  FocusNode _userFocusNode = FocusNode();
  FocusNode _smsCodeFocusNode = FocusNode();

  @override
  void initState() {
    _mobileController = new TextEditingController();
    _smsController = new TextEditingController();
    _hidePassword = true;
    _onChanged(null);

    _userFocusNode.addListener(() {
      setState(() {});
    });
    _smsCodeFocusNode.addListener(() {
      debugLog('${_smsCodeFocusNode.hasFocus}');
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return new StoreBuilder(
        builder: (BuildContext context, Store<AppState> store) {
      return new GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _smsCodeFocusNode.unfocus();
          debugLog(_smsCodeFocusNode.hasFocus);
          // setState(() {});
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image(
                      image:
                          AssetImage('static/images/login_background_top.png'),
                      width: 200,
                      fit: BoxFit.contain),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Image(
                      image:
                          AssetImage('static/images/login_background_down.png'),
                      fit: BoxFit.contain),
                ),
                _buildBody(),
                Positioned(
                  left: 30,
                  top: 39,
                  child: InkWell(
                    child: Icon(Icons.arrow_back, color: Color(0xFF989797)),
                    onTap: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  SingleChildScrollView _buildBody() {
    return SingleChildScrollView(
      // padding: EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            // width: double.infinity,
            padding: EdgeInsets.only(
                left: ScreenUtil.getInstance().setWidth(28),
                top: ScreenUtil.getInstance().setHeight(104)),
            alignment: Alignment.centerLeft,
            child: Text('手机登录', style: textStyle24222),
          ),
          Padding(
            padding: EdgeInsets.only(top: 60),
          ),
          Container(
            height: 44,
            width: ScreenUtil.getInstance().setWidth(304),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x66B2C1D9),
                    offset: Offset(3, 4),
                    blurRadius: 10.0,
                    spreadRadius: 2.0)
              ],
            ),
            child: Center(
                child: TextField(
              focusNode: _userFocusNode,
              onChanged: _onChanged,
              cursorWidth: 1,
              cursorColor: Color(MyColors.primaryLightValue),
              style: textStyleNormal,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [LengthLimitingTextInputFormatter(11)],
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _smsCodeFocusNode.requestFocus();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                contentPadding:
                    const EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(MyColors.primaryLightValue), width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(22))),
                // labelText: '手机号',
                hintText: '请输入手机号',
                // contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                hintStyle:
                    _userFocusNode.hasFocus ? textStyleHint : textStyleNormal,
              ),
              controller: _mobileController,
            )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 28),
          ),
          Container(
            height: 44,
            width: ScreenUtil.getInstance().setWidth(304),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(22.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Color(0x66B2C1D9),
                    offset: Offset(3, 4),
                    blurRadius: 10.0,
                    spreadRadius: 2.0)
              ],
            ),
            child: Container(
              child: SmsCodeWidget(
                controller: _smsController,
                focusNode: _smsCodeFocusNode,
                labelText: '输入验证码',
                normalStr: '获取验证码',
                countdownStr: '重新获取',
                hintStyle: textStyleNormal,
                hintStyleFocused: textStyleHint,
                normalStyle: textStyleHint,
                countdownStyle: textStyleHint,
                onChanged: _onChanged,
                onRequest: _requestSms,
                hideDecoration: false,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 37),
          ),
          RaisedGradientRippleButton(
            radius: 22.0,
            gradient: LinearGradient(
              colors: [Color(0xFF6B86FF), Color(0xFF4D67D4)],
            ),
            boxShadow: [
              BoxShadow(
                  color: Color(0x66B2C1D9),
                  offset: Offset(3, 4),
                  blurRadius: 10.0,
                  spreadRadius: 2.0)
            ],
            child: Text(
              "登录",
              style: textStyle18WhiteBold,
            ),
            onPressed: _onPressed,
          ),
          Padding(
            padding: EdgeInsets.only(top: 200),
          ),
        ],
      ),
    );
  }

  void onTogglePasswordVisible() {
    _hidePassword = !_hidePassword;
    setState(() {});
  }

  void _onChanged(String value) {
    var username = _mobileController.text;
    if (username == null || username.isEmpty) {
      _onPressed = null;
    } else {
      _onPressed = onPressed;
    }
    setState(() {});
  }

  Future<Null> onPressed() async {
    _mobileController.text?.isEmpty ?? true
        ? toast('手机号不能为空')
        : !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text)
            ? toast('手机号格式不正确')
            : _smsController.text?.isEmpty ?? true
                ? toast('验证码不能为空')
                : await doLoginByCode();
  }

  toast(msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  Future<bool> _requestSms(params) async {
    bool malformed = !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text);
    if (malformed) {
      toast('手机号格式不正确');
      return false;
    }
    var sms =
        await SmsDao.getSms(_mobileController.text, smsType: SmsType.login);
    var success = sms?.result ?? false;
    toast(sms.model.msg);
    return success;
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  doLoginByCode() async {
    var result = await CCLoginDao.loginByCode(
        _mobileController.text, _smsController.text);
    if (result.result && result.model != null) {
      var info = await CCUserInfoDao.getUserInfo();
      if (info.result && info.model != null && info.model.code == 1) {
        var model = info.model as UserInfoModel;
        _getStore().dispatch(UpdateUserAction(model));

        JPush().setAlias(model.data.userId.toString());
        NavigatorRoute.goHome(context);
      } else {
        // TODO userinfo error
      }
    } else {
      Fluttertoast.showToast(msg: result?.data['msg'] ?? '登录失败');
    }
  }
}
