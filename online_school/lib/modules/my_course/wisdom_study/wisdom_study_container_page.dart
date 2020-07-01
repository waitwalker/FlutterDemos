import 'dart:io';

import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'knowledge_guide_list_page.dart';
import 'wisdom_study_page.dart';


///
/// @name WisdomStudyContainerPage
/// @description 智慧学习 容器页面
/// @author liuca
/// @date 2020-01-10
///
class WisdomStudyContainerPage extends StatefulWidget {
  Widget innerWidget;
  String title;

  WisdomStudyContainerPage({this.innerWidget, this.title});

  @override
  _WisdomStudyContainerPageState createState() => _WisdomStudyContainerPageState();
}

class _WisdomStudyContainerPageState extends State<WisdomStudyContainerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(MyColors.background),
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: Platform.isIOS ? true : false,
          actions: <Widget>[
            InkWell(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 16, left: 16),
                child: Container(
                  alignment: Alignment.center,
                  height: SingletonManager.sharedInstance.screenWidth > 500.0 ? 30 : 26,
                  width: SingletonManager.sharedInstance.screenWidth > 500.0 ? 70 : 62,
                  child: Text('知识导学', style: TextStyle(color: Colors.white, fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 13 : 12),),
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
              ),
              onTap: _toDoc,
            ),
          ]),
      body: widget.innerWidget,
    );
  }

  void _toDoc() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return KnowledgeGuideListPage((widget.innerWidget as WisdomStudyPage).gradeId,
          (widget.innerWidget as WisdomStudyPage).subjectId);
    }));
  }
}
