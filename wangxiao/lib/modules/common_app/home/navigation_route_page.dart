import 'package:cube_transition/cube_transition.dart';
import 'package:flutter/material.dart';
import 'package:online_school/modules/common_app/home/dotter_border_page.dart';
import 'package:online_school/modules/common_app/home/multi_image_picker_page.dart';
import 'package:online_school/modules/common_app/home/navigation_transition_page.dart';
import 'package:online_school/modules/common_app/home/notification_permission_page.dart';
import 'package:online_school/modules/common_app/home/position_tapped_page.dart';
import 'package:online_school/modules/common_app/home/slider_page.dart';
import 'package:page_transition/page_transition.dart';

class CommonNavigationRoutePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonNavigationRouteState();
  }
}

class _CommonNavigationRouteState extends State<CommonNavigationRoutePage> {

  List<String> titles = [
    "导航跳转动画Fade",
    "导航跳转动画leftToRight",
    "导航跳转动画rightToLeft",
    "导航跳转动画upToDown",
    "导航跳转动画downToUp",
    "导航跳转动画scale",
    "导航跳转动画size",
    "导航跳转动画rotate",
    "导航跳转动画rightToLeftWithFade",
    "导航跳转动画leftToRightWithFade",
    "导航跳转动画3D",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("跳转动画"),
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
        int tmp = 1;
        if (index == 1 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: CommonNavigationTransitionPage()));
        } else if (index == 2 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: CommonNavigationTransitionPage()));
        } else if (index == 3 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: CommonNavigationTransitionPage()));
        } else if (index == 4 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.upToDown, child: CommonNavigationTransitionPage()));
        } else if (index == 5 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.downToUp, child: CommonNavigationTransitionPage()));
        } else if (index == 6 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.scale, alignment: Alignment.bottomCenter, child: CommonNavigationTransitionPage()));
        } else if (index == 7 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.size, alignment: Alignment.bottomCenter, child: CommonNavigationTransitionPage()));
        } else if (index == 8 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.rotate, duration: Duration(seconds: 1), child: CommonNavigationTransitionPage()));
        } else if (index == 9 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeftWithFade, child: CommonNavigationTransitionPage()));
        } else if (index == 10 - tmp) {
          Navigator.push(context, PageTransition(type: PageTransitionType.leftToRightWithFade, child: CommonNavigationTransitionPage()));
        } else if (index == 11 - tmp) {
          Navigator.of(context).push(CubePageRoute(
              enterPage: CommonNavigationTransitionPage(),
              duration: Duration(milliseconds: 900)
          ));
        } else if (index == 12 - tmp) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonMultiImagePickerPage();
          }));
        } else if (index == 13 - tmp) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonDottedBorderPage();
          }));
        } else if (index == 14 - tmp) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonNotificationPermissionPage();
          }));
        } else if (index == 15 - tmp) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonPositionTappedPage();
          }));
        }
      },
    );
  }
}