import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

///
/// @name
/// @description
/// @author liuca
/// @date 2020-01-02
///
class SelectQuestionWidget extends StatelessWidget {
  final void Function() tapCallBack;

  SelectQuestionWidget({this.tapCallBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("static/images/select_question_beyond.png"),
              ),
              Container(
                color: Colors.white,
                height: 154,
                width: 305,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 26,),
                      child: Text("每次生成试卷，最多支持20题\n先生成部分，再来一次吧～",style: TextStyle(fontSize: 15,color: Color(0xff666666)),textAlign: TextAlign.center,),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 26),
                      child: GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          height: 39,
                          width: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(colors: [Color(0xff69A8FF),Color(0xff6790FF)])
                          ),
                          child: Text("好的，知道了",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,),
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
