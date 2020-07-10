import 'dart:io';
import 'package:online_school/common/const/router_const.dart';
import 'package:online_school/common/network/error_code.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/event/CardActivated.dart';
import 'package:online_school/model/subject_detail_model.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/modules/my_course/wisdom_study/scroll_to_index/scroll_to_index.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/my_course/ai_test/ai_test_page.dart';
import 'package:online_school/modules/my_course/live/live_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/wisdom_study_container_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/wisdom_study_page.dart';
import 'package:online_school/modules/personal/activate_card/activate_card_page.dart';
import 'package:online_school/modules/personal/activate_card/activate_card_state_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/grade_utils.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import '../personal/activate_card/activate_card_type_page.dart';
import 'ai_test/ai_container_page.dart';
import 'live/live_page.dart';


///
/// @name SubjectDetailPage
/// @description 学科详情页面  首页=>学科=>学科详情页面
/// @author liuca
/// @date 2020-01-10
///
class SubjectDetailPage extends StatefulWidget {
  List<int> gradeIds;
  int subjectId;
  int defaultGradeId;
  final bool hiddenCard;
  final num cardType;

  SubjectDetailPage(
      {this.gradeIds, this.subjectId, this.hiddenCard = true, this.cardType});

  @override
  State<StatefulWidget> createState() {
    return _SubjectDetailState(
        hiddenDownload: true, gradeJoin: "", cardEndTime: "", nextLiveTime: "");
  }
}

class _SubjectDetailState extends State<SubjectDetailPage> {
  /// 学科Id
  int gradeId;
  // 没有开课的用户，可以预览全部学科，
  // 但是，物理没初一
  // 化学没初二
  List<int> get gradeIds => widget.gradeIds.isNotEmpty
      ? widget.gradeIds
      : widget.subjectId == 4
          ? [5, 4, 3, 2, 1]
          : widget.subjectId == 5 ? [4, 3, 2, 1] : [6, 5, 4, 3, 2, 1];

  /// 是否隐藏下拉
  bool hiddenDownload = true;
  bool get previewUser => widget.gradeIds?.isEmpty ?? true;
  bool previewMode = false;

  /// 年级学科
  String gradeJoin = "";

  /// 卡结束日期
  String cardEndTime = "";

  /// 下次直播时间
  String nextLiveTime = "";

  SubjectDetailModel subjectDetailModel;

  _SubjectDetailState(
      {this.hiddenDownload,
      this.gradeJoin,
      this.cardEndTime,
      this.nextLiveTime});

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  @override
  void initState() {
    gradeId = gradeIds[0];

    // 不是体验模式
    if (!previewUser) {
      previewMode = false;
      _loadData(gradeId);
    } else {
      previewMode = true;
    }

    super.initState();
  }

  /// 获取学科详情数据
  _loadData(int grdId) async {
    /// 年级
    String grade = gradeSample[grdId].toString();

    /// 学科名称
    String subjectName = subjectSample[widget.subjectId];
    gradeJoin = grade + subjectName;
    setState(() {});
    var response = await CourseDaoManager.subjectDetail(gradeId: grdId, subjectId: widget.subjectId, cardType: widget.cardType);
    if (response.result && response.model.code == 1) {
      subjectDetailModel = response.model as SubjectDetailModel;
      /// 到期时间
      String cardEndTimeStr = subjectDetailModel.data.cardEndTime ?? "";

      /// 直播时间
      String nextLiveTimeStr = subjectDetailModel.data.nextLiveTime ?? "";
      if (subjectDetailModel.data.onlineLabel == 1) {
        previewMode = false;
      } else {
        previewMode = true;
      }

      setState(() {
        if (gradeIds.length > 1) {
          hiddenDownload = false;
        } else {
          hiddenDownload = true;
        }
        cardEndTime = _cardEndDateFormate(DateTime.tryParse(cardEndTimeStr)) + "到期";
        if (nextLiveTimeStr.isNotEmpty) {
          nextLiveTime = _liveDateFormate(DateTime.tryParse(nextLiveTimeStr));
        }
      });
    } else {
      // toast("获取学科详情数据失败");
      previewMode = true;
    }
  }

  /// 直播课时间格式化
  String _liveDateFormate(DateTime dateTime) {
    String minute =
        dateTime.minute > 9 ? "${dateTime.minute}" : "${dateTime.minute}" + "0";
    String hour =
        dateTime.hour > 9 ? "${dateTime.hour}" : "0" + "${dateTime.hour}";
    return "${dateTime.month}" +
        "月" +
        "${dateTime.day}" +
        "日" +
        " " +
        hour +
        ":" +
        minute;
  }

  /// 卡结束日期格式化
  String _cardEndDateFormate(DateTime dateTime) {
    return "${dateTime.year}" +
        "." +
        "${dateTime.month}" +
        "." +
        "${dateTime.day}";
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return Scaffold(
        appBar: _appBar(),
        backgroundColor: Color(MyColors.background),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(child: ListView(
                children: <Widget>[
                  /// 顶部
                  _bodyTopContainer(),

                  // 智慧学习和AI位置调换
                  _bodyCardTwoContainer(),
                  /// 中间卡片容器
                  _bodyCardOneContainer(),

                  /// 智领课
                  if (widget.cardType == 3)
                    _bodyCardThreeContainer(),

                  if (SingletonManager.sharedInstance.screenWidth > 500.0)
                    SizedBox(height: 80,),
                ],
              )),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> _titleChildren() {
    if (gradeIds.length > 1) {
      return <Widget>[
        DropdownButton(
          iconSize: 26,
          hint: Text(gradeSample[gradeId], style: TextStyle(fontSize: 20),),
          underline: Container(),
          items: _getListData(),
          value: gradeId,
          onChanged: (currentGradeId) {
            gradeId = currentGradeId;
            _loadData(gradeId);
          },
        ),
      ];
    } else {
      return <Widget>[
        Text(
          gradeJoin,
          style: TextStyle(fontSize: 20),
        ),
        Padding(padding: EdgeInsets.only(left: 8)),
      ];
    }
  }

  /// 导航栏
  _appBar() {
    return AppBar(
      title: Container(
        child: Row(
          children: _titleChildren(),
        ),
      ),
      backgroundColor: Color(MyColors.white),
      elevation: 1,
      ///阴影高度
      titleSpacing: 0,
      centerTitle: Platform.isIOS ? true : false,
      actions: _renewCard(),
    );
  }

  /// 续卡
  _renewCard() {
    if (widget.hiddenCard) {
      return <Widget>[
        /// 续卡
        Container(),
      ];
    } else {
      return <Widget>[
        Container(
          color: Colors.transparent,
          width: 180,
          child: Padding(
            padding: EdgeInsets.only(right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Image.asset(
                    "static/images/icon_nav_card.png",
                    width: 28, height: 28,
                  ),
                  onTap: () {
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
                  },
                ),
                Text(cardEndTime, style: TextStyle(fontSize: 10, color: Color(MyColors.cardEndTimeGrey)),),
              ],
            ),
          ),
        ),
      ];
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

  /// 下拉菜单列表
  List<DropdownMenuItem> _getListData() {
    List<DropdownMenuItem> items = List();
    if (gradeIds.length < 2) {
      return [];
    }

    for (int i = 0; i < gradeIds.length; i++) {
      String gradeName = gradeSample[gradeIds[i]].toString();
      String subjectName = subjectSample[widget.subjectId];
      DropdownMenuItem dropdownMenuItem = DropdownMenuItem(
        child: Text(
          gradeName + subjectName,
          style: TextStyle(fontSize: 20),
        ),
        value: gradeIds[i],
      );

      items.add(dropdownMenuItem);
    }
    return items;
  }

  /// 顶部容器
  _bodyTopContainer() {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            "static/images/img_course_subject_background.png",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),

          _header(),
        ],
      ),
    );
  }

  /// 中间卡片1容器
  _bodyCardOneContainer() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Container(
          decoration: _boxDecoration(),
          child: Stack(
            children: <Widget>[
              Image.asset("static/images/subject_card_ai.png"),
              Positioned(
                bottom: 25,
                left: 28,
                child: Text("AI智能推送 快速高效刷题", style: TextStyle(fontSize: 13, color: Color(0xff262525)),),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // if (subjectDetailModel == null) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => AIContainerPage(
                innerWidget: AITestPage(
                  widget.subjectId,
                  gradeId,
                  courseId: subjectDetailModel?.data?.courseId ?? 0,
                  previewMode: previewUser,
                ),
                title: 'AI测试')));
      },
    );
  }

  /// 中间卡片2容器
  _bodyCardTwoContainer() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: 24, left: 16, right: 16),
        child: Container(
          decoration: _boxDecoration(),
          child: Stack(
            children: <Widget>[
              Image.asset("static/images/subject_card_zhihui.png"),
              Positioned(
                right: 31,
                bottom: 20,
                child: Text("四中老师微课等你学", style: TextStyle(fontSize: 13, color: Color(0xff262525)),),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // if (subjectDetailModel == null) return;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => WisdomStudyContainerPage(
                innerWidget: WisdomStudyPage(
                  subjectDetailModel?.data?.courseId ?? 0,
                  widget.subjectId,
                  gradeId,
                  scrollController: AutoScrollController(),
                  useRecord: !previewUser,
                  previewMode: previewUser,
                ),
                title: '智慧学习')));
      },
    );
  }

  /// 中间卡片3容器
  _bodyCardThreeContainer() {
    return Padding(
      padding: EdgeInsets.only(top: 24, left: 16, right: 16),
      child: Container(
        decoration: _boxDecoration(),
        child: GestureDetector(
          child: Stack(
            children: <Widget>[
              Image.asset("static/images/subject_card_zhibo.png"),
              Positioned(
                bottom: 23, left: 29,
                child: Text("在线体验大师直播课", style: TextStyle(fontSize: 13, color: Color(0xff262525)),),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => LivePage(
                      subjectId: widget.subjectId,
                      gradeId: gradeId,
                      courseId: subjectDetailModel?.data?.courseId ?? 0,
                      previewMode: previewMode,
                    )));
          },
        ),
      ),
    );
  }

  /// toast
  toast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Color(MyColors.black222),
        textColor: Color(MyColors.white),
        fontSize: 16.0);
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Color(MyColors.white),
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 2),
            blurRadius: 10.0,
            spreadRadius: 2.0)
      ],
    );
  }

  _header() {
    return Padding(
        padding: EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
        child: Text(
          '''hi！欢迎开始今天的高效学习之旅！
AI智能助手与四中资深老师陪你一起成长～
每天进步一点点''',
          style: TextStyle(
            fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 13,
            color: Color(MyColors.subjectTopText),
          ),
        ));
  }

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    print("页面即将销毁");
    super.deactivate();
  }

  @override
  void dispose() {
    print("页面销毁");
    super.dispose();
  }
}
