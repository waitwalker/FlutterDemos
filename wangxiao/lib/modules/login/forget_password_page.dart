import 'dart:async';
import 'package:online_school/common/dao/original_dao/cclogin_dao.dart';
import 'package:online_school/common/dao/original_dao/sms_dao.dart';
import 'package:online_school/modules/widgets/sms_code_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/rounded_gradient_ripple_button.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


///
/// @name ForgetPasswordPage
/// @description 忘记密码
/// @author liuca
/// @date 2020-01-10
///
class ForgetPasswordPage extends StatefulWidget {
  @override
  _ForgetPasswordPageState createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController _mobileController;
  TextEditingController _smsController;
  TextEditingController _passwordController;

  Future<Null> Function() _onPressed;

  bool _hidePassword;
  FocusNode _userFocusNode = FocusNode();
  FocusNode _smsCodeFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    _mobileController = new TextEditingController();
    _smsController = new TextEditingController();
    _passwordController = new TextEditingController();
    _hidePassword = true;
    _onChanged(null);

    _userFocusNode.addListener(() {
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      setState(() {});
    });
    _smsCodeFocusNode.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }

  Widget _build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        // appBar: AppBar(
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        // title: Text('忘记密码'),
        // ),
        body: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                child: Image(
                    image: AssetImage('static/images/login_background_top.png'),
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
  }

  Container _buildBody() {
    return Container(
      color: Colors.transparent,
      height: double.infinity,
      // padding: EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              // width: double.infinity,
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(28),
                  top: ScreenUtil.getInstance().setHeight(104)),
              alignment: Alignment.centerLeft,
              child: Text('忘记密码', style: textStyle24222),
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
              child: Container(
                  child: TextField(
                focusNode: _userFocusNode,
                onChanged: _onChanged,
                cursorWidth: 1,
                cursorColor: Color(MyColors.primaryLightValue),
                style: textStyleNormal,
                keyboardType: TextInputType.number,
                inputFormatters: [LengthLimitingTextInputFormatter(11)],
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  _smsCodeFocusNode.requestFocus();
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(MyColors.primaryLightValue), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(22))),
                  hintText: '手机号',
                  contentPadding:
                      const EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                  hintStyle:
                      _userFocusNode.hasFocus ? textStyleHint : textStyleNormal,
                ),
                controller: _mobileController,
              )),
            ),
            Padding(padding: EdgeInsets.only(top: 28)),
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
                  normalStyle: textStyleHintPrimary,
                  countdownStyle: textStyleHint,
                  onChanged: _onChanged,
                  onRequest: _requestSms,
                  hideDecoration: false,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 28)),
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
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 0),
                child: TextField(
                  onChanged: _onChanged,
                  focusNode: _passwordFocusNode,
                  cursorWidth: 1,
                  cursorColor: Color(MyColors.primaryLightValue),
                  style: textStyleNormal,
                  // keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.primaryLightValue),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    hintText: '新密码',
                    contentPadding:
                        const EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                    hintStyle: _passwordFocusNode.hasFocus
                        ? textStyleHint
                        : textStyleNormal,
                  ),
                  controller: _passwordController,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 28),
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
              padding: EdgeInsets.only(top: 12),
            ),
          ],
        ),
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
                : _passwordController.text?.isEmpty ?? true
                    ? toast('密码不能为空')
                    : checkPassword(_passwordController.text, doFindPassword);
  }

  toast(msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  checkPassword(String pwd, Function callback) {
    pwd?.isEmpty ?? true
        ? toast('密码不能为空')
        : pwd.length < 6
            ? toast('密码不能小于6个字符')
            : pwd.length > 16
                ? toast('密码不能超过16个字符')
                : RegExp('^\\d+\$').hasMatch(pwd)
                    ? toast('密码不能全是数字')
                    : !RegExp('[0-9a-zA-Z_]{6,16}').hasMatch(pwd)
                        ? toast('密码只能由字母、数字和下划线组成，长度6~16位')
                        : callback();
  }

  Future<Null> doFindPassword() async {
    var result = await CCLoginDao.findPassword(
        _mobileController.text, _smsController.text, _passwordController.text);
    if (result.result) {
      Fluttertoast.showToast(msg: result.model?.msg ?? '修改成功');
      Navigator.pop(context);
    } else {
      var error;
      if (result.model != null) {
        error = result.model.msg;
      } else {
        error = '找回密码失败';
      }
      Fluttertoast.showToast(msg: error);
    }
  }

  Future<bool> _requestSms(params) async {
    bool malformed = !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text);
    if (malformed) {
      toast('手机号格式不正确');
      return false;
    }
    var sms =
        await SmsDao.getSms(_mobileController.text, smsType: SmsType.forget);
    var success = sms?.result ?? false;
    toast(sms.model.msg);
    return success;
  }
}
