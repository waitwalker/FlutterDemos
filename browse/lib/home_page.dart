
import 'package:browse/browse_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_orientation/flutter_screen_orientation.dart';

///
/// @description 首页
/// @author waitwalker
/// @time 2/2/21 3:40 PM
///
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {

  double width = 0.0;
  double height = 0.0;

  @override
  void initState() {

    FlutterScreenOrientation.instance().listenerOrientation((e) {
      if (e == FlutterScreenOrientation.portraitUp) {
        this.setState(() {
          //current = "摄像头在上";
        });
      } else if (e == FlutterScreenOrientation.portraitDown) {
        this.setState(() {
          //current = "摄像头在下";
        });
      } else if (e == FlutterScreenOrientation.landscapeLeft) {
        this.setState(() {
          //current = "摄像头在左";
        });
      } else if (e == FlutterScreenOrientation.landscapeRight) {
        this.setState(() {
          //current = "摄像头在右";
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("四中网校浏览器"),),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              child: Container(width: 150, height: 150, child: Image.asset("images/ad_logo.png",), color: Colors.lime,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return BrowsePage(initialUrl: "https://www.etiantian.com", title: "网校",);
                }));
              },
            ),
            Padding(padding: EdgeInsets.only(left: 80)),
            InkWell(
              child: Container(width: 150, height: 150, child: Image.asset("images/ad_logo.png",), color: Colors.lime,),
              onTap: (){

              },
            ),
            Padding(padding: EdgeInsets.only(left: 80)),
            InkWell(
              child: Container(width: 150, height: 150, child: Image.asset("images/ad_logo.png",), color: Colors.lime,),
              onTap: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}