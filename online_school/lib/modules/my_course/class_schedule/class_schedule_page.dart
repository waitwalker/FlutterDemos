//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/cc_login_model.dart';
import 'package:online_school/model/live_detail_model.dart';
import 'package:online_school/modules/my_course/live/live_status_button.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/modules/widgets/common_webview_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

///
/// @name ClassSchedulePage
/// @description 课程表
/// @author liuca
/// @date 2020-01-10
///
class ClassSchedulePage extends StatefulWidget {
  var subjectId;
  var courseId;

  ClassSchedulePage({Key key, this.title, this.subjectId, this.courseId})
      : super(key: key);

  final String title;

  @override
  _ClassSchedulePageState createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage>
    with TickerProviderStateMixin {
  Map<DateTime, List> get _events {
    Map<DateTime, List<int>> a = Map<DateTime, List<int>>();
    var b = [1];
    detailData?.liveCourseResultDTOList?.forEach((i) {
      a.addAll({DateFormat('yyyy-MM-dd').parse(i.startTime): b});
    });
    return a;
  }

  List get _selectedEvents => detailData?.liveCourseResultDTOList
      ?.where(startTimeIsSelectDay)
      ?.toList();
  AnimationController _animationController;
  CalendarController _calendarController;
  AsyncMemoizer _memoizer;
  DataEntity detailData;
  DateTime _selectedDay;
  DateTime _selectedMonthFirstDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedMonthFirstDay = _selectedDay;
    _memoizer = AsyncMemoizer();

//    _selectedEvents = _events[_selectedDay] ?? [];

    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
//      _selectedEvents = events;
      _selectedDay = day;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
    setState(() {
      _selectedMonthFirstDay = first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      body: FutureBuilder(builder: _futureBuilder, future: _fetchData()),
    );
  }

  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        var liveDetailModel = snapshot.data.model as LiveDetailModel;
        detailData = liveDetailModel.data;
        return buildContent();
        break;
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return Text('unknow error');
    }
  }

  _fetchData() {
    var now = DateTime.now();
    return _memoizer.runOnce(() => CourseDaoManager.liveSchedule(
        DateFormat('yyyy-MM-dd')
            .format(DateTime(now.year - 1, now.month, now.day)),
        DateFormat('yyyy-MM-dd')
            .format(DateTime(now.year + 1, now.month, now.day))));
  }

  Widget buildContent() {
    return CustomScrollView(
      slivers: <Widget>[
        // _calendar(calendar),
        SliverAppBar(
          actions: <Widget>[
            // _buildAction(),
          ],
          title: Text('课程表'),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          expandedHeight: SingletonManager.sharedInstance.isPadDevice ? 800 : 473,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 90),
              child: Container(
                decoration: _boxDecoration(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('${_selectedMonthFirstDay.month}月', style: TextStyle(fontSize: 24, color: Color(0xff262525)),),
                          Text("${_selectedMonthFirstDay.year}年", style: TextStyle(fontSize: 17, color: Color(0xff262525)),),
                        ],
                      ),
                    ),
                    _buildTableCalendarWithBuilders(),
                  ],
                ),
              ),
            ),
          ),
          floating: false,
          snap: false,
          pinned: false,
          elevation: 1,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(_cardItemBuilder, childCount: _selectedEvents?.length ?? 0,),
        ),
      ],
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      initialSelectedDay: _selectedDay,
      headerVisible: false,
      locale: 'zh_CN',
      calendarController: _calendarController,
      events: _events,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekdayStyle: TextStyle().copyWith(
            color: Color(MyColors.title_black),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        weekendStyle: TextStyle().copyWith(
            color: Color(0xFFD5DAEB),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        holidayStyle: TextStyle().copyWith(
            color: Colors.blue[800], fontSize: 16, fontWeight: FontWeight.w500),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(color: Color(0xFF738598)),
        weekendStyle: TextStyle().copyWith(color: Color(0xFF738598)),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(2.0),
//              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                shape: BoxShape.rectangle,
                color: Color(0xFF43A4FF),
                boxShadow: [
                  BoxShadow(
                      color: Color(MyColors.shadow),
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                      spreadRadius: 0.0)
                ],
              ),
              child: Text(
                '${date.day}',
                style:
                    TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              shape: BoxShape.rectangle,
              color: Color(0xFFF8B739),
              boxShadow: [
                BoxShadow(
                    color: Color(MyColors.shadow),
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                    spreadRadius: 0.0)
              ],
            ),
            width: 36,
            height: 36,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0, color: Colors.white),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                bottom: 6,
                child: _buildEventsMarker(date, events),
              ),
            );
          }
          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        shape: BoxShape.rectangle,
        color:
            _calendarController.isSelected(date) ? Colors.white : Colors.yellow,
      ),
      width: 10.0,
      height: 3.0,
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  /// 列表item 布局
  Widget _cardItemBuilder(BuildContext context, int index) {
    LiveCourseResultDTOListEntity course = _selectedEvents?.elementAt(index);
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: GestureDetector(
        child: Container(
          height: 90,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(MyColors.white),
            gradient: LinearGradient(
              colors: [
                Color(MyColors.courseScheduleCardMain),
                Color(MyColors.courseScheduleCardLight)
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)), //设置圆角
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                  offset: Offset(0, 2),
                  blurRadius: 10.0,
                  spreadRadius: 2.0)
            ],
          ),
          child: Row(
            children: <Widget>[
              /// 开始结束时间
              Padding(
                padding: EdgeInsets.only(left: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${course.startTime.split(' ').last.substring(0, 5)}',
                      style:
                          TextStyle(fontSize: 15, color: Color(MyColors.white)),
                    ),
                    Text(
                      '${course.endTime.split(' ').last.substring(0, 5)}',
                      style:
                          TextStyle(fontSize: 15, color: Color(MyColors.white)),
                    ),
                  ],
                ),
              ),

              /// 中间竖线
              Padding(
                padding: EdgeInsets.only(
                  left: 27,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 255, 255, 0.2951),
                    borderRadius: BorderRadius.all(
                      Radius.circular(2),
                    ),
                  ),
                  height: 44,
                  width: 2,
                ),
              ),

              /// 课程名称
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 24, right: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(course.courseName ?? '--',
                        style: TextStyle(
                            fontSize: 12, color: Color(MyColors.white))),
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Text(
                      course.onlineCourseTitle,
                      style:
                          TextStyle(fontSize: 16, color: Color(MyColors.white)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
        onTap: () async {
          await onPressLiveBtn(course, context);
        },
      ),
    );
  }

  Future onPressLiveBtn(
      LiveCourseResultDTOListEntity course, BuildContext context) async {
    if (course.liveState == LiveStatus.not_started.index) {
      Fluttertoast.showToast(msg: '暂未开始，直播开启前30分钟才能进入');
      return;
    }
    var json = SharedPrefsUtils.getString(Config.LOGIN_JSON, '{}');
    var ccLoginModel = CcLoginModel.fromJson(jsonDecode(json));

    var liveUrl =
        '${APIConst.liveHost}?utoken=${ccLoginModel.access_token}&rcourseid=${widget.courseId}&ocourseId=${course.onlineCourseId}&roomid=${course.roomId}';
    var backUrl =
        '${APIConst.backHost}?token=${ccLoginModel.access_token}&rcourseid=${widget.courseId}&ocourseId=${course.onlineCourseId}&roomid=${course.roomId}';

    var url =
        course.liveState == LiveStatus.live_over.index ? backUrl : liveUrl;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => WebviewPage(
              url,
              title: course.liveState == LiveStatus.live_over.index
                  ? '直播回放'
                  : '直播',
            )));
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Color(MyColors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(0, 2),
            blurRadius: 10.0,
            spreadRadius: 2.0)
      ],
    );
  }

  bool startTimeIsSelectDay(LiveCourseResultDTOListEntity i) {
    var startTime = DateFormat('yyyy-MM-dd').parse(i.startTime);
    return _selectedDay.day == startTime.day &&
        _selectedDay.month == startTime.month &&
        _selectedDay.year == startTime.year;
  }
}
