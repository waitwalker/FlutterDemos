import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart'; 
import '../../service/event_bus_service.dart';
import '../../service/screen_service.dart';
import 'package:video_player/video_player.dart';
import '../../../models/ModelTable/ListenModels.dart';
import 'package:chewie/chewie.dart'; 

class VideoController extends StatefulWidget {
  // final String image;
  final int positionTag;
  final int selectTag;
  // final String video;
  final ListenModels listenModel;

  VideoController({Key key, this.positionTag, this.selectTag, this.listenModel})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ViewControllerState();
  }
}

class ViewControllerState extends State<VideoController> {
  ScrollController scroController = new ScrollController();
  Timer timer;
  bool videoPrepared = false; //视频是否初始化
  bool _hideActionButton = true;
  VideoPlayerController _controller;

  static double h = Platform.isAndroid
      ? (16 / 9 * ScreenService.width - ScreenService.topSafeHeight <=
              ScreenService.height
          ? 16 / 9 * ScreenService.width - ScreenService.topSafeHeight
          : ScreenService.height)
      : (16 / 9 * ScreenService.width <= ScreenService.height
          ? 16 / 9 * ScreenService.width
          : ScreenService.height);
  void startTimer() {
    int time = 3000;
    timer = Timer.periodic(new Duration(milliseconds: time), (timer) {
      if (scroController.positions.isNotEmpty == false){
        print('界面被销毁');
        _controller.dispose();
        return;
      }
      double maxScrollExtent = scroController.position.maxScrollExtent;
      // print(maxScrollExtent);
      // double pixels = scroController.position.pixels;
      if (maxScrollExtent > 0) {
        scroController.animateTo(maxScrollExtent,
            duration: new Duration(milliseconds: (time * 0.5).toInt()),
            curve: Curves.linear);
        Future.delayed(Duration(milliseconds: (time * 0.5).toInt()), () {
          if (scroController.positions.isNotEmpty == true) {
            scroController.animateTo(0,
                duration: new Duration(milliseconds: (time * 0.5).toInt()),
                curve: Curves.linear);
          }
        });
      } else {
        print('不需要移动');
        _controller.play();
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.listenModel.link)
      ..initialize().then((_) {})
      ..setLooping(true).then((_) async{
        if (widget.positionTag == widget.selectTag) {
          print("21331223123");
          _controller.play();
          videoPrepared = true;
        } else {
          videoPrepared = false;
         await _controller.dispose();
        }
        setState(() {});
      });

    this.startTimer();
    
    eventBus.on(keyPlayVideo + widget.positionTag.toString(), (arg) {
      if (arg == widget.positionTag) {
        _controller.play();
        videoPrepared = true;
        _hideActionButton = true;
      } else {
        _controller.pause();
        _hideActionButton = false;
      }
      setState(() {});
    });
  
  }

  @override
  void dispose() async{
    this.scroController.dispose();
    this.timer.cancel();
      await  _controller.dispose(); //释放播放器资源

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object_build");
    return getVideoViewMain();
  }

  Widget getVideoViewMain() {
    return Stack(
      children: <Widget>[
        GestureDetector(
            child: Stack(
              children: <Widget>[
                Container(
                    // margin: EdgeInsets.only(top: ScreenService.topSafeHeight),
                    width: ScreenService.width,
                    // color: Color.fromRGBO(0, 0, 0, 0.1),
                    // color: Colors.red,
                    // height: h, //h/w = sh/sw
                    child: GestureDetector(
                      child: Chewie(
                        controller: ChewieController(
                          videoPlayerController: _controller,
                          aspectRatio: 0.59,
                          autoPlay: true,
                          looping: true,
                          showControls: true,
                          allowFullScreen: false,
                          // 占位图
                          // placeholder: new Container(
                          //   color: Colors.grey,
                          // ),

                          // 是否在 UI 构建的时候就加载视频
                          autoInitialize: !true,

                          // 拖动条样式颜色
                          materialProgressColors: new ChewieProgressColors(
                            playedColor: Colors.red,
                            handleColor: Colors.blue,
                            backgroundColor: Colors.grey,
                            bufferedColor: Colors.lightGreen,
                          ),
                        ),
                      ),
                      onTap: () {
                        print("123124");
                      },
                    )),
                getPauseView()
              ],
            ),
            onTap: () {
              print("123124");
              if (_controller.value.isPlaying) {
                _controller.pause();
                _hideActionButton = false;
              } else {
                _controller.play();
                videoPrepared = true;
                _hideActionButton = true;
              }
              setState(() {});
            }),
        // this.getVideo(),
        // getPreviewImg(),
        // getLikesView(),
        this.getUserAndTitle()
      ],
    );
  }

  getPauseView() {
    return Offstage(
      offstage: _hideActionButton,
      child: Stack(
        children: <Widget>[
          Align(
            child: Container(
                child: Image.asset('assets/images/ic_playing.png'),
                height: 50,
                width: 50),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  Widget getPreviewImg() {
    // var url;
    // HttpController.host.then((onValue) {
    //   url = onValue + widget.previewImgUrl;
    // });
    return Offstage(
        offstage: videoPrepared,
        child: Container(
          color: Colors.black,
          // margin: EdgeInsets.only(top: ScreenService.topSafeHeight),
          child: Image.network(
            widget.listenModel.coverImg,
            // getUrl(widget.previewImgUrl),
            fit: BoxFit.fill,
            width: ScreenService.width,
            height: ScreenService.height,
          ),
        ));
  }

  Widget getMusicTitle() {
    return Container(
      // color: Colors.red,
      // alignment: Alignment.centerLeft,
      child: Text(
        "三根皮带歌曲,哗啦啦啦啦啦啦啦啦啦啦啦",
        maxLines: 1,
        style: TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget getUserAndTitle() {
    return Positioned(
      bottom: 60,
      child: Padding(
        padding: EdgeInsets.only(left: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                "@小恋",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              width: 250,
              child: Text(widget.listenModel.title,
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            Container(
              // color: Colors.red,
              // alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 5),
              width: 200,
              height: 25,
              child: ListView(
                // reverse: true,
                controller: scroController,
                physics: new NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                // children: <Widget>[this.getMusicTitle()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
