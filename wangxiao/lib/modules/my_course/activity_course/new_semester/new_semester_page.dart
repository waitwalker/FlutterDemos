import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/modules/widgets/common_webview.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name PrimaryEnterJuniorPage
/// @description 四中名师新学期直通车
/// @author liuca
/// @date 2020/5/28
///
class NewSemesterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PrimaryEnterJuniorState();
  }
}

class _PrimaryEnterJuniorState extends State<NewSemesterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "四中名师新学期直通车",
          style: TextStyle(fontSize: 20, color: MyColors.normalTextColor),
        ),
        backgroundColor: Color(MyColors.white),
        elevation: 1,
        ///阴影高度
        titleSpacing: 0,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: _builderListView(),
    );
  }

  Widget _builderListView() {
    return ListView.builder(
      itemBuilder: _itemBuilderContext,
      itemCount: tmpImages.length,
    );
  }

  /// 活动课图片
  List < Map<String,dynamic>> tmpImages = [
    {
      "image" : "static/images/n_semester_junior_1_mathematics.png",
      "type":0,
      "title":"初一数学",
    },
    {
      "image" : "static/images/n_semester_junior_2_chinese.png",
      "type":1,
      "title":"初二语文",
    },
    {
      "image" : "static/images/n_semester_junior_3_english.png",
      "type":2,
      "title":"初三英语",
    },
    {
      "image" : "static/images/n_semester_senior_1_mathematics.png",
      "type":3,
      "title":"高一数学",
    },
    {
      "image" : "static/images/n_semester_senior_2_physics.png",
      "type":4,
      "title":"高二物理",
    },
    {
      "image" : "static/images/n_semester_senior_3_english.png",
      "type":5,
      "title":"高三英语",
    },
  ];

  /// 单个item
  Widget _itemBuilderContext(BuildContext context, int index) {
    Map map = tmpImages[index];
    String imagePath = map["image"];
    String title = map["title"];
    int type = map["type"];
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Hero(
            tag: 'hero_$index',
            child: Container(
              height: ScreenUtil.getInstance().setHeight(136),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),),
            )),
      ),
      onTap: () {
        var token = NetworkManager.getAuthorization();
        String url = Config.DEBUG ? "http://huodongt.etiantian.com/zhitongche/indexm.html?token=" : "https://huodong.etiantian.com/zhitongche/indexm.html?token=";
        String typeStr = "&type=$type";
        String fullUrl = "$url$token$typeStr";
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return CommonWebview(initialUrl: fullUrl, title: title,);
        }));
      },
    );
  }
}