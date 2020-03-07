import 'package:flutter/material.dart';

///
/// @ClassName FlutterPainter
/// @Description 绘制类
/// @Author waitwalker
/// @Date 2020-03-07
///
class FlutterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// 初始化画笔
    var paint = Paint()
      ..strokeWidth = 25.0
      ..color = Colors.red;

    /// 通过canvas画一条直线
    canvas.drawLine(Offset(95, 0), Offset(95, 300), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
