import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info/device_info.dart';
import 'package:online_school/common/common_tool_manager/common_tool_manager.dart';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/common/dao/original_dao/common_api.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/redux/config_reducer.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/model/activity_dialog_model.dart' hide DataEntity;
import 'package:online_school/model/config_model.dart' hide DataEntity;
import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/model/new/activity_entrance_model.dart';
import 'package:online_school/model/new/review_status_model.dart';
import 'package:online_school/model/new_home_course_model.dart';
import 'package:online_school/model/recommend_model.dart';
import 'package:online_school/model/self_study_record.dart';
import 'package:online_school/model/user_info_model.dart' hide DataEntity;
import 'package:online_school/modules/my_course/activity_course/new_semester/new_semester_page.dart';
import 'package:online_school/modules/my_course/activity_course/primary_enter_junior/primary_enter_junior_page.dart';
import 'package:online_school/modules/my_course/assistance_verify/assistance_verify_page.dart';
import 'package:online_school/modules/my_course/junior_activity/junior_grade_page.dart';
import 'package:online_school/modules/my_course/union_activity/union_grade_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/micro_course_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/scroll_to_index/scroll_to_index.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/my_course/activity_course/activity_course.dart';
import 'package:online_school/modules/my_course/ai_test/ai_container_page.dart';
import 'package:online_school/modules/personal/activate_card/activate_card_page.dart';
import 'package:online_school/modules/personal/activate_card/activate_card_state_page.dart';
import 'package:online_school/modules/widgets/pdf_page.dart';
import 'package:online_school/modules/my_course/subject_detail_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/common/tools/date_utils.dart';
import 'package:online_school/common/tools/grade_utils.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
//import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';
import 'package:umeng_plugin/umeng_plugin.dart';
import '../personal/activate_card/activate_card_type_page.dart';
import 'ai_test/ai_test_page.dart';
import '../widgets/common_webview.dart';
import '../widgets/common_webview_page.dart';
import 'micro_activity/micro_activity_page.dart';
import 'wisdom_study/hd_video_page.dart';
import 'live/live_page.dart';
import 'class_schedule/class_schedule_page.dart';
import 'wisdom_study/wisdom_study_container_page.dart';
import 'wisdom_study/wisdom_study_page.dart';
import '../widgets/list_type_loading_placehold_widget.dart';
import 'wisdom_study/video_play_widget.dart';
import 'ai_test/ai_webview_page.dart';

///
/// @name MyCoursePage
/// @description 我的课程页面
/// @author liuca
/// @date 2020-01-10
///
class MyCoursePage extends StatefulWidget {
  MyCoursePage({Key key}) : super(key: key);
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  /// 智领卡只有4个学科：[数学，英语，物理，化学]，id分别对应：[2, 3, 4, 5]
  final List<int> zl_subjects = [2, 3, 4, 5];
  List<DataEntity> courseData;
  bool disconnected = false;

  // 智领卡片数据
  List<DataEntity> get courseDataZL => courseData?.where((i) => zl_subjects.contains(i.subjectId))?.toList();

  // 智学卡片数据
  List<DataEntity> get courseDataZX => courseData?.where((i) => !zl_subjects.contains(i.subjectId))?.toList();
  AsyncMemoizer memoizer = AsyncMemoizer();
  AsyncMemoizer memoizerTuijian = AsyncMemoizer();
  AsyncMemoizer memoizerZixue = AsyncMemoizer();
  AsyncMemoizer memoizerZhibo = AsyncMemoizer();
  Record record;
  bool hideHistory;

  /// 是否是新用户 主要用来判断助学活动是否可进去
  ReviewStatusModel reviewStatusModel;
  bool isNewUser = true;

  ConfigModel config;
  
  @override
  void initState() {
    super.initState();

    // 获取是否新用户状态
    loadReviewStatus();
    hideHistory = false;

    // 获取大师直播权限
    //CommonToolManager.fetchLiveAuthority();

    /// 加载已学习记录
    loadHistory();

    /// 获取激活状态
    _getConfig();

    /// 延迟5s 加载活动课
    if (SingletonManager.sharedInstance.isHaveLoadedAlert == false) {
      Future.delayed(Duration(seconds: 4), () {
        if (SingletonManager.sharedInstance.shouldShowActivityCourse) {
          fetchActivity();
        }
      });
      SingletonManager.sharedInstance.isHaveLoadedAlert = true;
    }

    ErrorCode.eventBus.on<dynamic>().listen((e) {
      if (e is CardActivatedEvent) {
        debugLog('@@@@@@@@@@@===>CODE RECEIVE');
        memoizer = AsyncMemoizer();
        setState(() {});
      }
    });

    // 获取设备信息
    deviceInfo();
  }

  ///
  /// @name deviceInfo
  /// @description 获取iOS平台设备信息
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020/5/28
  ///
  deviceInfo() async {
    if (Platform.isIOS) {
      DeviceInfoPlugin plugin = DeviceInfoPlugin();
      IosDeviceInfo iosDeviceInfo = await plugin.iosInfo;
      SingletonManager.sharedInstance.mobileName = iosDeviceInfo.name;
    }
  }

  ///
  /// @name _getConfig
  /// @description 获取app当前审核状态状态
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020/5/7
  ///
  Future _getConfig() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var versionName = packageInfo.version;
    var response = await CommonServiceDao.configs(ver: versionName);
    if (response.result) {
      config = response.model as ConfigModel;
      _getStore().dispatch(UpdateConfigAction(config));
    }
  }

  ///
  /// @name loadReviewStatus
  /// @description 加载审核状态信息
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-25
  ///
  loadReviewStatus() async {
    ResponseData responseData = await DaoManager.fetchReviewStatusInfo({"":""});
    var model = responseData.model as ReviewStatusModel;
    reviewStatusModel = model;

    if (reviewStatusModel.code == 1 && reviewStatusModel != null) {
      /// 是否是新用户
      if (reviewStatusModel.data.stateId == 1) {
        isNewUser = false;
        SingletonManager.sharedInstance.isNewUser = false;
      }
    }

    SingletonManager.sharedInstance.isNewUser = isNewUser;
    setState(() {

    });

  }

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    /// 获取屏幕宽高
    SingletonManager.sharedInstance.screenWidth = MediaQuery.of(context).size.width;
    SingletonManager.sharedInstance.screenHeight = MediaQuery.of(context).size.height;
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text('我的课程'),
          backgroundColor: Colors.white,
          centerTitle: false,
          actions: <Widget>[
            FlatButton(
              child: Row(
                children: <Widget>[
                  Icon(MyIcons.SCHEDULE),
                  Padding(padding: EdgeInsets.only(left: 8)),
                  Text('课程')
                ],
              ),
              onPressed: () {
                var courses = courseData;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ClassSchedulePage(
                        subjectId: courses?.first?.subjectId,
                        courseId: courses?.first?.subjectId)));
              },
            )
          ],
        ),
        backgroundColor: Color(MyColors.background),
        body: RefreshIndicator(
          child: _buildSingleChildScrollView(),
          onRefresh: _onRefresh,
        ),
        /// 上次作答记录
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButton: (record != null && !hideHistory)
            ? InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Stack(
              children: <Widget>[
                _buildFloatCard(),
                Positioned(
                  right: 0,
                  top: 0,
                  child: InkWell(
                    child: Container(
                      child: Icon(Icons.close, size: 15), width: 30, height: 30,),
                    onTap: () {
                      hideHistory = true;
                      setState(() {});
                    },
                  ),
                )
              ],
            ),
          ),
          onTap: _toHistory,
        )
            : Container(),
      );
    });
  }

  ///
  /// @name _buildSingleChildScrollView
  /// @description 构建scrollview
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  SingleChildScrollView _buildSingleChildScrollView() {

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: disconnected
            ? EmptyPlaceholderPage(onPress: _onRefresh)
            : Column(
                children: <Widget>[

                  /// 构建不同课类型 子Widget
                  buildIndicatorRow('智领课'),
                  const SizedBox(height: 12),
                  buildZLFuture(),
                  const SizedBox(height: 20),

                  buildIndicatorRow('小升初暑期课'),
                  const SizedBox(height: 12),
                  buildPrimaryCourse(),
                  const SizedBox(height: 20),

                  buildIndicatorRow('四中名师新学期直通车'),
                  const SizedBox(height: 12),
                  buildNewSemesterCourse(),
                  const SizedBox(height: 20),

//                  buildIndicatorRow('联通活动课'),
//                  const SizedBox(height: 12),
//                  buildUnionCourse(),
//                  const SizedBox(height: 20),

//                  buildIndicatorRow('中考阅读活动课'),
//                  const SizedBox(height: 12),
//                  buildReadingCourse(),
//                  const SizedBox(height: 20),

//                  buildIndicatorRow('复课衔接强化课'),
//                  const SizedBox(height: 12),
//                  buildJuniorCourse(),
//                  const SizedBox(height: 20),

//                  buildIndicatorRow('高考冲刺课'),
//                  const SizedBox(height: 12),
//                  buildEntranceExaminationCourse(2),
//                  const SizedBox(height: 20),

//                  buildIndicatorRow('助学活动'),
//                  const SizedBox(height: 12),
//                  buildAssistanceCourse(),
//                  const SizedBox(height: 20),

                  buildIndicatorRow('活动课'),
                  const SizedBox(height: 12),
                  buildActivityCourse(),
                  const SizedBox(height: 20),

                  buildIndicatorRow('智学课'),
                  const SizedBox(height: 12),
                  buildZXFuture(),
                  const SizedBox(height: 20),

                  buildIndicatorRow('推荐学习'),
                  const SizedBox(height: 12),
                  buildRecommend(),
                  if (record != null && !hideHistory) SizedBox(height: 80),
                ],
              ),
      ),
    );
  }

  Container _buildFloatCard() {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        image: DecorationImage(
            alignment: Alignment.center,
            fit: BoxFit.fill,
            image: AssetImage('static/images/bg_pop_up_learning_history.png')),
        borderRadius: BorderRadius.all(Radius.circular(4.0)), //设置圆角
        boxShadow: [
          BoxShadow(
              color: Color(MyColors.shadow),
              offset: Offset(0, 2),
              blurRadius: 10.0,
              spreadRadius: 2.0)
        ],
      ),
      // width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 14),
      child: Container(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(width: (SingletonManager.sharedInstance.screenWidth > 500.0) ? 130.0 : 60.0),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('上次学到', style: textStyle12primaryLight),
                        const SizedBox(height: 9),
                        Text('${record.title}', style: textStyletitle, maxLines: 1)
                      ]),
                  flex: 1),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 24,
                  width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 80 : 62,
                  child: Text('继续学习', style: TextStyle(color: Colors.white, fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 14 : 11),),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      shadows: <BoxShadow>[
                        BoxShadow(
                            color: Color(0x46F7B71D),
                            offset: Offset(0, 0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0)
                      ],
                      color: Color(MyColors.btn_solid)),
                ),
                onTap: _toHistory,
              ),
              const SizedBox(width: 26),
            ],
          )),
    );
  }

  void loadHistory() {
    var pstr = SharedPrefsUtils.getString('record', '');
    if (pstr.isEmpty) {
      return;
    }
    record = Record.fromJson(jsonDecode(pstr));
  }

  ///
  /// @name buildZLFuture
  /// @description 智领课列表
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  buildZLFuture() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) =>
          _futureBuilder(context, snapshot, false),
      future: _getData(),
    );
  }

  ///
  /// @name buildZXCourseList
  /// @description 构建智学课
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  buildZXFuture() {
    return FutureBuilder(
      builder: _futureBuilder,
      future: _getData(),
    );
  }

  // 获取学科所有数据
  _getData() {
    return memoizer.runOnce(CourseDaoManager.newCourses);
  }

  Row buildIndicatorRow(String title) {
    return Row(
      children: <Widget>[
        new Indicator(width: 4, height: 14),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 15 , fontWeight: FontWeight.bold, color: Colors.black))
      ],
    );
  }

  ///
  /// @name _futureBuilder
  /// @description 智领课/智学课future builder
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot,
      [bool isZL = true]) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: LoadingListWidget(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return Text('没有数据');
        if (snapshot.data.model == null) {
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png',
              message: '请求超时',
              onPress: _onRefresh);
        }
        var liveDetailModel = snapshot.data.model as NewHomeCourseModel;
        courseData = liveDetailModel.data;
        if (courseData == null) return Text('没有数据');
        courseData = liveDetailModel.data;
        return isZL ? _buildZLList() : _buildZXList();
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  bool isLoading = false;
  Future<void> _onRefresh() async {
    if (isLoading) {
      return;
    }
    ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
      memoizer = AsyncMemoizer();
      memoizerTuijian = AsyncMemoizer();
      disconnected = false;
    });
  }
  
  ///
  /// @name _buildZLList
  /// @description 构建智领列表
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  Widget _buildZLList() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: courseDataZX?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.8),
      itemBuilder: (BuildContext context, int index) =>
          _buildZLZXItem(context, index, courseDataZX),
    );
  }

  ///
  /// @name _buildZXList
  /// @description 构建智学列表
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  Widget _buildZXList() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) =>
          _buildZLZXItem(context, index, courseDataZL),
      itemCount: courseDataZL?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.8),
    );
  }

  ///
  /// @name _buildZLZXItem
  /// @description 构建智领智学当个卡片item
  /// @parameters 
  /// @return 
  /// @author liuca
  /// @date 2020/6/9
  ///
  Widget _buildZLZXItem(
      BuildContext context, int index, List<DataEntity> courseData) {
    var item = courseData.elementAt(index);
    var imgPath;
    var bgColor;
    var noGrade = item.grades == null || item.grades.isEmpty;
    if (item.subjectId == 1) {
      imgPath = 'static/images/image_courses_language.png';
      bgColor = 0xFF65D2FE;
    } else if (item.subjectId == 2) {
      imgPath = 'static/images/image_courses_math.png';
      bgColor = 0xFFFFCE65;
    } else if (item.subjectId == 3) {
      imgPath = 'static/images/image_courses_english.png';
      bgColor = 0xFFFDAD58;
    } else if (item.subjectId == 4) {
      imgPath = 'static/images/image_courses_physics.png';
      bgColor = 0xFFAA91FF;
    } else if (item.subjectId == 5) {
      imgPath = 'static/images/image_courses_chemistry.png';
      bgColor = 0xFF9191FF;
    } else if (item.subjectId == 6) {
      imgPath = 'static/images/image_courses_history.png';
      bgColor = 0xFF8AACFF;
    } else if (item.subjectId == 7) {
      imgPath = 'static/images/image_courses_biology.png';
      bgColor = 0xFF9ADE4D;
    } else if (item.subjectId == 8) {
      imgPath = 'static/images/image_courses_geography.png';
      bgColor = 0xFF5B9EFF;
    } else if (item.subjectId == 9) {
      imgPath = 'static/images/image_courses_politics.png';
      bgColor = 0xFF9191FF;
    }
    var gradeIds;
    var gradeStr;
    if (noGrade) {
      gradeIds = <int>[];
      gradeStr = '';
    } else {
      gradeStr = item.grades.map((g) => gradeSample[g.gradeId]).join(' ');
      gradeIds = item.grades
          .map((g) => g.gradeId as int)
          .toList(); // gradeSample[item.grades?.elementAt(0)?.gradeId] ?? '';
    }
    bool isZL = zl_subjects.contains(item.subjectId);
    Widget card;
    print("屏幕宽度: ${MediaQuery.of(context).size.width}");
    print("屏幕高度: ${MediaQuery.of(context).size.height}");

    double topHeight = 65;
    if (MediaQuery.of(context).size.height < 735.0) {
      topHeight = 58.0;
    } else if (MediaQuery.of(context).size.height > 735.0 && MediaQuery.of(context).size.height < 811.0) {
      topHeight = 73.0;
    } else if (MediaQuery.of(context).size.height > 811.0 && MediaQuery.of(context).size.height < 895.0) {
      topHeight = 65.0;
    } else if (MediaQuery.of(context).size.height > 895.0 &&  MediaQuery.of(context).size.height <= 1023.0) {
      topHeight = 75.0;
    } else if (MediaQuery.of(context).size.height > 1023.0) {
      topHeight = 160;
    }

    var normal = Container(
      child: Container(
          height: 200,
          width: (MediaQuery.of(context).size.width - 16 * 3.0) / 2.0,
          decoration: BoxDecoration(
            color: Color(bgColor),
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: Stack(
            children: <Widget>[
              Positioned.directional(
                  end: ScreenUtil.getInstance().setWidth(12),
                  top: SingletonManager.sharedInstance.screenWidth> 500.0 ? ScreenUtil.getInstance().setWidth(28) : ScreenUtil.getInstance().setWidth(22),
                  textDirection: TextDirection.ltr,
                  child: Container(width: 44, height: 44, child: Image.asset(imgPath, width: 44, height: 44, fit: BoxFit.contain)),),
              Positioned.directional(
                  start: ScreenUtil.getInstance().setWidth(14),
                  top: ScreenUtil.getInstance().setWidth(10),
                  textDirection: TextDirection.ltr,
                  child: Text('${subjectSample[item.subjectId]}', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 22 : 16, color: Colors.white, fontWeight: FontWeight.bold))),
              Padding(padding: EdgeInsets.only(top: topHeight,left: 10),
                child: Container(
                  height: SingletonManager.sharedInstance.screenWidth > 500 ? 25 : 18,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: false,
                    child: Row(children: buildTag(item.grades?.map((g) => gradeSample[g.gradeId])?.toList())),
                  ),
                ),
              ),
            ],
          )),
    );
    if (noGrade) {
      card = Stack(
        children: <Widget>[
          normal,
          Positioned.directional(
              top: 0,
              end: 0,
              textDirection: TextDirection.ltr,
              child: Container(
                  width: 44,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEA615F), Color(0xFFFF9074)],
                    ),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        topRight: Radius.circular(6.0)),
                  ),
                  child:
                      Container(child: Text('体验', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500 ? 18 : 12, color: Colors.white))))),
        ],
      );
    } else {
      card = normal;
    }
    return InkWell(
      child: card,
      onTap: () => _onSubjectTap(gradeIds, item.subjectId),
    );
  }

  List<Widget> buildTag(List<String> grades) {
    nameTag(String name) {
      if (name == null || name.isEmpty) return Container();
      return Container(
          padding: EdgeInsets.only(right: 4),
          child: Container(
              width: SingletonManager.sharedInstance.screenWidth > 500 ? 45 : 32,
              // height: 14,
              alignment: Alignment.center,
              // padding:  EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Color(MyColors.shadow),
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
              ),
              child: Text(name, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500 ? 16 : 12, color: Colors.white, fontWeight: FontWeight.bold))));
    }

    if (grades == null || grades.isEmpty) return [Container()];
    return grades.map((g) => nameTag(g)).toList();
  }

  ///
  /// @name buildUnionCourse
  /// @description 联通活动课
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-05-29
  ///
  buildUnionCourse() {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UnionGradePage()));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/j_home_banner.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildPrimaryCourse
  /// @description 小升初暑期课程
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-06-26
  ///
  buildPrimaryCourse() {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return PrimaryEnterJuniorPage();
          }));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/p_banner_home.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildNewSemesterCourse
  /// @description 四中名师新学期直通车
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-07-01
  ///
  buildNewSemesterCourse() {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return NewSemesterPage();
          }));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/n_semester_home_banner.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildReadingCourse
  /// @description 中考阅读活动课
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-05-04
  ///
  buildReadingCourse() {
    return InkWell(
        onTap: () {
          var token = NetworkManager.getAuthorization();
          String url = Config.DEBUG ? "http://huodongt.etiantian.com/activity01/zhongkaom.html?token=" : "http://huodong.etiantian.com/activity01/zhongkaom.html?token=";
          String fullUrl = "$url$token";
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return CommonWebview(initialUrl: fullUrl, title: "中考阅读活动课",
            );
          }));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/r_home_banner.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildJuniorCourse
  /// @description 复课衔接强化课
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-04-01
  ///
  buildJuniorCourse() {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => JuniorGradePage()));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/j_home_banner.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildEntranceExaminationCourse
  /// @description 冲刺课入口
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-03-16
  ///
  buildEntranceExaminationCourse(int type) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MicroActivityPage(
            type == 1 ? Config.DEBUG ? 10031312455 : 100289535008 : Config.DEBUG ? 10031312455 : 100289535008,
            title: type == 1 ? "中考冲刺课" : "高考冲刺课",
          )));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/c_enntrance_home_banner.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildAssistanceCourse
  /// @description 助学活动课入口
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-24
  ///
  buildAssistanceCourse() {
    return InkWell(
        onTap: () {
          if (isNewUser) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AssistanceVerifyPage()));
          } else {
            Fluttertoast.showToast(msg: "该活动仅限新用户参加，您已经是老用户啦，继续学习吧^_^！");
          }
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(155),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/a_home_gb.png'),
                  fit: BoxFit.fill)),
        ));
  }

  ///
  /// @name buildActivityCourse
  /// @description 活动课入口
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  buildActivityCourse() {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ActivityCourse()));
        },
        child: Container(
          height: ScreenUtil.getInstance().setWidth(75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              image: DecorationImage(
                  image: AssetImage('static/images/image_courses_activity.png'),
                  fit: BoxFit.fill)),
        ));
  }

  void _onSubjectTap(List<int> grade, int subjectId) {
    bool isZL = zl_subjects.contains(subjectId);

    // 智领课3 智学课2
    Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SubjectDetailPage(
          gradeIds: grade,
          subjectId: subjectId,
          hiddenCard: false,
          cardType: isZL ? 3 : 2,
        );
      })).then(_refreshLocalHistory);
  }

  void _toActivate() {
    var userInfo = _getStore().state.userInfo;
    if (userInfo.data.bindingStatus == 1) {
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => userInfo.data.stateType == 0
          ? ActivateCardStatePage()
          : ActivateCardPage())).then((r) {
        if (r ?? false) {
          debugLog('@@@@@@@@@@@--->CODE FIRE');
          ErrorCode.eventBus.fire(CardActivatedEvent());
        }
      });
    } else {
      // bind phone
      Navigator.of(context).pushNamed(RouteConst.bind_phone)
          .then((r) => (r ?? false) ? _toActivatePage(userInfo) : null);
    }
  }

  void _toActivatePage(UserInfoModel userInfo) {
    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => userInfo.data.stateType == 0
        ? ActivateCardStatePage()
        : ActivateCardPage())).then((r) {
      if (r ?? false) {
        debugLog('@@@@@@@@@@@--->CODE FIRE');
        ErrorCode.eventBus.fire(CardActivatedEvent());
      }
    });
  }

  buildRecommend() {
    return FutureBuilder(
      builder: _recommendBuilder,
      future: memoizerTuijian.runOnce(() => CourseDaoManager.recommend()),
    );
  }

  Widget _recommendBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        if (!snapshot.hasData || snapshot.data.model == null)
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png',
              message: '请求超时',
              onPress: _onRefresh);
        var model = snapshot.data.model as RecommendModel;
        var data = model.data;
        if (data == null) return Text('没有数据');
        data = model.data;
        return _buildRecommend(data);
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  _buildRecommend(RecommendData data) {
    var buildTag1 = (int minute, {String preText, String postFix}) {
      return Container(
        height: 40,
        width: 100,
        // color: Colors.red,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Positioned(
              top: 6,
              child: Container(
                width: 100,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(MyColors.tagblue02),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  if (preText != null)
                    Text(preText,
                        style: TextStyle(
                            // textBaseline: TextBaseline.ideographic,
                            fontSize: 10,
                            color: Color(MyColors.tagblue))),
                  Text(minute.toString(),
                      style: TextStyle(
                          // textBaseline: TextBaseline.alphabetic,
                          fontSize: 24,
                          color: Color(MyColors.tagblue),
                          fontWeight: FontWeight.bold)),
                  if (postFix != null)
                    Text(postFix,
                        style: TextStyle(
                            // textBaseline: TextBaseline.alphabetic,
                            fontSize: 10,
                            color: Color(MyColors.tagblue)))
                ]),
          ],
        ),
      );
    };
    var d =
        data.nextLiveTime != null ? DateTime.parse(data.nextLiveTime) : null;
    var t = data.nextLiveTime != null ? DateUtils.formateDateMdhm(d) : null;
    var livePredict = Container(
      width: 116,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(MyColors.primaryValue),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0)),
      ),
      child: Text('预告：$t', style: textStyle10White),
    );

    return Container(
      // height: ScreenUtil.getInstance().setHeight(268),
      padding: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(8.0)), //设置圆角
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Color(0x1e000000),
            blurRadius: 8.0,
            spreadRadius: 3.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Positioned(
              bottom: 0,
              child: Container(
                height: 80,
                child: Image(width: SingletonManager.sharedInstance.screenWidth, fit: BoxFit.fill, image: AssetImage('static/images/bg_courses_recommend.png')),
              )),
          Column(
            children: <Widget>[
              buildRecommendItem(
                  title: data.aiName,
                  subtitle: data.aiTitle,
                  imageUrl: 'static/images/image_courses_recommend_1.png',
                  tag: buildTag1(10, preText: '每天只需', postFix: '分钟'),
                  onPress: () {
                    if ((data.aiActivationStatus ?? 0) == 0) {
                      _toActivate();
                    } else {
                      if (data.aiRecommendId != null) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          var token = NetworkManager.getAuthorization();
                          var versionId = data.versionId;
                          var subjectId = data.aiSubjectId;
                          var nodeId = data.aiRecommendId;
                          var url =
                              '${APIConst.practiceHost}/ai.html?token=$token&versionid=$versionId&currentdirid=$nodeId&subjectid=$subjectId';
                          return AIWebPage(
                            currentDirId: nodeId.toString(),
                            versionId: versionId.toString(),
                            subjectId: subjectId.toString(),
                            initialUrl: url,
                          );
                        }));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => AIContainerPage(
                                innerWidget: AITestPage(
                                    data.subjectId, data.gradeId,
                                    courseId: data.aiCourseId),
                                title: 'AI测试')));
                      }
                    }
                  }),
              Container(
                  child: Divider(height: 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 20)),
              buildRecommendItem(
                  title: data.zxName,
                  subtitle: data.zxTitle,
                  imageUrl: 'static/images/image_courses_recommend_2.png',
                  tag: buildTag1(15, postFix: '分钟搞定难点'),
                  onPress: () async {
                    if ((data.zxActivationStatus ?? 0) == 0) {
                      _toActivate();
                    } else {
                      if (data.zxRecommendId == null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => WisdomStudyContainerPage(
                                innerWidget: WisdomStudyPage(
                                  data.courseCardId,
                                  data.subjectId,
                                  data.gradeId,
                                  scrollController: AutoScrollController(),
                                  memoizer: memoizerZixue,
                                ),
                                title: '智慧学习')));
                      } else {
                        if (data.resType == 3) {
                          // AB卷子，没有
                        } else if (data.resType == 2) {
                          var microCourseResourseInfo = await CourseDaoManager.getMicroCourseResourseInfo(
                                  data.zxRecommendId);
                          if (microCourseResourseInfo.result) {
                            MicroCourseResourceModel model = microCourseResourseInfo.model as MicroCourseResourceModel;
                            _toMicroCourse(model.data, data.courseCardId, data.zxFrom ?? '推荐学习');
                          }
                        } else if (data.resType == 1 || data.resType == 4) {
                          var resourseInfo = await CourseDaoManager.getResourseInfo(
                              data.zxRecommendId);

                          if (resourseInfo.result &&
                              resourseInfo.model != null &&
                              resourseInfo.model.code == 1) {
                            if (data.resType == 1) {
                              // 微视频/高清
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (_) {
                                return HDVideoPage(
                                    source: resourseInfo.model.data.videoUrl,
                                    title: data.resName,
                                    coverUrl: resourseInfo.model.data.imageUrl,
                                    from: data.zxFrom ?? '推荐学习',
                                    videoInfo: VideoInfo(
                                      videoUrl:
                                          resourseInfo.model.data.videoUrl,
                                      videoDownloadUrl: resourseInfo
                                          .model.data.downloadVideoUrl,
                                      imageUrl:
                                          resourseInfo.model.data.imageUrl,
                                      resName:
                                          resourseInfo.model.data.resourceName,
                                      resId: resourseInfo.model.data.resouceId
                                          .toString(),
                                    ));
                              }));
                            } else {
                              // 文档
                              var model = resourseInfo.model;
                              if (model.data.literatureDownUrl
                                  .endsWith('.pdf')) {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return PDFPage(
                                    model.data.literatureDownUrl,
                                    title: model.data.resourceName,
                                  );
                                }));
                              } else {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (_) {
                                  return WebviewPage(
                                    resourseInfo
                                        .model.data.literaturePreviewUrl,
                                    title: data.resName,
                                  );
                                }));
                              }
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: resourseInfo.model?.msg ?? '获取资源失败');
                          }
                        }
                      }
                    }
                  }),
              Container(
                  child: Divider(height: 0.5),
                  padding: EdgeInsets.symmetric(horizontal: 20)),
              buildRecommendItem(
                  title: data.liveName,
                  showNew: true,
                  subtitle: data.liveTitle,
                  imageUrl: 'static/images/image_courses_recommend_3.png',
                  tag: t != null ? livePredict : Container(),
                  tagTop: 14,
                  tagRight: 0,
                  padding: EdgeInsets.only(left: 20, top: 12, bottom: 12),
                  onPress: () {
                    if ((data.liveStatus ?? 0) >= 1) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) => LivePage(
                                  subjectId: data.subjectId,
                                  gradeId: data.gradeId,
                                  tabIndex: data.liveStatus == 2
                                      ? 1
                                      : 0))) // liveStatus==2, 去直播预告页
                          .then(_refreshLocalHistory);
                    } else {
                      _toActivate();
                    }
                  })
            ],
          )
        ],
      ),
    );
  }

  void _toMicroCourse(MicroCourseResourceDataEntity data,
      dynamic courseCardCourseId, String nodeName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MicroCoursePage(data, courseCardCourseId, from: nodeName);
    }));
  }

  buildRecommendItem(
      {String title,
      String subtitle,
      String imageUrl,
      Widget tag,
      bool showNew = false,
      EdgeInsets padding,
      double tagTop,
      double tagRight,
      OnPress onPress}) {
    var newTag = <Widget>[
      const SizedBox(width: 8),
      Container(
        width: 26,
        height: ScreenUtil.getInstance().setHeight(12),
        alignment: Alignment.center,
        child: Text('new', style: TextStyle(fontSize: 8, color: Colors.white)),
        decoration: BoxDecoration(
          color: const Color(0x7FFF6477),
          borderRadius: BorderRadius.all(
            Radius.circular(6), //设置圆角
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: const Color(0xFFFF6477),
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(0.0, 1.0),
            ),
          ],
        ),
      )
    ];
    return InkWell(
      onTap: onPress,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: tagRight ?? 16,
            top: tagTop ?? 0,
            child: tag,
          ),
          Container(
              padding: padding ??
                  EdgeInsets.only(left: 20, top: 12, right: 16, bottom: 12),
              child: Row(
                children: <Widget>[
                  Image(
                      width: 48,
                      height: ScreenUtil.getInstance().setHeight(48),
                      image: AssetImage(imageUrl)),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(title, style: textStyleContentMid333),
                              if (showNew) ...newTag
                            ]),
                        SizedBox(height: ScreenUtil.getInstance().setHeight(8)),
                        Text(subtitle, style: textStyle12Black),
                      ],
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }

  Future fetchActivity() async {
    ResponseData activityInfo = await CourseDaoManager.activityInfo();
    if (activityInfo.model != null) {
      var model = activityInfo.model as ActivityEntranceModel;
      if (model.code == 1 && model.data != null) {
        var data = model.data;
        if (data.isOpen == 1) {
          if (data.picture != null) {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                              child: Icon(Icons.close, color: Colors.white),
                              onTap: () {
                                Navigator.pop(context);
                              }),
                          Padding(padding: EdgeInsets.only(right: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 10)),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      GestureDetector(
                          child: Padding(padding: EdgeInsets.only(left: 10,right: 10,), child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(image: NetworkImage(data.picture), fit: BoxFit.fill),
                          ),),
                          onTap: (){
                            if (data.url == null || data.url.isEmpty) {
                              Navigator.pop(context);
                              /*
                                * 1.普通活动课
                                * 2.高考冲刺活动课
                                * 3.初中活动课
                                * */
                              int a = data.tagType;
                              if (a == 1) {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (BuildContext context) => ActivityCourse()));
                              } else if (a == 2) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MicroActivityPage(
                                  Config.DEBUG ? 10031312455 : 100289535008,
                                  title: "高考冲刺课",
                                )));
                              } else if (a == 3) {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => JuniorGradePage()));
                              } else {
                                Fluttertoast.showToast(msg: "活动课还没开始!");
                              }
                            } else {
                              Navigator.pop(context);
                              var token = NetworkManager.getAuthorization();
                              String fullUrl = "${data.url}?token=$token";
                              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                return CommonWebview(initialUrl: fullUrl, title: data.description,
                                );
                              }));
                            }
                          }
                      )
                    ],
                  );
                });
          }
        }
      }
    }
  }

  ///
  /// @name _toHistory
  /// @description 跳转到作答记录
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-23
  ///
  void _toHistory() {
//    UMengAnalytics.logEvent('to_history', label: 'click');
    UmengPlugin.logEvent('to_history', label: 'click');
    if (record != null && record.type == 1) {
      var pstr = SharedPrefsUtils.getString('record', '');
      record = LiveListRecord.fromJson(jsonDecode(pstr));
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) => LivePage(
                  subjectId: record.subjectId,
                  gradeId: record.gradeId,
                  record: record)))
          .then(_refreshLocalHistory);
    } else if (record != null && record.type == 2) {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (BuildContext context) => WisdomStudyContainerPage(
                  innerWidget: WisdomStudyPage(
                    record.courseId,
                    record.subjectId,
                    record.gradeId,
                    scrollController: AutoScrollController(),
                    useRecord: true,
                  ),
                  title: '智慧学习')))
          .then(_refreshLocalHistory);
    }
  }

  FutureOr _refreshLocalHistory(value) {
    loadHistory();
    setState(() {});
  }

  Widget _dialogBuilder(BuildContext context) {
    return ActivityCourseAlert(
      tapCallBack: () {
        Navigator.of(context).pop();
      },
    );
  }

  _toActivityCourse() {
    Navigator.pop(context);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => ActivityCourse()));
  }
}

typedef void OnPress();

class Indicator extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const Indicator({Key key, this.width, this.height, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color ?? const Color(MyColors.primaryValue),
        borderRadius:
            BorderRadius.all(Radius.circular(min(width, height) / 2)), //设置圆角
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: color ?? const Color(MyColors.primaryValue),
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
    );
  }
}
