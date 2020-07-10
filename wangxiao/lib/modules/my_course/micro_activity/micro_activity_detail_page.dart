import 'dart:io';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/model/new/college_entrance_model.dart';
import 'package:online_school/modules/my_course/wisdom_study/micro_course_page.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

///
/// @name MicroActivityDetailPage
/// @description 微课类型活动课详情页
/// @author liuca
/// @date 2020-03-16
///
class MicroActivityDetailPage extends StatefulWidget {

  final String title;
  List<CourseList> courses;
  bool showAll;

  String courseContent;
  String banner;
  int index;

  String rcourseId;

  MicroActivityDetailPage(
      {Key key,
        this.courses,
        this.showAll,
        this.courseContent,
        this.banner,
        this.index,
        this.rcourseId,
        this.title = "活动课"
      })
      : super(key: key);

  _MicroActivityDetailPageState createState() => _MicroActivityDetailPageState();
}

class _MicroActivityDetailPageState extends State<MicroActivityDetailPage> {
  int max_line = 4;

  @override
  Widget build(BuildContext context) {
    return buildContent();
  }

  buildContent() {
    if (widget.courses == null || widget.courses.length == 0) {
      return EmptyPlaceholderPage(assetsPath: 'static/images/empty.png', message: '没有数据');
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title + '详情'),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: Platform.isIOS ? true : false,
        ),
        body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(children: <Widget>[
              Hero(
                  tag: 'hero_${widget.index}',
                  child: Container(
                    height: ScreenUtil.getInstance().setHeight(149),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        image: DecorationImage(
                            image: widget.banner != null
                                ? NetworkImage(widget.banner)
                                : AssetImage(
                                'static/images/img_activity_banner01.png'),
                            fit: BoxFit.fill)),
                  )),
              const SizedBox(height: 27),
              Image.asset(
                  'static/images/img_activity_detail_label_introduction.png',
                  width: 248,
                  height: 26),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Color(MyColors.shadow),
                            offset: Offset(0, 2),
                            blurRadius: 10.0,
                            spreadRadius: 2.0)
                      ],
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                              border: Border.all(
                                  width: 2,
                                  color: Color(MyColors.courseScheduleCardLight)),
                            ),
                            child: Text(widget.courseContent ?? '',
                                style: TextStyle(
                                    color:
                                    Color(MyColors.courseScheduleCardLight),
                                    fontSize: 12),
                                maxLines: max_line),
                          ),
                          const SizedBox(height: 4),
                          if (max_line == 4)
                            InkWell(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Text('查看更多')),
                                onTap: () {
                                  max_line = 1000;
                                  setState(() {});
                                })
                        ])),
              ),
              const SizedBox(height: 30),
              Image.asset('static/images/img_activity_detail_label_list.png',
                  width: 248, height: 26),
              _buildList(),
            ])),
      );
    }
  }

  _buildList() {
    var courses = widget.courses;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                    color: Color(MyColors.shadow),
                    offset: Offset(0, 2),
                    blurRadius: 10.0,
                    spreadRadius: 2.0)
              ],
            ),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 16),
              shrinkWrap: true,
              itemCount: courses?.length ?? 0,
              itemBuilder: _itemBuilder,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 9,
                  child: CustomPaint(
                      painter: DashPathPainter(
                          path: Path()
                            ..moveTo(0.0, 0.0)
                            ..lineTo(
                                MediaQuery.of(context).size.width - 64, 0.0),
                          painter: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1.0
                            ..color = Color(MyColors.courseScheduleCardLight))),
                );
              },
            )));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return _buildCurrentItem(index);
  }

  _buildCurrentItem(int index) {
    var courses = widget.courses;
    var course = courses[index];
    var show = widget.showAll;
    int hasStudy = course.hasStudy;
    if (show == true) {
      return InkWell(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 6,bottom: 6),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.check_circle,color: hasStudy == 1 ? Color(0xFFF87F39) : Colors.grey,size: 20,),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          width: MediaQuery.of(context).size.width - 16 * 2 - 20 - 20 - 70,
                          child: Text(
                            courses[index].onlineCourseTitle,
                            style: TextStyle(color: Color(0xFFF87F39), fontSize: 16,),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Icon(Icons.play_circle_filled,size: 20,color: Color(0xffF87F39),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          ErrorCode.eventBus.fire(CollegeEntranceEvent(code: 10001,message: "已学"));
          _onTapItem(course,index: index,courses: courses);
        },
      );
    } else {
      int isFree = course.isFree;
      return InkWell(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 6,bottom: 6),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.check_circle,color: hasStudy == 1 ? Color(0xFFF87F39) : Colors.grey,size: 20,),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        Container(
                          width: MediaQuery.of(context).size.width - 16 * 2 - 20 - 20 - 70,
                          child: Text(
                            courses[index].onlineCourseTitle,
                            style: TextStyle(color: Color(0xFFF87F39), fontSize: 16,),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(isFree == 1 ? Icons.play_circle_filled : Icons.lock,size: 20,color: Color(0xc8F87F39),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          if (isFree == 1) {
            ErrorCode.eventBus.fire(CollegeEntranceEvent(code: 10001,message: "已学"));
            _onTapItem(course,index: index, courses: courses);
          } else {
            _onTapItemLocked();
          }
        },
      );
    }
  }

  _onTapItemLocked() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ActivityCourseAlert(
            tapCallBack: () {
              Navigator.of(context).pop();
            },
          );
        });
  }

  void _onTapItem(CourseList course,{List<CourseList> courses,int index}) async {
    /// 微课
    var microCourseResourseInfo = await CourseDaoManager.getMicroCourseResourseInfo(course.resourceId);

    /// 记录已学
    AnalysisDao.log(0, 0, 2, course.resourceId);
    CourseList currentCourese = courses[index];
    if (currentCourese.hasStudy == 0) {
      currentCourese.hasStudy = 1;
      setState(() {

      });
    }
    if (microCourseResourseInfo.result) {
      MicroCourseResourceModel model = microCourseResourseInfo.model as MicroCourseResourceModel;
      _toMicroCourse(model.data, course.onlineCourseId, course.onlineCourseTitle);
    }
  }

  /// 跳转到微课详情
  void _toMicroCourse(
      MicroCourseResourceDataEntity data, dynamic courseId, String nodeName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MicroCoursePage(data, courseId, from: nodeName,fromCollegeEntrance: true,);
    }));
  }
}

class DashPathPainter extends CustomPainter {
  Path path;

  Paint painter = Paint()
    ..color = Colors.black
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  DashPathPainter({this.path, this.painter});

  @override
  bool shouldRepaint(DashPathPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
        dashPath(
          path,
          dashArray: CircularIntervalList<double>(
            <double>[5.0, 2.5],
          ),
        ),
        painter);
  }
}

final Paint black = Paint()
  ..color = Colors.black
  ..strokeWidth = 1.0
  ..style = PaintingStyle.stroke;
