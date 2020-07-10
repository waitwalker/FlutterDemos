import 'dart:io';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/self_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/my_course/wisdom_study/exam_mode_prompt_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/exercise_record_page.dart';
import 'package:online_school/modules/widgets/microcourse_webview.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name TestPaperPage
/// @description 试卷页面
/// @author liuca
/// @date 2020-01-10
///
class TestPaperPage extends StatefulWidget {
  ResourceIdListEntity data;
  var courseCardCourseId;

  TestPaperPage(this.data, this.courseCardCourseId);

  @override
  _TestPaperPageState createState() => _TestPaperPageState();
}

class _TestPaperPageState extends State<TestPaperPage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  buildContent() {
    double iconWH = 40.0;
    if (SingletonManager.sharedInstance.screenWidth > 500.0) {
      iconWH = 60.0;
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          child: InkWell(
            child: Text('查看练习记录', style: textStyleHintPrimary),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ExerciseRecordPage(widget.data.resId,
                    type: 2, srcAbPaperId: widget.data.srcABPaperQuesIds);
              }));
            },
          ),
          top: 15,
          right: 15,
        ),

        Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Center(
              child: Image.asset('static/images/exam_top.png',
                  width: 170, height: 160),),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              child: Wrap(
                children: <Widget>[
                  Text('为了检测你对知识的掌握程度,请认真完成', style: TextStyle(color: Color(0xff888888),fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 12)),
                ],
              ),
            ),
//            Padding(padding: EdgeInsets.only(top: 13)),
//            Padding(padding: EdgeInsets.only(left: 15,right: 15),
//              child: Container(
//                height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 200 : 145,
//                width: MediaQuery.of(context).size.width - 30,
//                decoration: BoxDecoration(
//                    borderRadius: BorderRadius.circular(1),
//                    color: Color(0xffF5F7FF)
//                ),
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Container(
//                      alignment: Alignment.centerLeft,
//                      child: Padding(padding: EdgeInsets.only(left: 15,top: 15),
//                        child: Text("考试模式",style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 15, color: Color(0xff333333),fontWeight: FontWeight.w500),
//                        ),
//                      ),
//                    ),
//                    Padding(padding: EdgeInsets.only(left: 34,right: 34,top: 11,),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Image.asset('static/images/exam_icon_1.png', width: iconWH, height: iconWH),
//                          Image.asset('static/images/exam_icon_2.png', width: iconWH, height: iconWH),
//                          Image.asset('static/images/exam_icon_3.png', width: iconWH, height: iconWH),
//                        ],
//                      ),
//                    ),
//
//                    Padding(padding: EdgeInsets.only(left: 15,right: 15,top: 13,),
//                      child: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Text("全屏计时器模式，适合打印做题时候\n使用，结束全屏可以查看答案。",
//                            maxLines: 2,
//                            style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 11, color: Color(0xff333333),fontWeight: FontWeight.w500),
//                          ),
//                          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width > 360 ? 24 : 10),
//                            child: Container(
//                              height: 32,
//                              child: RaisedButton(
//                                shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
//                                disabledColor: Color(MyColors.ccc),
//                                disabledElevation: 0,
//                                child: Text(
//                                  '马上考试',
//                                  style: TextStyle(
//                                    fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 13,
//                                    color: Colors.white,
//                                    fontWeight: FontWeight.normal,
//                                  ),
//                                ),
//                                color: Color(0xff6B8DFF),
//                                onPressed: () {
//                                  Navigator.push(context, MaterialPageRoute(builder: (context){
//                                    return ExamModePromptPage(widget.data,widget.courseCardCourseId,widget.data.resName);
//                                  }));
//                                },
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),

            Padding(padding: EdgeInsets.only(top: SingletonManager.sharedInstance.screenWidth > 500.0 ? 20 : 10)),
            Padding(padding: EdgeInsets.only(left: 15,right: 15),
              child: Container(
                height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 200 : 145,
                width: MediaQuery.of(context).size.width - 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Color(0xffF5F7FF)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(padding: EdgeInsets.only(left: 15,top: 15),
                        child: Text("练习模式", style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 15, color: Color(0xff333333),fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 34,right: 34,top: 11,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('static/images/practice_icon_1.png', width: iconWH, height: iconWH),
                          Image.asset('static/images/practice_icon_2.png', width: iconWH, height: iconWH),
                          Image.asset('static/images/clear_placeholder.png', width: iconWH, height: iconWH),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.only(left: 15,right: 15,top: 13,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("直接开始答题，适合APP或者电脑上\n使用。",
                            maxLines: 2,
                            style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 11, color: Color(0xff333333),fontWeight: FontWeight.w500),
                          ),
                          Padding(padding: EdgeInsets.only(left: MediaQuery.of(context).size.width > 360 ? 24 : 10),
                            child: Container(
                              height: 32,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                                disabledColor: Color(MyColors.ccc),
                                disabledElevation: 0,
                                child: Text(
                                  '马上练习',
                                  style: TextStyle(
                                    fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                color: Color(0xff6B8DFF),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                    var token = NetworkManager.getAuthorization();
                                    var abpid = widget.data.resId;
                                    var abpname = Uri.encodeComponent(widget.data.resName);
                                    var abpqids = widget.data.srcABPaperQuesIds;
                                    var url =
                                        '${APIConst.practiceHost}/ab.html?token=$token&abpid=$abpid&abpname=$abpname&abpqids=$abpqids&courseid=${widget.courseCardCourseId}';
                                    return MicrocourseWebPage(
                                      initialUrl: url,
                                      resourceId: widget.data.resId,
                                      resourceName: widget.data.resName,
                                      isAb: true,
                                      srcABPaperQuesIds: widget.data.srcABPaperQuesIds,
                                    );
                                  }));
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text(widget.data.resName),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
        ),
        body: buildContent());
  }
}
