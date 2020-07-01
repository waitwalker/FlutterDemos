import 'dart:io';
import 'package:online_school/common/dao/original_dao/video_dao.dart';
import 'package:online_school/model/activity_course_model.dart';
import 'package:online_school/model/video_url_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/common/tools/eye_protection_timer.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/common/tools/task_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as p;
import 'package:path_drawing/path_drawing.dart';
import '../live/video_play_page.dart';
import '../../widgets/common_webview_page.dart';


///
/// @name ActivityCourseDetailPage
/// @description 活动课详情页
/// @author liuca
/// @date 2020-01-10
///
class ActivityCourseDetailPage extends StatefulWidget {

  List<CourseListEntity> courses;
  bool showAll;

  String courseContent;
  String banner;
  int index;

  String rcourseId;

  ActivityCourseDetailPage(
      {Key key,
      this.courses,
      this.showAll,
      this.courseContent,
      this.banner,
      this.index,
      this.rcourseId})
      : super(key: key);

  _ActivityCourseDetailPageState createState() => _ActivityCourseDetailPageState();
}

class _ActivityCourseDetailPageState extends State<ActivityCourseDetailPage> {
  int max_line = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('活动课详情'),
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
    var courses = widget.courses;
    var course = courses[index];
    var show = widget.showAll;
    return InkWell(
      child: Container(
        height: 60,
        color: Colors.white,
        padding: EdgeInsets.only(left: 16, right: 16, top: 6),
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Row(children: <Widget>[
                Image.asset(
                    show
                        ? 'static/images/rotated_rect2.png'
                        : 'static/images/rotated_rect1.png',
                    width: 15,
                    height: 15),
                const SizedBox(width: 8),
                Text(courses[index].startTime, style: textStyletitle),
              ]),
            ),
            // Positioned(
            //   right: 0,
            //   child: Image.asset('static/images/lock.png', width: 15, height: 15),
            // ),
            Positioned(
                right: 0,
                child: Row(children: [
                  if (course.liveState < 1)
                    Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text('未开始', style: textStyle14999)),
                  SvgPicture.asset(
                      show ? 'static/svgs/play.svg' : 'static/svgs/lock.svg',
                      semanticsLabel: 'lock',
                      width: 20,
                      height: 21),
                ])),
            Positioned(
              top: 24,
              left: 23,
              child: Text(courses[index].onlineCourseTitle,
                  style: TextStyle(color: Color(0xFFF87F39), fontSize: 16)),
            ),
          ],
        ),
      ),
      onTap: show ? () => _onTapItem(course) : _onTapItemLocked,
    );
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

  void _onTapItem(CourseListEntity course) async {
    if (course.liveState < 1) {
      Fluttertoast.showToast(msg: '课程未开始');
      return;
    } else if (course.liveState == 1) {
      var token = NetworkManager.getAuthorization();
      var url =
          '${APIConst.liveHost}?utoken=$token&rcourseid=${widget.rcourseId}&ocourseId=${course.onlineCourseId}&roomid=${course.roomId}';
      // 需求：护眼模式，直播不计时
      EyeProtectionTimer.pauseTimer();
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) => WebviewPage(
                    url,
                    title: '直播',
                  )))
          .then((_) => EyeProtectionTimer.startEyeProtectionTimer(context));
      return;
    }
    // 回放
    var videoUrl = await VideoDao.getVideoUrl(course.onlineCourseId.toString());
    var model = videoUrl.model as VideoUrlModel;
    if (model.code != 1) {
      Fluttertoast.showToast(msg: model.msg);
      return;
    }

    // local first
    var mp4Url = model.data.videoUrl;
    var videoPath = await getLocalVideoByUrl(mp4Url);
    if (videoPath != null && File(videoPath).existsSync()) {
      Fluttertoast.showToast(
          msg: '视频已下载，播放不消耗流量', gravity: ToastGravity.CENTER);
    } else {
      videoPath = null;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => VideoPlayPage(
            videoPath ?? model.data.playVideoUrl ?? mp4Url,
            resourceId: model.data.resourceId,
            courseId: model.data.onlineCourseId,
            title: model.data.onlineCourseName)));
    return;
  }

  getLocalVideoByUrl(String url) async {
    var resId = getMp4UrlId(Uri.parse(url));
    List<DownloadTask> tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE url LIKE '%$resId%.mp4'");
    if (tasks != null && tasks.length > 0) {
      var task = tasks.single;
      var status = task.status;
      if (status == DownloadTaskStatus.complete) {
        var videoPath = p.join(task.savedDir, task.filename);
        return videoPath;
      }
    }
    return null;
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
