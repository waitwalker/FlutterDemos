import 'dart:io';

import 'package:flutter/material.dart';

class CommonSliverAppBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonSliverAppBarState();
  }
}

// 参考文档
// https://www.jianshu.com/p/fddac387cbe5
class _CommonSliverAppBarState extends State<CommonSliverAppBarPage> {

  List<String> tabTitles = [
    "Tab 1",
    "Tab 2",
    "Tab 3",
    "Tab 4",
  ];

  final colors = <Color>[Colors.red, Colors.green, Colors.blue, Colors.pink, Colors.yellow, Colors.deepPurple];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: tabTitles.length,
          child: NestedScrollView(
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                SliverOverlapAbsorber(
                  // 传入 handle 值，直接通过 `sliverOverlapAbsorberHandleFor` 获取即可
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    title: Text('NestedScroll Demo'),
                    expandedHeight: 200.0,
                    flexibleSpace: FlexibleSpaceBar(background: Image.asset('static/images/logo.png', fit: BoxFit.cover)),
                    bottom: TabBar(
                      tabs: tabTitles.map((tab) => Text(tab, style: TextStyle(fontSize: 18.0))).toList(),
                      indicatorColor: Colors.cyan,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorWeight: 15,
                      labelColor: Colors.redAccent,
                      unselectedLabelColor: Colors.amberAccent,
                    ),
                    forceElevated: innerScrolled,
                  ),
                )
              ],
              body: TabBarView(
                  children: tabTitles.map((tab) => Builder(
                    builder: (context) => CustomScrollView(
                      // key 保证唯一性
                      key: PageStorageKey<String>(tab),
                      slivers: <Widget>[
                        // 将子部件同 `SliverAppBar` 重叠部分顶出来，否则会被遮挡
                        SliverOverlapInjector(
                            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                    (_, index) => Image.asset('static/images/logo.png'),
                                childCount: 8),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, mainAxisSpacing: 10.0, crossAxisSpacing: 10.0)),
                        SliverFixedExtentList(
                            delegate: SliverChildBuilderDelegate(
                                    (_, index) => Container(
                                    child: Text('$tab - item${index + 1}',
                                        style: TextStyle(fontSize: 20.0, color: colors[index % 6])),
                                    alignment: Alignment.center),
                                childCount: 15),
                            itemExtent: 50.0)
                      ],
                    ),
                  ))
                      .toList()))),
    );
  }
}