import 'dart:io';

import 'package:online_school/common/dao/original_dao/cclogin_dao.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// @name ChangePasswordPage
/// @description 修改密码页面
/// @author liuca
/// @date 2020-01-11
///
class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _password;
  TextEditingController _newPassword;
  TextEditingController _confirmPassword;

  @override
  void initState() {
    _password = TextEditingController();
    _newPassword = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text('修改密码'),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
        ),
        body: Container(
          padding: EdgeInsets.only(top: 16, left: 32, right: 32),
          child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    hintText: '请输入原始密码',
                    hintStyle: textStyleHint,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.line),
                            width: 1,
                            style: BorderStyle.solid)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  controller: _newPassword,
                  decoration: InputDecoration(
                    hintText: '请输入新密码',
                    hintStyle: textStyleHint,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.line),
                            width: 1,
                            style: BorderStyle.solid)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                TextField(
                  controller: _confirmPassword,
                  decoration: InputDecoration(
                    hintText: '请再次输入新密码',
                    hintStyle: textStyleHint,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.line),
                            width: 1,
                            style: BorderStyle.solid)),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 39)),
                Container(
                  width: 296,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    disabledColor: Color(MyColors.ccc),
                    disabledElevation: 0,
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      "确定",
                      style: textStyle18WhiteBold,
                    ),
                    color: Color(MyColors.primaryValue),
                    onPressed: _onPressed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onPressed() {
    FocusScope.of(context).requestFocus(new FocusNode());
    _password.text?.isEmpty ?? true
        ? toast('请输入密码')
        : _newPassword.text?.isEmpty ?? true
            ? toast('请输入新密码')
            : _confirmPassword.text?.isEmpty ?? true
                ? toast('请输入确认密码')
                : _newPassword.text != _confirmPassword.text
                    ? toast('密码输入不一致')
                    : _password.text == _newPassword.text
                        ? toast('新密码不能和旧密码相同')
                        : checkPassword(_newPassword.text, doChangePassword);
  }

  toast(msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  doChangePassword() async {
    var changePassword =
        await CCLoginDao.changePassword(_password.text, _newPassword.text);
    var model = changePassword.model as BaseModel;
    if (changePassword.result && model != null && model.code == 1) {
      toast('密码修改成功');
      Navigator.pop(context);
    } else {
      toast(model.msg);
    }
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
}
