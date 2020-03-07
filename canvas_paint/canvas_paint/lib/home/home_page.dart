import 'package:canvas_paint/canvas/FlutterPainter.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

///
/// @ClassName HomePage
/// @Description
/// @Author waitwalker
/// @Date 2020-03-07
///
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  List<Frame> frames = [Frame([],Colors.red)];
  int currentFrame = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: FlutterPainter(
            frames:frames
        ),
        child: GestureDetector(
          onPanStart: (details){
            /// 开始绘制 可以初始化一些配置
            Color _randomColor = RandomColor().randomColor();
            frames[currentFrame].color = _randomColor;
          },
          onPanUpdate: (details){
            /// 拖动更新
            RenderBox renderBox = context.findRenderObject();
            Offset currentPoint = renderBox.globalToLocal(details.globalPosition);
            setState(() {
              frames[currentFrame].points.add(currentPoint);
            });
          },
          onPanEnd: (details){
            Color _randomColor = RandomColor().randomColor();
            frames.add(Frame([],_randomColor));
            currentFrame++;
          },
        ),
      ),
    );
  }
}