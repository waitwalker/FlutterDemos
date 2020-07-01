import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/activity_course_dao.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/activity_course_model.dart';
import 'package:online_school/modules/my_course/junior_activity/junior_grade_page.dart';
import 'package:online_school/modules/my_course/micro_activity/micro_activity_page.dart';
import 'package:online_school/modules/my_course/union_activity/union_grade_page.dart';
import 'package:online_school/modules/widgets/common_webview.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'activity_course_detail_page.dart';

///
/// @name ActivityCourse
/// @description 活动课
/// @author liuca
/// @date 2020-01-10
///
class ActivityCourse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ActivityCourseState();
  }
}

class _ActivityCourseState extends State<ActivityCourse> {
  AsyncMemoizer memoizer = AsyncMemoizer();

  /// 活动课数据
  List<DataEntity> datas;

  /// 活动课列表
  List<RegisterCourseListEntity> registerCourseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _future(),
    );
  }

  /// 导航栏
  _appBar() {
    return AppBar(
      title: Text(
        "活动课",
        style: TextStyle(fontSize: 20, color: MyColors.normalTextColor),
      ),
      backgroundColor: Color(MyColors.white),
      elevation: 1,

      ///阴影高度
      titleSpacing: 0,
      centerTitle: Platform.isIOS ? true : false,
    );
  }

  /// body
  _future() {
    return FutureBuilder(
      builder: _futureBuilder,
      future: _loadData([11]),
    );
  }

  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
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
        print(snapshot);

        if (snapshot.hasError)
          return EmptyPlaceholderPage(message: '网络请求失败', onPress: refresh);
        if (!snapshot.hasData || snapshot.data.model == null)
          return Text('Error: 没有数据');
        var activityCourseModel = snapshot.data.model as ActivityCourseModel;
        datas = activityCourseModel.data;
        if (datas == null || datas.isEmpty)
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png', message: '没有数据');
        registerCourseList = datas[0].registerCourseList;
        registerCourseList.insert(0, RegisterCourseListEntity());
        registerCourseList.insert(0, RegisterCourseListEntity());
        // 联通活动课暂时隐藏
        //registerCourseList.insert(0, RegisterCourseListEntity());
        if (registerCourseList == null) return Text('Error: 没有数据');
        return _builderListView();
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  /// 获取数据
  refresh() {
    setState(() {
      memoizer = AsyncMemoizer();
    });
  }

  _loadData(List<int> grades) {
    return memoizer.runOnce(() => ActivityCourseDao.fetch(grades));
  }

  Widget _builderListView() {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: registerCourseList.length,
    );
  }

  /// 活动课图片
  List<String> tmpImages = [
    "static/images/img_activity_banner01.png",
    "static/images/img_activity_banner02.png",
    "static/images/img_activity_banner03.png"
  ];

  List<String> staticImages = [
    //"static/images/u_banner_enterance.png",
    "static/images/j_home_banner.png",
    "static/images/c_enntrance_home_banner.png",
  ];

  /// 单个item
  Widget _itemBuilder(BuildContext context, int index) {
    if (index < 2) {
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Hero(
              tag: 'hero_$index',
              child: Container(
                height: SingletonManager.sharedInstance.screenHeight > 1000 ? ScreenUtil.getInstance().setHeight(156) :ScreenUtil.getInstance().setHeight(136),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    image: DecorationImage(
                        image: AssetImage(staticImages[index]), fit: BoxFit.fill)),
              )),
        ),
        onTap: () {
          if (index == 5) {
            //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => UnionGradePage()));
            var token = NetworkManager.getAuthorization();
            String url = Config.DEBUG ? "http://huodongt.etiantian.com/activity01/zhongkaom.html?token=" : "http://huodong.etiantian.com/liantong/indexm.html?token=";
            String fullUrl = "$url$token";
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return CommonWebview(initialUrl: fullUrl, title: "中国联通·北京四中网校名师课堂",);
            }));
          } else if (index == 0) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => JuniorGradePage()));
          } else if (index == 1) {
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MicroActivityPage(Config.DEBUG ? 10031312455 : 100289535008,
              title: "高考冲刺课",
            )));
          }
        },
      );
    } else {
      var course = registerCourseList[index];
      String imagePath = course.courseCover ?? tmpImages[1];
      return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Hero(
              tag: 'hero_$index',
              child: Container(
                height: SingletonManager.sharedInstance.screenHeight > 1000 ? ScreenUtil.getInstance().setHeight(156) :ScreenUtil.getInstance().setHeight(136),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    image: DecorationImage(
                        image: NetworkImage(imagePath), fit: BoxFit.fill)),
              )),
        ),
        onTap: () {
          var allowDetail = course.activityCourseSwitchStatus == 1;
          if (allowDetail) {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return ActivityCourseDetailPage(
                  courses: course.courseList,
                  rcourseId: course.registerCourseId.toString(),
                  showAll: course.signUp == 1,
                  courseContent: course.courseContent,
                  banner: imagePath,
                  index: index);
            }));
          } else {
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
        },
      );
    }
  }

  BoxDecoration _boxDecoration(String imagePath) {
    return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
        image: DecorationImage(image: AssetImage(imagePath)));
  }
}
