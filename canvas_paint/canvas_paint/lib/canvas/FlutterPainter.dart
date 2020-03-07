import 'package:flutter/material.dart';


class FlutterPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..strokeWidth = 2.0
        ..color = Colors.red;
    canvas.drawLine(Offset(100, 100), Offset(200, 300), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}