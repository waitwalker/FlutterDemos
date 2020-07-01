import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// @name LoadingView
/// @description 加载圈组件
/// @author liuca
/// @date 2020-01-10
///
class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //动画从 controller.forward() 正向执行 结束时会回调此方法
        print("status is completed");
      } else if (status == AnimationStatus.dismissed) {
        //动画从 controller.reverse() 反向执行 结束时会回调此方法
        print("status is dismissed");
      } else if (status == AnimationStatus.forward) {
        print("status is forward");
        //执行 controller.forward() 会回调此状态
      } else if (status == AnimationStatus.reverse) {
        //执行 controller.reverse() 会回调此状态
        print("status is reverse");
      }
    });
    controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'static/images/robot.png',
              width: 200,
              height: 200,
            ),
            Positioned.directional(
                bottom: 35,
                textDirection: TextDirection.ltr,
                child: RotationTransition(
                  child: Image.asset(
                    'static/images/circle.png',
                    width: 40,
                    height: 40,
                  ),
                  turns: controller,
                )),
          ],
        ),
      ),
    );
  }
}
