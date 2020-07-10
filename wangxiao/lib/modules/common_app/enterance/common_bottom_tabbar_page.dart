import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:online_school/modules/common_app/add/common_add_page.dart';
import 'package:online_school/modules/common_app/home/common_home_page.dart';
import 'package:online_school/modules/common_app/search/common_search_page.dart';

class CommonBottomTabBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonBottomTabBarState();
  }
}

class _CommonBottomTabBarState extends State<CommonBottomTabBarPage> {

  // 默认选中页面
  int _selectedIndex = 0;

  // 内容页面列表
  List<Widget> _contentPages = [];

  @override
  void initState() {
    _contentPages
      ..add(CommonHomePage())
      ..add(CommonSearchPage());
    super.initState();
  }

  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contentPages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, size: 30,),
              color: Colors.white,
              onPressed: () => _itemTapped(0),
            ),

            SizedBox(),

            Badge(
              child: IconButton(
                icon: Icon(Icons.search, size: 30),
                color: Colors.white,
                onPressed: () => _itemTapped(1),
              ),
              badgeColor: Colors.deepOrangeAccent,
              shape: BadgeShape.circle,
              borderRadius: 20,
              toAnimate: false,
              position: BadgePosition.topRight(right: 5),
              badgeContent: Text('2', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add),
        onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
              return CommonAddPage();
            }));
        },
      ),
      // 设置floatingActionButton 在底部导航栏中间
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}