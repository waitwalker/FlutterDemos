import 'package:flutter/material.dart';


class FlutterPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
        ..strokeWidth = 25.0
        ..color = Colors.red;
    canvas.drawLine(Offset(95, 0), Offset(95, 300), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}