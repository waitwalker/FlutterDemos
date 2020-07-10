import 'package:flutter/material.dart';
import 'package:online_school/modules/common_app/tool/timeline_page.dart';

class CommonTimeAxisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonTimeAxisState();
  }
}

class _CommonTimeAxisState extends State<CommonTimeAxisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间轴"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Container(
              height: 44,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(index == 0 ? "Paint Timeline" : "ListView Timeline"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.arrow_forward_ios, size: 16,),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            onTap: (){
              if (index == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return TimelinePaintPage();
                }));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return TimelineListPage();
                }));
              }
            },
          );
        },
        itemCount: 2,
      ),
    );
  }
}

///
/// @name TimelinePaintPage
/// @description 时间轴 绘制形式实现
/// @author liuca
/// @date 2020/6/15
///
class TimelinePaintPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimelinePaintState();
  }
}

class _TimelinePaintState extends State<TimelinePaintPage> {
  Color color = Colors.cyan;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline Paint"),
      ),
      body: Timeline(
        children: <Widget>[
          Container(height: 100, color: color),
          Container(height: 50, color: color),
          Container(height: 200, color: color),
          Container(height: 100, color: color),
        ],
        indicators: <Widget>[
          Icon(Icons.access_alarm),
          Icon(Icons.backup),
          Icon(Icons.accessibility_new),
          Icon(Icons.access_alarm),
        ],
      ),
    );
  }
}

///
/// @name TimelineListPage
/// @description 时间轴 通过列表形式实现
/// @author liuca
/// @date 2020/6/15
///
class TimelineListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TimelineListState();
  }
}

class _TimelineListState extends State<TimelineListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("时间轴"),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return new Stack(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: new Card(
                  margin: new EdgeInsets.all(20.0),
                  child: new Container(
                    width: double.infinity,
                    height: 200.0,
                    color: Colors.green,
                  ),
                ),
              ),
              new Positioned(
                top: 0.0,
                bottom: 0.0,
                left: 35.0,
                child: new Container(
                  height: double.infinity,
                  width: 1.0,
                  color: Colors.blue,
                ),
              ),
              new Positioned(
                top: 100.0,
                left: 15.0,
                child: new Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: new Container(
                    margin: new EdgeInsets.all(5.0),
                    height: 30.0,
                    width: 30.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red),
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 5,
      ),
    );
  }
}