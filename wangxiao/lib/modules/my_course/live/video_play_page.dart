import 'dart:io';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/resource_info_model.dart';
import 'package:online_school/modules/my_course/wisdom_study/micro_course_page.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:videoplayer/video_player.dart';
import '../../widgets/ctrl_menu.dart';


///
/// @name VideoPlayPage
/// @description 视频播放页面
/// @author liuca
/// @date 2020-01-11
///
class VideoPlayPage extends StatefulWidget {
  String source;
  var resourceId;
  var courseId;

  var title;

  VideoPlayPage(this.source, {this.resourceId, this.courseId, this.title});

  @override
  _VideoPlayPageState createState() => _VideoPlayPageState(source);
}

class _VideoPlayPageState extends State<VideoPlayPage> with WidgetsBindingObserver, VideoRecordMixin {
  var source;

  ChewieController _chewieController;

  var _videoPlayerControllerWillDispose;

  var _chewieControllerWillDispose;

  _VideoPlayPageState(this.source);

  @override
  void initState() {
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _chewieController.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_chewieController == null) {
      _initPlayer();
    }
  }

  Store<AppState> _getStore() {
    return StoreProvider.of(context);
  }

  Future _initPlayer() async {
    var videoUrl;
    var appInfo = _getStore().state.appInfo;
    if (appInfo.line == null || appInfo.line.lineId == 101) {
      videoUrl = widget.source;
    } else {
      var resultData = await CourseDaoManager.getResourseInfo(widget.resourceId,
          lineId: appInfo.line.lineId);
      var ok = resultData.result &&
          resultData.model != null &&
          resultData.model.code == 1;
      if (ok) {
        var model = resultData.model as ResourceInfoModel;
        videoUrl = model.data.videoUrl;
      } else {
        videoUrl = widget.source;
      }
    }
    // video
    if (controller != null) {
      controller.pause();
      _videoPlayerControllerWillDispose = controller;
    }
    if (_chewieController != null) {
      _chewieControllerWillDispose = _chewieController;
    }
    initVideo(
        url: videoUrl,
        backgroundPlay: appInfo.backgroundPlay ?? false,
        autoPlay: _chewieController != null,
        startAt: await _chewieController?.videoPlayerController?.position);
    setState(() {});
    controller.addListener(() => playerListener(
        resourceId: widget.resourceId, courseId: widget.courseId));
    // initOrientationSettings();
  }

  void initVideo(
      {String url,
      bool autoPlay = false,
      bool backgroundPlay = false,
      Duration startAt}) {
    // video
    debugLog('视频地址: $url');
    controller = VideoPlayerController.network(url ?? widget.source, backgroundPlay: backgroundPlay);
    _chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: 16 / 9,
      autoPlay: autoPlay,
      looping: false,
      startAt: startAt,
      allowFullScreen: true,
      allowMuting: false,
      customControls: MenuMaterialControls(title: widget.title),
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
      ],
      autoInitialize: true,
    );
  }

  @override
  void didUpdateWidget(VideoPlayPage oldWidget) {
    _chewieControllerWillDispose?.dispose();
    _videoPlayerControllerWillDispose?.dispose();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      controller.pause();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return NotificationListener(
        onNotification: (notification) {

          if (notification is ChangeVideoSourceNotification) {
            var lineId = notification.lineId;
            print('收到通知 $lineId');
            _initPlayer();
          } else if (notification is PlayBackgroundNotification) {
            controller.backgroundPlay = notification.backgroundPlay;
          } else {
            print("收到播放通知:$notification");
          }

          return true;
        },
        child: _build(context),
      );
    });
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.title ?? ''),
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: Center(
        child: Home(_chewieController),
      ),
    );
  }
}

class Home extends StatelessWidget {
  ChewieController _chewieController;

  Home(this._chewieController);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_chewieController != null) {
      child = new Chewie(
        controller: _chewieController,
      );
    } else {
      child = Text(
        '视频地址不存在',
        style: TextStyle(color: Colors.white),
      );
    }
    return Container(
      color: Colors.black,
      child: Center(
        child: child,
      ),
    );
  }
}

///
/// @name 视频播放接口基类
/// @description
/// @author liuca
/// @date 2020-01-11
///
mixin VideoRecordMixin<T extends StatefulWidget> on State<T> {
  VideoPlayerController controller;
  VoidCallback listener;
  int logId = 0;
  int lastPos = -1;

  Future reportVideoProgress(int pos, int dur, {resId, courseId}) async {
    var reportVideo = await AnalysisDao.reportVideo(
        resId: resId,
        refId: courseId,
        logId: logId,
        videoDuration: dur,
        isViewEnd: pos == dur ? 1 : 0);
    if (logId == 0 &&
        reportVideo.result &&
        reportVideo.model != null &&
        reportVideo.model.code == 1 &&
        reportVideo.model.data != null) {
      logId = reportVideo.model.data.logId;
    }
  }

  playerListener({resourceId, courseId}) async {
    if (!mounted) {
      return;
    }

    print("当前播放是否有错误:${this.controller.value.hasError}");
    print("当前播放错误信息:${this.controller.value.errorDescription}");

    if (resourceId != null && courseId != null) {
      if (controller.value.position == null ||
          controller.value.duration == null) {
        return;
      }
      var pos = controller.value.position.inSeconds;
      var dur = controller.value.duration.inSeconds;
      if (pos <= lastPos) {
        return;
      }
      lastPos = pos;
      // logD(dur);
      // logD(pos);
      if (pos % 5 == 0) {
        await reportVideoProgress(pos, dur,
            resId: resourceId, courseId: courseId);
      }
    }
    setState(() {});
  }
}
