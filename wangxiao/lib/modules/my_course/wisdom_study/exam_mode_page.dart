import 'dart:math';

import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/tools/timer_tool.dart';
import 'package:online_school/model/self_model.dart';
import 'package:online_school/modules/widgets/microcourse_webview.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// @name ExamModePage
/// @description 马上考试&马上练习
/// @author liuca
/// @date 2020-02-18
///
class ExamModePage extends StatefulWidget {
  ResourceIdListEntity data;
  var courseCardCourseId;

  ExamModePage(this.data, this.courseCardCourseId);
  @override
  State<StatefulWidget> createState() {
    return _ExamModeState();
  }
}

class _ExamModeState extends State<ExamModePage> {

  TimerTool _timerTool;
  String dateString = "";
  String weekString = "";
  String hourString = "";
  String minString = "";
  String secString = "";
  String dayTime = "AM";
  bool showDoubleDot = true;
  double scale = 0.0;

  @override
  void initState() {
    _orientationScreen(true);
    _startCountDown();
    super.initState();
  }

  _orientationScreen(bool landscape) async {
    if (landscape) {
      /// 强制横屏
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight]);
    } else {
      /// 强制竖屏
      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);
    }
  }

  @override
  void dispose() {
    if (_timerTool != null) _timerTool.cancel();
    _orientationScreen(false);
    super.dispose();
  }

  ///
  /// @name 倒计时
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-15
  ///
  void _startCountDown() {
    _timerTool = TimerTool(mTotalTime: 24 * 60 * 60 * 1000);
    _timerTool.setOnTimerTickCallback((int tick) {
      double _tick = tick / 1000;
      setState(() {
        _formatDate();
      });
      if (_tick == 0) {
        Navigator.of(context).pop();
      }
    });
    _timerTool.startCountDown();
  }

  _formatDate() {
    DateTime dateTime = DateTime.now();
    dayTime = dateTime.hour >= 12 ? "PM" : "AM";
    dateString = formatDate(dateTime, [yyyy, "-", mm, "-", dd]);
    weekString = formatDate(dateTime, [DD]);
    hourString = formatDate(dateTime, [HH]);
    minString = formatDate(dateTime, [nn]);
    secString = formatDate(dateTime, [ss]);
    showDoubleDot = !showDoubleDot;
    double hourSec = double.parse(hourString) * 60 * 60;
    double minSec = double.parse(minString) * 60;
    double secSec = double.parse(secString);
    scale = (hourSec + minSec + secSec) / (24 * 60 * 60.0);

    print("日期:$dateString");
    print("星期:$weekString");
    print("小时:$hourString");
    print("分钟:$minString");
    print("秒:$secString");
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.height > 360 ? 75 : 70;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 37,left: 44,right: 41),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10,top: 10),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4.0))),
                      disabledColor: Color(MyColors.ccc),
                      disabledElevation: 0,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text('结束答题', style: TextStyle(fontSize: 13, color: Color(0xff6B8DFF), fontWeight: FontWeight.normal,),),
                      color: Color(0x516B8DFF),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
                          var token = NetworkManager.getAuthorization();
                          var abpid = widget.data.resId;
                          var abpname = Uri.encodeComponent(widget.data.resName);
                          var abpqids = widget.data.srcABPaperQuesIds;
                          var url =
                              '${APIConst.practiceHost}/ab.html?token=$token&abpid=$abpid&abpname=$abpname&abpqids=$abpqids&courseid=${widget.courseCardCourseId}';
                          return MicrocourseWebPage(
                            initialUrl: url,
                            resourceId: widget.data.resId,
                            resourceName: widget.data.resName,
                            isAb: true,
                            srcABPaperQuesIds: widget.data.srcABPaperQuesIds,
                          );
                        }));
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 32,
                      height: 32,
                      child: Image.asset('static/images/exam_end_answer_scale.png',
                          width: 32, height: 32),
                    ),
                    onTap: (){
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 253) / 2,
              top: (MediaQuery.of(context).size.height - 253) / 2,
              child: Container(
                alignment: Alignment.center,
                height: 253,
                width: 253,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(253 / 2.0),
                  border: Border.all(color: Color(0x52979797),width: 5)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(hourString,style: TextStyle(color: Colors.white,fontSize: fontSize),),
                    Padding(padding: EdgeInsets.only(left: 3),),
                    Column(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 70)),
                        Text(":",style: TextStyle(color: showDoubleDot ? Colors.white : Colors.grey,fontSize: fontSize),),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(left: 3),),
                    Text(minString,style: TextStyle(color: Colors.white,fontSize: fontSize),),
                  ],
                ),
            ),),

            Positioned(
              left: (MediaQuery.of(context).size.width - 253) / 2,
              top: (MediaQuery.of(context).size.height - 253) / 2,
              child: Container(
                height: 253,
                width: 253,
                child: CustomPaint(
                  painter: EndAnswerPainter(scale),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EndAnswerPainter extends CustomPainter {

  final double scale;

  EndAnswerPainter(this.scale);

  @override
  paint(Canvas canvas, Size size)  {
    Paint paint = Paint()
      ..isAntiAlias = true
      ..color = Color(0xff6B8DFF)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    /// Offset(),横纵坐标偏移
    /// void drawArc(Rect rect, double startAngle, double sweepAngle, bool useCenter, Paint paint)
    /// Rect来确认圆弧的位置, 开始的弧度、结束的弧度、是否使用中心点绘制(圆弧是否向中心闭合)、以及paint.
    final center = Offset(253/2, 253/2);
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        -pi / 2, 2 * pi * scale, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PlacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("占位页面"),
       backgroundColor: Colors.white,
     ),
     body: Container(
       color: Color(MyColors.background),
     ),
   );
  }
}


