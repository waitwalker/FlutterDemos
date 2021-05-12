// import 'package:flukit/flukit.dart';
import 'dart:convert';

import 'package:dashboard_flutter/pages/demo/Video/swiper.dart';
import 'package:dashboard_flutter/pages/modules/SharedPreferencesModeules.dart'; 
import 'package:flutter/material.dart';
import '../../demo/Video/video_play_view_controller.dart';
import '../../service/event_bus_service.dart';
import '../../../models/ModelTable/ListenModels.dart';
import '../../../utils/HttpUtils.dart';

class VideoViewController extends StatefulWidget {
  final String id;
  final int pageNum;
  final int pageSize;
  VideoViewController(this.id, this.pageNum, this.pageSize);

  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoViewControllerState();
  }
}

class VideoViewControllerState extends State<VideoViewController> {
  SwiperController _controller = SwiperController();

  int checkedTabIndex = 0; //选中的tab
  List<ListenModels> listenList = new List<ListenModels>();

  int selectIndex = 99999; //播放视频的索引 
  bool isVip = false; //是否开通vip
  SpUtil sp = new SpUtil();

//获取收听接口数据
  getFindList() async {
    var dd = widget.pageNum * widget.pageSize;
    var result = await HttpUtils.request(
        "Find/GetFindList?type=视频" +
            "&pageNum=1" +
            "&pageSize=300" ,
            // dd.toString(),
        // (widget.pageNum * widget.pageSize).toString(),
        method: HttpUtils.GET);

    if (result.toString() == '[]') {
      // listenList = [];
      // Toast.show("暂无更多音频", context, gravity: Toast.CENTER);
      // if (mounted) {
      //   setState(() {});
      // }
    } else {
      ListenList d = new ListenList.fromJson(result);
      listenList.addAll(d.listenList);
      int dindex = 0; 
      listenList.forEach((p) {
        dindex = dindex + 1;
        if (p.id == widget.id) {
          selectIndex = dindex; 
        }
      });
      
      print(selectIndex);
      _controller = SwiperController(initialPage: selectIndex - 2);
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVip = jsonDecode(sp.getPreferencesString('isvip')) == true ? true : false;
    getFindList();
    _controller.addListener(() {
      if (_controller.page.floor() == _controller.page) {
        print(_controller.page.floor());
        eventBus.emit(keyPlayVideo + _controller.page.floor().toString(),
            _controller.page.floor());
      }
    });
  }

 @override
  void dispose() {
    _controller.dispose(); 
    super.dispose(); 
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int index = 0;
    for (var item in this.listenList) {
      if(isVip==true||index<=1){
        children.add(VideoController(
              positionTag: index,
              selectTag: selectIndex - 2,
              listenModel: item,
            ));
      } 
      index++;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("视频"),
        centerTitle: true,
      ),
      body: children.length > 0
          ? Container(
              child: Swiper(
                autoStart: false,
                circular: false,
                direction: Axis.vertical,
                children: children,
                controller: _controller,
                // indicatorAlignment:AlignmentDirectional.center
              ),
              // color: Color.fromRGBO(0, 0, 0, 0.1),
              // color: Colors.red,
            )
          : Container(),
    );
  }
}
