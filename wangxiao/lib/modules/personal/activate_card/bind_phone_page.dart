import 'dart:async';
import 'package:online_school/common/dao/original_dao/register_dao.dart';
import 'package:online_school/common/dao/original_dao/sms_dao.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/widgets/sms_code_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

///
/// @name BindPhonePage
/// @description 绑定手机号
/// @author liuca
/// @date 2020-01-11
///
class BindPhonePage extends StatefulWidget {
  _BindPhonePageState createState() => _BindPhonePageState();
}

class _BindPhonePageState extends State<BindPhonePage> {
  TextEditingController _mobileController;
  TextEditingController _smsController;

  Future<Null> Function() _onPressed;
  FocusNode _userFocusNode = FocusNode();
  FocusNode _smsCodeFocusNode = FocusNode();

  @override
  void initState() {
    _mobileController = new TextEditingController(text: '');
    _smsController = new TextEditingController(text: '');
    _onChanged(null);

    _userFocusNode.addListener(() {
      setState(() {});
    });
    _smsCodeFocusNode.addListener(() {
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
        FocusScope.of(context).requestFocus(new FocusNode());
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
              padding: EdgeInsets.only(left: 28, top: 104),
              alignment: Alignment.centerLeft,
              child: Text('手机号绑定', style: textStyle24222),
            ),
            Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            Container(
              height: 44,
              width: 304,
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
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.primaryLightValue),
                            width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(22))),
                    contentPadding:
                        const EdgeInsets.only(top: 12.0, bottom: 12, left: 16),
                    hintText: '请输入手机号',
                    hintStyle: _userFocusNode.hasFocus
                        ? textStyleHint
                        : textStyleNormal,
                  ),
                  controller: _mobileController,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 28),
            ),
            Container(
              height: 44,
              width: 304,
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
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 37),
            ),
            InkWell(
              child: Container(
                height: 41,
                width: 176,
                alignment: Alignment.center,
                child: Text(
                  "绑定",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
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
                  gradient: LinearGradient(
                    colors: [Color(0xFF6B86FF), Color(0xFF4D67D4)],
                  ),
                ),
              ),
              onTap: _onPressed,
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            Container(
              width: 304,
              child: Text(
                  '应国家法律要求，使用互联网服务需要进行实名认证。为保障网校账号的正常使用，请完成手机号验证，感谢您的理解与支持。',
                  style: textStyleSub),
            ),
          ],
        ),
      ),
    );
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
                : await doBind();
  }

  toast(msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  Future<Null> doBind() async {
    // Navigator.pushNamed(context, UIData.register_sms);
    var register = await RegisterDao.bindPhone(
        _mobileController.value.text, _smsController.value.text);
    if (register.result) {
      // NavigatorUtils.goHome(context);
      Fluttertoast.showToast(msg: register.model.msg);
      var userInfo = _getStore().state.userInfo;
      userInfo.data.bindingStatus = 1;
      userInfo.data.mobile = _mobileController.value.text;
    } else {
      var msg = (register.model as BaseModel)?.msg ?? '绑定失败';
      Fluttertoast.showToast(msg: msg);
    }
    Navigator.pop(context, register.result);
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  Future<bool> _requestSms(params) async {
    bool malformed = !RegExp(r"^1\d{10}$").hasMatch(_mobileController.text);
    if (malformed) {
      toast('手机号格式不正确');
      return false;
    }
    var sms = await SmsDao.getSms(_mobileController.value.text,
        smsType: SmsType.bind, forBasicToken: true);
    var success = sms?.result ?? false;
    if (success) {
      Fluttertoast.showToast(msg: sms.model.msg);
    } else {
      Fluttertoast.showToast(msg: sms.model?.msg ?? '获取验证码失败');
    }
    return success;
  }
}
