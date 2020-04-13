import 'package:flutter/material.dart';

class ScaleAnimationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScaleAnimationState();
  }
}

class _ScaleAnimationState extends State<ScaleAnimationPage> with TickerProviderStateMixin{

  var w = 100.0;
  var h = 100.0;

  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    // 创建 AnimationController,用于控制动画
    animationController = AnimationController(vsync: this,duration: Duration(milliseconds: 1500));

    // 创建一个插值器,关联AnimationController,返回一个新的Animation对象
    animation = Tween<double>(begin: 100.0, end: 200.0).animate(animationController);

    // 监听动画值得变化
    animationController.addListener(() {
      // 动画更新时会调用
      //

      setState(() {

      });
    });

    // 开始执行动画
    animationController.forward();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scale Animation"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SizedBox(
          width: animation.value,
          height: animation.value,
          child: Container(
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}