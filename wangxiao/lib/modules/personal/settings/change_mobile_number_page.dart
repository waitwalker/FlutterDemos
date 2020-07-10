import 'dart:async';
import 'dart:io';
import 'package:online_school/common/dao/original_dao/register_dao.dart';
import 'package:online_school/common/dao/original_dao/sms_dao.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:online_school/modules/widgets/sms_code_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';

///
/// @name
/// @description
/// @author liuca
/// @date 2020-01-11
///
class ChangeMobileNumberPage extends StatefulWidget {
  @override
  _ChangeMobileNumberPageState createState() => _ChangeMobileNumberPageState();
}

class _ChangeMobileNumberPageState extends State<ChangeMobileNumberPage> {
  TextEditingController _mobileController;
  TextEditingController _smsController;

  Future<Null> Function() _onPressed;

  bool _hidePassword;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _mobileController = new TextEditingController();
    _smsController = new TextEditingController();
    _hidePassword = true;
    _onChanged(null);
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
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1.0,
            title: Text('修改手机号'),
            backgroundColor: Colors.white,
            centerTitle: Platform.isIOS ? true : false,
          ),
          backgroundColor: Colors.white,
          body: _buildBody(),
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
              padding:
                  EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 20),
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(text: '您当前的手机号为 ', style: textStyleSubLarge333),
                TextSpan(
                    text: _getMobileNumber(),
                    style: TextStyle(color: Color(MyColors.primaryValue))),
                TextSpan(
                    text:
                        ' ，如果确定更改手机号，请按照下方的提示操作，输入新手机号，获取验证码，然后输入验证码点击更换手机号，即可。 ',
                    style: textStyleSubLarge333),
              ]))),
          Padding(
            padding: EdgeInsets.only(top: 50),
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
              onChanged: _onChanged,
              cursorWidth: 1,
              cursorColor: Color(MyColors.primaryLightValue),
              style: textStyleNormal,
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: [LengthLimitingTextInputFormatter(11)],
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                _focusNode.requestFocus();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                // labelText: '手机号',
                hintText: '新手机号',
                contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
                hintStyle: textStyleHint,
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
            child: Padding(
              padding: EdgeInsets.only(top: 0, left: 5, right: 16),
              child: SmsCodeWidget(
                controller: _smsController,
                focusNode: _focusNode,
                labelText: '输入验证码',
                normalStr: '获取验证码',
                countdownStr: '重新获取',
                normalStyle: textStyleHintPrimary,
                countdownStyle: textStyleHint,
                onChanged: _onChanged,
                onRequest: _requestSms,
                hideDecoration: true,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 37),
          ),
          InkWell(
            child: Container(
              height: 41,
              width: ScreenUtil.getInstance().setHeight(176),
              alignment: Alignment.center,
              child: Text(
                "更改手机号",
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
                  colors: [Color(0xFFFB9716), Color(0xFFF97A2E)],
                ),
              ),
            ),
            onTap: _onPressed,
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
                : await doBind();
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
        await SmsDao.getSms(_mobileController.text, smsType: SmsType.bind);
    var success = sms?.result ?? false;
    toast(sms.model.msg);
    return success;
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  Future<Null> doBind() async {
    // Navigator.pushNamed(context, UIData.register_sms);
    var register = await RegisterDao.bindPhone(
        _mobileController.value.text, _smsController.value.text);
    if (register.result) {
      // 修改成功，更新用户信息
      var userInfo = _getStore().state.userInfo;
      userInfo.data.mobile = _mobileController.value.text;
      _getStore().dispatch(UpdateUserAction(userInfo));

      // 返回
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: register.model.msg);
    } else {
      var msg = (register.model as BaseModel)?.msg ?? '修改失败';
      Fluttertoast.showToast(msg: msg);
    }
  }

  _getMobileNumber() {
    String mobile = _getStore().state.userInfo.data.mobile;
    if (mobile.length == 11) {
      return mobile.replaceRange(3, 7, '****');
    }
    return '1**********';
  }
}
