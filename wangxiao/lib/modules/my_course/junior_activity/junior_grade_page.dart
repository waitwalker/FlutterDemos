import 'dart:io';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/modules/my_course/junior_activity/junior_detail_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name JuniorGradePage
/// @description 复课衔接强化课 里面会有选择学科 选择版本
/// @author liuca
/// @date 2020/5/28
///
class JuniorGradePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JuniorGradeState();
  }
}

class _JuniorGradeState extends State<JuniorGradePage> {
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
      itemCount: 4,
    );
  }

//  /// 活动课图片
//  List < Map<String,dynamic>> tmpImages = [
//    {
//      "image" : "static/images/j_grade_1.png",
//      "tagId" : Config.DEBUG ? 10031312455 : 100289535008
//    },
//    {
//      "image" : "static/images/j_grade_2.png",
//      "tagId" : Config.DEBUG ? 10031312455 : 100289535008
//    },
//    {
//      "image" : "static/images/j_grade_3.png",
//      "tagId" : Config.DEBUG ? 10031312455 : 100289535008
//    },
//    {
//      "image" : "static/images/j_grade_54_4.png",
//      "tagId" : Config.DEBUG ? 10031312455 : 100289535008
//    }
//  ];

  /// 活动课图片
  List < Map<String,dynamic>> tmpImages = [
    {
      "image" : "static/images/j_grade_1.png",
      "tagId" : Config.DEBUG ? 100031313665 : 100311021829
    },
    {
      "image" : "static/images/j_grade_2.png",
      "tagId" : Config.DEBUG ? 100031313666 : 100311021831
    },
    {
      "image" : "static/images/j_grade_3.png",
      "tagId" : Config.DEBUG ? 100031313667 : 100311021833
    },
    {
      "image" : "static/images/j_grade_54_4.png",
      "tagId" : Config.DEBUG ? 100031313664 : 100311021828
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
          return JuniorDetailPage(tagId);
        }));
      },
    );
  }
}