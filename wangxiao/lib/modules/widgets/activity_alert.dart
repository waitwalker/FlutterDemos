import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

/// 活动课弹框
/// author lca
class ActivityCourseAlert extends StatefulWidget {
  final void Function() tapCallBack;

  ActivityCourseAlert({this.tapCallBack});

  @override
  State<StatefulWidget> createState() {
    return _ActivityState();
  }
}

class _ActivityState extends State<ActivityCourseAlert> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InkWell(
          child: Center(
            child: Container(
              height: 136,
              width: MediaQuery.of(context).size.width - 80,
              decoration: _boxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 11, top: 11),
                        child: GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Color(MyColors.black),
                          ),
                          onTap: widget.tapCallBack,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 19),
                    child: Text(
                      "课程咨询请拨打客服热线",
                      style: TextStyle(
                          fontSize: 16, color: MyColors.normalTextColor),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "400-661-6666",
                      style: TextStyle(
                          fontSize: 16, color: MyColors.normalTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          }),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Color(MyColors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.26),
            offset: Offset(0, 1),
            blurRadius: 11.0,
            spreadRadius: 2.0)
      ],
    );
  }
}
