import 'dart:async';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/dao/original_dao/register_dao.dart';
import 'package:online_school/common/dao/original_dao/sms_dao.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/modules/widgets/sms_code_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/radio_button.dart';
import 'package:online_school/modules/widgets/rounded_gradient_ripple_button.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../widgets/common_webview.dart';

///
/// @name RegisterPage
/// @description 注册页面
/// @author liuca
/// @date 2020-01-10
///
class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _mobileController;
  TextEditingController _smsController;
  TextEditingController _passwordController;

  Future<Null> Function() _onPressed;
  bool agree;

  bool _hidePassword = true;
  FocusNode _userFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  FocusNode _smsCodeFocusNode = FocusNode();

  bool showAccountDelete = false; ///删除是否可见
  bool showPasswordVisible = false; ///控制密码明文密文
  bool shouldHideVisible = true; ///密码明文密文按钮是否可见

  @override
  void initState() {
    _mobileController = new TextEditingController();
    _smsController = new TextEditingController();
    _passwordController = new TextEditingController();
    _onChanged(null);
    agree = false;

    _userFocusNode.addListener(() {
      if (!_userFocusNode.hasFocus) {
        showAccountDelete = false;
      } else {
        if (_mobileController.text.length > 0) {
          showAccountDelete = true;
        }
      }
      setState(() {});
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        shouldHideVisible = false;
      } else {
        if (_passwordController.text.length > 0) {
          shouldHideVisible = true;
        }
      }
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
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.red,
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _userFocusNode.unfocus();
        _passwordFocusNode.unfocus();
        _smsCodeFocusNode.unfocus();
      },
      child: Scaffold(
        body: Stack(
          alignment: Alignment.centerRight,
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
                  image: AssetImage('static/images/login_background_down.png'),
                  fit: BoxFit.contain),
            ),
            _buildBody(context),
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
    );
  }

  Widget _buildBody(BuildContext context) {
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
              child: Text('注册', style: textStyle24222),
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
                  keyboardType: TextInputType.numberWithOptions(),
                  inputFormatters: [LengthLimitingTextInputFormatter(11)],
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    _smsCodeFocusNode.requestFocus();
                  },
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      height: 20,
                      width: 20,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: Image.asset("static/images/account_placeholder_icon.png",width: 24,height: 24,),
                        ),
                      ),),
                    suffixIcon: !showAccountDelete ? Container(width: 1,height: 1,) : GestureDetector(
                      child: Icon(Icons.close,size: 20,color: Color(0xff7494EC),),
                      onTap: (){
                        if (_mobileController.text.length > 0){
                          _mobileController.text = "";
                          showAccountDelete = false;
                          setState(() {

                          });
                        }
                      },
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.primaryLightValue),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    hintText: '输入手机号',
                    contentPadding:
                        const EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                    hintStyle: _userFocusNode.hasFocus
                        ? textStyleHint
                        : textStyleNormal,
                  ),
                  controller: _mobileController,
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
              child: Container(
                child: TextField(
                  obscureText: !showPasswordVisible,
                  onChanged: _onChanged,
                  focusNode: _passwordFocusNode,
                  cursorWidth: 1,
                  cursorColor: Color(MyColors.primaryLightValue),
                  style: textStyleNormal,
                  keyboardType: TextInputType.text,
                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _onPressed(),
                  decoration: InputDecoration(
                    prefixIcon: SizedBox(
                      height: 20,
                      width: 20,
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: Image.asset("static/images/password_placeholder_icon.png",width: 24,height: 24,),
                        ),
                      ),),
                    suffixIcon: GestureDetector(
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Center(
                          child: shouldHideVisible ? Image.asset(!showPasswordVisible ? "static/images/visible_placeholder_icon.png" : "static/images/invisible_placeholder_icon.png",width: 24,height: 24,) : Container(),
                        ),
                      ),
                      onTap: (){
                        showPasswordVisible = !showPasswordVisible;
                        setState(() {

                        });
                      },
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.primaryLightValue),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    hintText: '输入密码',
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
                "注册",
                style: textStyle18WhiteBold,
              ),
              onPressed: _onPressed,
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Container(
              width: 176,
              child: Row(
                children: <Widget>[
                  MyRadio(
                    checked: agree,
                    label: '',
                    onTap: () {
                      agree = !agree;
                      setState(() {});
                    },
                  ),
                  InkWell(
                    child: Text('阅读并同意用户服务协议', style: textStyleSub),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) {
                            return CommonWebview(
                                initialUrl:
                                    'http://www.etiantian.com/about/mobile/servandpriv.html',
                                title: '用户协议');
                          }));
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onChanged(String value) {
    if (_mobileController != null) {
      if (_mobileController.text.length > 0) {
        showAccountDelete = true;
      } else {
        showAccountDelete = false;
      }
    }

    if (_passwordController != null) {
      if (_passwordController.text.length > 0) {
        shouldHideVisible = true;
      } else {
        shouldHideVisible = false;
      }
    }

    var username = _mobileController.text;
    if (username == null || username.isEmpty) {
      _onPressed = null;
    } else {
      _onPressed = onPressed;
    }
    setState(() {});
  }

  Future<Null> onPressed() async {
    _userFocusNode.unfocus();
    _passwordFocusNode.unfocus();
    _smsCodeFocusNode.unfocus();
    _mobileController.text?.isEmpty ?? true
        ? toast('手机号不能为空')
        : !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text)
            ? toast('手机号格式不正确')
            : _smsController.text?.isEmpty ?? true
                ? toast('验证码不能为空')
                : !agree
                    ? toast('请先阅读并同意用户服务协议')
                    : checkPassword(_passwordController.text, doRegister);
  }

  Future doRegister() async {
    var register = await RegisterDao.register(_mobileController.value.text,
        _smsController.value.text, _passwordController.value.text);
    var model = register.model as BaseModel;
    if (register.result && model.code == 1) {
      Navigator.pushNamed(context, RouteConst.login);
      Fluttertoast.showToast(msg: register.model.msg);
    } else {
      toast(model.msg);
    }
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

  Future<bool> _requestSms(params) async {
    bool malformed = !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text);
    if (malformed) {
      toast('手机号格式不正确');
      return false;
    }
    var sms = await SmsDao.getSms(_mobileController.value.text,
        smsType: SmsType.register);
    var success = sms?.result ?? false;
    toast(sms.model.msg);
    return success;
  }

  void onTogglePasswordVisible() {
    _hidePassword = !_hidePassword;
    setState(() {});
  }
}
