import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/my_course/wisdom_study/exercise_record_page.dart';
import 'package:online_school/modules/widgets/microcourse_webview.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name ExercisePage
/// @description 练习页面
/// @author liuca
/// @date 2020-01-11
///
class ExercisePage extends StatefulWidget {
  MicroCourseResourceDataEntity data;
  var courseCardCourseId;

  bool fromCollegeEntrance;
  // 1, 微视频，2,AB测试
  int type;
  ExercisePage(this.data, this.courseCardCourseId, {this.type = 1,this.fromCollegeEntrance = false});

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  buildContent() {
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          child: InkWell(
            child: Text('查看练习记录', style: textStyleHintPrimary),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ExerciseRecordPage(widget.data.resouceId,
                    type: widget.type);
              }));
            },
          ),
          top: 15,
          right: 15,
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset('static/images/img_studying.png',
                    width: 170, height: 170),
              ),
              Padding(padding: EdgeInsets.only(top: 24)),
              Container(
                width: 210,
                child: Wrap(
                  children: <Widget>[
                    Text('为了检测你对知识的掌握程度， 请认真完成', style: textStyleNormal666)
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 150)),
            ]),
        Positioned(
          bottom: 10,
          child: Container(
            width: 285,
            child: RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              disabledColor: Color(MyColors.ccc),
              disabledElevation: 0,
              padding: EdgeInsets.only(top: 12, bottom: 12),
              child: Text(
                '马上练习',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                ),
              ),
              color: Color(MyColors.primaryValue),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  var token = NetworkManager.getAuthorization();
                  var resourceId = widget.data.resouceId;
                  var courseid;
                  if (widget.fromCollegeEntrance == true) {
                    courseid = 0;
                  } else {
                    courseid = widget.courseCardCourseId;
                  }
                  var url ='${APIConst.practiceHost}/practice.html?token=$token&resourceid=$resourceId&courseid=$courseid';
                  return MicrocourseWebPage(
                    initialUrl: url,
                    resourceId: widget.data.resouceId,
                    resourceName: widget.data.resourceName,
                  );
                }));
              },
            ),
          ),
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(height: 10, color: Color(MyColors.background)),
        buildContent()
      ],
    );
  }
}
