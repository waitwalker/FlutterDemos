import 'dart:convert';
import 'package:online_school/common/dao/original_dao/video_dao.dart';
import 'package:online_school/model/app_info.dart';
import 'package:online_school/model/video_source_model.dart';
import 'package:online_school/modules/my_course/wisdom_study/micro_course_page.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/app_info_reducer.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'play_outline_button.dart';

///
/// @name PlayerMenu
/// @description  播放菜单
/// @author liuca
/// @date 2020-01-11
///
class PlayerMenu extends StatefulWidget {
  AsyncMemoizer memoizer;

  PlayerMenu({this.memoizer});

  @override
  _PlayerMenuState createState() => _PlayerMenuState();
}

class _PlayerMenuState extends State<PlayerMenu> {
  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> vm) {
      return _buildMask(vm);
    });
  }

  Widget _buildMask(Store<AppState> vm) {
    var bg = vm.state.appInfo.backgroundPlay ?? false;
    return Stack(
      children: <Widget>[
        // Positioned.fill(child: Container()),
        Positioned(
            right: 0,
            child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      child: Text('后台播放',
                          style: TextStyle(
                              color: Color(0xff999999), fontSize: 12)),
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    Row(
                      children: <Widget>[
                        new PlayerOutlineButton(
                            text: '开启',
                            selected: bg,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            onPress: () {
                              print('开启');
                              _getStore().dispatch(UpdateAppInfoAction(
                                  AppInfo(backgroundPlay: true)));
                              PlayBackgroundNotification(true)
                                  .dispatch(context);
                              SharedPrefsUtils.put('background_play', true);
                            }),
                        const SizedBox(width: 15),
                        new PlayerOutlineButton(
                            text: '关闭',
                            selected: !bg,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 4),
                            onPress: () {
                              _getStore().dispatch(UpdateAppInfoAction(
                                  AppInfo(backgroundPlay: false)));
                              PlayBackgroundNotification(false)
                                  .dispatch(context);
                              SharedPrefsUtils.put('background_play', false);
                            }),
                      ],
                    ),
                    Padding(
                      child: Text('线路选择',
                          style: TextStyle(
                              color: Color(0xff999999), fontSize: 12)),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder(
                        future: _getVideoSource(),
                        builder: (context, snapshot) => _buildVideoSource(
                            context, snapshot, vm.state.appInfo.line),
                      ),
                    )
                  ],
                ),
                width: MediaQuery.of(context).size.width / 2 + 10,
                height: MediaQuery.of(context).size.height,
                decoration:
                    BoxDecoration(color: Colors.black.withOpacity(0.6)))),
        // Positioned(right: 0, child: Text('ZZZ')),
      ],
    );
  }

  _getVideoSource() {
    return widget.memoizer?.runOnce(() => VideoDao.getVideoSource()) ??
        VideoDao.getVideoSource();
  }

  Widget _buildVideoSource(BuildContext context,
      AsyncSnapshot<dynamic> snapshot, VideoSource source) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.active:
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      case ConnectionState.done:
        if (snapshot.hasError) return Text('获取线路失败');
        var model = snapshot.data.model as VideoSourceModel;
        if (model == null || model.data == null || model.code != 1)
          return Text('获取线路失败');
        List<VideoSource> sources = model.data;
        if (sources.isEmpty) return Text('获取线路失败');
        if (source == null) {
          source = sources.first;
        }
        return Row(children: <Widget>[
          ...sources
              .map((l) {
                return [
                  PlayerOutlineButton(
                      text: l.lineName,
                      selected: l.lineId == source.lineId,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      onPress: () {
                        _getStore()
                            .dispatch(UpdateAppInfoAction(AppInfo(line: l)));
                        ChangeVideoSourceNotification(l.lineId)
                            .dispatch(context);
                        SharedPrefsUtils.putString(
                            'video_source', jsonEncode(l.toJson()));
                      }),
                  SizedBox(width: 15)
                ];
              })
              .expand((a) => a)
              .toList()
        ]);
      // Text('Error: ${liveDetailModel.msg}');
      default:
        return Text('获取线路失败');
    }
  }
}
