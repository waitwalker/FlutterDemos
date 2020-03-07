import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

///
/// @ClassName FlutterPainter
/// @Description 绘制类
/// @Author waitwalker
/// @Date 2020-03-07
///
class FlutterPainter extends CustomPainter {
  /// 帧集合
  final List<Frame> frames;
  FlutterPainter({this.frames});

  /// 初始化画笔
  var lineP = Paint()
    ..strokeWidth = 25.0
    ..color = Colors.red;

  @override
  void paint(Canvas canvas, Size size) {

    if (frames.length == 0) return;

    Color _randomColor = RandomColor().randomColor();
    for(int i = 0; i < frames.length; i++ ){
      lineP..color = _randomColor;
      /// 当前frame 点集合
      List<Offset> currentPoints = frames[i].points;
      if (currentPoints == null || currentPoints.length == 0) return;
      for (int j = 0; j < currentPoints.length - 1; j++) {
        /// 当前点&&后一个点
        if (currentPoints[j] != null && currentPoints[j+1] != null){
          /// 通过canvas画线
          canvas.drawLine(currentPoints[j], currentPoints[j+1], lineP);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

///
/// @ClassName Frame
/// @Description 绘制的每帧,可以理解为绘制的每一笔
/// @Author waitwalker
/// @Date 2020-03-07
///
class Frame {
  /// 绘制的点集合
  List<Offset> points;
  Frame(this.points);
}
