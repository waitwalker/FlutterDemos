import 'dart:async';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


typedef Future<bool> RequestSms(dynamic params);

///
/// @name SmsCodeWidget
/// @description 验证码组件
/// @author liuca
/// @date 2020-01-10
///
class SmsCodeWidget extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final TextStyle hintStyle;
  final TextStyle hintStyleFocused;
  final String normalStr;
  final String countdownStr;
  final TextStyle normalStyle;
  final TextStyle countdownStyle;
  final Function onChanged;
  final RequestSms onRequest;
  final bool hideDecoration;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Null Function(String s) onSubmitted;

  SmsCodeWidget(
      {Key key,
      this.controller,
      this.labelText,
      this.hintStyle,
      this.hintStyleFocused,
      this.normalStr,
      this.countdownStr,
      this.normalStyle,
      this.countdownStyle,
      this.hideDecoration = false,
      this.onChanged,
      this.onRequest,
      this.focusNode,
      this.textInputAction,
      this.onSubmitted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SmsCodeState(
        controller: controller,
        labelText: labelText,
        hintStyle: hintStyle,
        hintStyleFocused: hintStyleFocused,
        normalStr: normalStr,
        countdownStr: countdownStr,
        normalStyle: normalStyle,
        countdownStyle: countdownStyle,
        onChanged: onChanged,
        hideDecoration: hideDecoration,
        onRequest: onRequest,
        focusNode: focusNode,
        textInputAction: textInputAction,
        onSubmitted: onSubmitted);
  }
}

class SmsCodeState extends State<SmsCodeWidget> {
  SmsCodeState(
      {this.controller,
      this.labelText,
      this.hintStyle,
      this.hintStyleFocused,
      this.normalStr,
      this.countdownStr,
      this.normalStyle,
      this.countdownStyle,
      this.onChanged,
      this.hideDecoration = false,
      this.onRequest,
      this.focusNode,
      this.textInputAction,
      this.onSubmitted})
      : super();

  final bool hideDecoration;
  final TextEditingController controller;
  final String labelText;
  final TextStyle hintStyle;
  final TextStyle hintStyleFocused;
  final String normalStr;
  final String countdownStr;
  final TextStyle normalStyle;
  final TextStyle countdownStyle;
  final Function onChanged;
  final RequestSms onRequest;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Null Function(String s) onSubmitted;

  static const COUNTDOWN = 60;

  /// 倒计时的计时器。
  Timer _timer;

  /// 当前倒计时的秒数。
  int _seconds;

  /// 当前墨水瓶（`InkWell`）的字体样式。
  TextStyle textStyle;

  /// 当前墨水瓶（`InkWell`）的文本。
  String text = '获取验证码';

  void initState() {
    super.initState();
    _seconds = COUNTDOWN;
    text = normalStr;
    textStyle = textStyleSubLarge333;

    focusNode.addListener(() {
      if (_seconds > 0 && _seconds < 60) return;
      bool hasFocus = focusNode.hasFocus;
      debugLog('----> seconds : $_seconds --> hasFocus: $hasFocus');
      if (hasFocus) {
        textStyle = textStyleSubLargeBlue;
      } else {
        textStyle = textStyleSubLarge333;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    bool hasFocus = focusNode.hasFocus;
    var defaultDecor = InputDecoration(
      prefixIcon: SizedBox(
        height: 20,
        width: 20,
        child: Container(
          width: 30,
          height: 30,
          child: Center(
            child: Image.asset("static/images/code_placeholder_iconx.png",width: 24,height: 24,),
          ),
        ),),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 0.0),
      ),
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Color(MyColors.primaryLightValue), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(22))),
      hintText: labelText,
      hintStyle: (hasFocus ? hintStyleFocused : hintStyle) ?? textStyleHint,
      contentPadding:
          const EdgeInsets.only(top: 12.0, bottom: 12, left: 16, right: 16),
    );
    var hideDecor = InputDecoration(
      border: OutlineInputBorder(borderSide: BorderSide.none),
      hintText: labelText,
      contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 16),
      hintStyle: textStyleHint,
    );
    var tf = TextField(
      onChanged: onChanged,
      focusNode: focusNode,
      cursorWidth: 1,
      cursorColor: Color(MyColors.primaryLightValue),
      style: textStyleNormal,
      keyboardType: TextInputType.numberWithOptions(),
      inputFormatters: [LengthLimitingTextInputFormatter(8)],
      decoration: hideDecoration ? hideDecor : defaultDecor,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      controller: controller,
    );
    return Stack(alignment: Alignment.center, children: <Widget>[
      tf,
      Positioned.directional(
        // top: 0,
        end: 16,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 0.5,
              height: 11,
              color: Color(focusNode.hasFocus
                  ? MyColors.primaryLightValue
                  : MyColors.black333),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: _seconds % COUNTDOWN == 0 ? _onTap : null,
              child: Text(text, style: textStyle),
            ),
          ],
        ),
        textDirection: TextDirection.ltr,
      )
    ]);
  }

  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    task();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => task());
  }

  void task() {
    if (_seconds == 0) {
      _cancelTimer();
      _seconds = COUNTDOWN;
      textStyle = normalStyle;
      setState(() {});
      return;
    }
    _seconds--;
    text = '重新获取(${_seconds}s)';
    textStyle = countdownStyle;
    setState(() {});
    if (_seconds == 0) {
      text = '重新获取';
    }
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _onTap() {
    onRequest({}).then((success) {
      success ? _startTimer() : throw Exception('请求验证码失败');
    }).catchError((err) {});
  }
}
