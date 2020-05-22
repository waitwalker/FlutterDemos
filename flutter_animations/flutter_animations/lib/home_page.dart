import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin{
  // animationController value 返回的是0-1的值 
  AnimationController animationController;
  
  Animation animation;
  

  @override
  void initState() {
    // 控制器 控制动画的时间 动画的启动 停止等;controller的value在动画时间内返回0-1
    // controller 的 value = 1 / 120000
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
    // 插值器 关联一个animationController,主要返回当前的需要的value

    final curve = CurvedAnimation(parent: animationController, curve: Curves.bounceIn);

    // Tween
    animation = Tween(begin: 50.0, end: 100.0).animate(animationController);



    // 监听动画状态变化
    animationController.addListener(() {

      print("animation controller value:${animationController.value}");
      print("animation value:${animation.value}");
      // 动画更新时调用
      setState(() {

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("首页"),),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(left: 200),
                child: RaisedButton(child: Container(
                  color: Colors.deepOrange,
                  height: 30,
                  width: 60,
                ),onPressed: (){
                  animationController.forward();
                }),
              ),

            ],
          ),

          Positioned(
            left: animation.value,
            top: 5 * animation.value,
            child: Container(width: 50, height: 50, color: Colors.deepOrange,),),
        ],
      ),
    );
  }







  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}