import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/modules/my_course/union_activity/union_detail_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name UnionGradePage
/// @description 联通活动课 里面会有 选择版本
/// @author liuca
/// @date 2020/5/28
///
class UnionGradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuniorGradeState();
  }
}

class _JuniorGradeState extends State<UnionGradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "选择年级",
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
      "image" : "static/images/u_junior_1.png",
      "tagId" : Config.DEBUG ? 100355988705 : 100355988705
    },
    {
      "image" : "static/images/u_junior_2.png",
      "tagId" : Config.DEBUG ? 100355988706 : 100355988706
    },
    {
      "image" : "static/images/u_junior_3.png",
      "tagId" : Config.DEBUG ? 100355988707 : 100355988707
    },
    {
      "image" : "static/images/u_junior_54.png",
      "tagId" : Config.DEBUG ? 100355988711 : 100355988711
    },
    {
      "image" : "static/images/u_senior_1.png",
      "tagId" : Config.DEBUG ? 100355988708 : 100355988708
    },
    {
      "image" : "static/images/u_senior_2.png",
      "tagId" : Config.DEBUG ? 100355988709 : 100355988709
    },
    {
      "image" : "static/images/u_senior_3.png",
      "tagId" : Config.DEBUG ? 100355988710 : 100355988710
    }
  ];

  /// 单个item
  Widget _itemBuilderContext(BuildContext context, int index) {
    Map map = tmpImages[index];
    String imagePath = map["image"];
    int tagId = map["tagId"];
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
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return UnionDetailPage(tagId);
        }));
      },
    );
  }
}