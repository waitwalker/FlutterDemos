import 'package:flutter/material.dart';
import 'package:online_school/modules/common_app/home/dotter_border_page.dart';
import 'package:online_school/modules/common_app/home/image_page.dart';
import 'package:online_school/modules/common_app/home/multi_image_picker_page.dart';
import 'package:online_school/modules/common_app/home/navigation_route_page.dart';
import 'package:online_school/modules/common_app/home/notification_permission_page.dart';
import 'package:online_school/modules/common_app/home/position_tapped_page.dart';
import 'package:online_school/modules/common_app/home/slider_page.dart';
import 'package:online_school/modules/common_app/home/sliver_page.dart';
import 'package:online_school/modules/common_app/home/time_axis_page.dart';

class CommonHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonHomeState();
  }
}

class _CommonHomeState extends State<CommonHomePage> {

  List<String> titles = [
    "左划右划",
    "导航跳转动画",
    "图片多选",
    "原点边框",
    "通知权限",
    "点击位置",
    "滚动渐变导航",
    "时间轴",
    "图片",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: ListView.builder(itemBuilder: _itemBuilder, itemCount: titles.length,),
    );
  }



  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Padding(padding: EdgeInsets.only(left: 20, right: 10), 
        child: Container(
          height: 44,
          child: Row(
            children: <Widget>[
              Text(titles[index]),
              Icon(Icons.arrow_forward_ios, size: 16,)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
      onTap: () {
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return SliderPage();
          }));
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonNavigationRoutePage();
          }));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonMultiImagePickerPage();
          }));
        } else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonDottedBorderPage();
          }));
        } else if (index == 4) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonNotificationPermissionPage();
          }));
        } else if (index == 5) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonPositionTappedPage();
          }));
        } else if (index == 6) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonSliverPage();
          }));
        } else if (index == 7) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonTimeAxisPage();
          }));
        } else if (index == 8) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonImagePage();
          }));
        }

      },
    );
  }
}