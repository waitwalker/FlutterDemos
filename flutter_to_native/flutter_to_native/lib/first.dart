import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertonative/second.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            FadeTransition(
              opacity: _animation,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Second()));
                },
                child: Hero(
                  tag: 'test',
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.green,
                    child: Icon(Icons.photo_camera),
                  ),
                ),
              ),
            ),
            Tooltip(
              message: '你好',
              child: Container(
                width: 50,
                height: 50,
                color: Colors.red,
              ),
            ),
            Container(
              width: 100,
              height: 150,
              color: Colors.green,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Container(
                  width: 80,
                  height: 200,
                  color: Colors.pink,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _controller.forward();
          _gotoNative();
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.all(Radius.circular(50))),
        ),
      ),
    );
  }

  Future _gotoNative() async {
    const platform = const MethodChannel("flutter_demo");
    try {
      int result = await platform.invokeMethod('gotoNative');
      return result == 1 ? true : false;
    } catch (e) {}
  }
}
