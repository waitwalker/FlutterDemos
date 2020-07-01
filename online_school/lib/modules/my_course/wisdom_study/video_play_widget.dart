import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/modules/personal/settings/wifi_only_check_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/task_utils.dart';
import 'package:online_school/common/tools/time_utils.dart';
import 'package:chewie/chewie.dart';
import 'package:chewie/src/chewie_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

///
/// @name VideoPlayWidget
/// @description 视频播放组件
/// @author liuca
/// @date 2020-01-11
///
class VideoPlayWidget extends StatefulWidget {
  ChewieController chewieController;
  String title;
  String from;

  VideoInfo videoInfo;

  VideoPlayWidget(
      {@required this.chewieController,
      @required this.title,
      this.videoInfo,
      this.from})
      : assert(chewieController != null);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayWidgetState();
  }
}

class _VideoPlayWidgetState extends State<VideoPlayWidget> with WifiOnlyCheckWidget {
  VideoPlayerController get _videoPlayerController1 =>
      widget.chewieController.videoPlayerController;
  VoidCallback listener;
  int logId = 0;
  int lastPos = -1;

  @override
  void initState() {
    super.initState();
    _videoPlayerController1.addListener(() {
      var initialized = _videoPlayerController1.value.initialized;
      if (initialized) {
        setState(() {});
      }
    });

    listener = () async {
      if (!mounted) {
        return;
      }
      if (widget.videoInfo.resId != null && widget.videoInfo.courseId != null) {
        if (_videoPlayerController1.value.position == null ||
            _videoPlayerController1.value.duration == null) {
          return;
        }
        var pos = _videoPlayerController1.value.position.inSeconds;
        var dur = _videoPlayerController1.value.duration.inSeconds;
        if (pos <= lastPos) {
          return;
        }
        lastPos = pos;
        debugLog(dur);
        debugLog(pos);
        if (pos % 5 == 0) {
          await reportVideoProgress(pos, dur);
        }
      }
    };
    _videoPlayerController1.addListener(listener);
  }

  Future reportVideoProgress(int pos, int dur) async {
    var reportVideo = await AnalysisDao.reportVideo(
        resId: widget.videoInfo.resId,
        refId: widget.videoInfo.courseId,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(MyColors.choosedLine),
      child: Column(
        children: <Widget>[
          Chewie(
            controller: widget.chewieController,
          ),
          Divider(height: 0.5),
          InkWell(
            child: Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(widget.title ?? '',
                              style: textStyleContent333,
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(
                            '微课  |  ${toHMS(widget.chewieController.videoPlayerController.value.duration?.inMicroseconds ?? 0)}',
                            style: textStyleSub999),
                      ],
                    ),
                    InkWell(
                      child: Icon(MyIcons.DOWNLOAD, size: 26),
                      onTap: download,
                    ),
                  ],
                )),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  download() async {
    String videoUrl = widget.videoInfo?.videoUrl;
    String videoDownloadUrl = widget.videoInfo?.videoDownloadUrl;
    String imageUrl = widget.videoInfo?.imageUrl;
    String resName = widget.videoInfo?.resName;
    if (widget.videoInfo == null) {
      Fluttertoast.showToast(msg: 'video info null warning');
      videoUrl = widget.chewieController.videoPlayerController.dataSource;
    }
    if (videoUrl == null || videoUrl.isEmpty) {
      Fluttertoast.showToast(msg: 'video url is null err');
      return;
    }
    if (!videoUrl.endsWith('.mp4') && videoDownloadUrl == null) {
      Fluttertoast.showToast(msg: '获取资源失败');
    } else
      await _download(videoDownloadUrl ?? videoUrl, imageUrl, resName);
  }

  Future _download(String url, String imageUrl, String resName) async {
    // 1. 获取权限
    var _permissisonReady = await _checkPermission();
    if (!_permissisonReady) {
      Fluttertoast.showToast(msg: '权限不足');
      return;
    }

    var retry = (taskId) {
      FlutterDownloader.retry(taskId: taskId);
      Fluttertoast.showToast(msg: '视频下载重试');
    };

    var resume = (taskId, progress) async {
      var newId = await FlutterDownloader.resume(taskId: taskId);
      Fluttertoast.showToast(msg: '视频下载恢复');
    };

    // 2. 检查是否已经下载过该资源
    // 是否已经下载？
    // 已经下载成功，不再下载
    // 进行中，不再下载
    // 下载失败或其他，重新下载
    var resId = getMp4UrlId(Uri.parse(url));
    List<DownloadTask> tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE url LIKE '%$resId%.mp4'");
    if (tasks != null && tasks.length > 0) {
      var task = tasks.single;
      var status = task.status;
      if (status == DownloadTaskStatus.complete) {
        // 下载已完成
        Fluttertoast.showToast(msg: '该视频已下载');
        return;
      } else if (status == DownloadTaskStatus.enqueued ||
          status == DownloadTaskStatus.running) {
        Fluttertoast.showToast(msg: '视频下载中');
      } else if (status == DownloadTaskStatus.paused) {
        checkWifiOnly(context, resume, [task.taskId, task.progress]);
      } else {
        checkWifiOnly(context, retry, [task.taskId]);
      }
      return;
    }

    // 首次下载一个资源
    await checkWifiOnly(
        context, _firstDownload, [resName, resId, url, imageUrl]);
  }

  Future _firstDownload(
      String resName, resId, String url, String imageUrl) async {
    var _localPath = (await _findLocalPath()) + '/Videos';
    final savedDir = Directory(_localPath);
    bool hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      savedDir.createSync();
    }

    // 视频文件名规则，`${base64(resId)}-${base64(resName)}.mp4`
    // 目的，id为了定位唯一的资源。resName为了下载历史列表中资源的title, resName为空则默认为resId
    var base64encodeFrom = base64Encode(utf8.encode(widget.from ?? '未知'));
    var suffix = url.split('.').last;
    var base64encodeTitle = base64Encode(utf8.encode(resName ?? resId));
    var base64encodeId = base64Encode(utf8.encode(resId.toString()));
    var filename =
        '$base64encodeFrom-$base64encodeId-$base64encodeTitle.$suffix';

    // 下载
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      fileName: filename,
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );

    // 下载封面图
    if (imageUrl != null && Uri.parse(imageUrl).scheme.startsWith('http')) {
      var imgSuffix = imageUrl.split('.').last;
      var imgFilename =
          '$base64encodeFrom-$base64encodeId-$base64encodeTitle.$imgSuffix';
      await FlutterDownloader.enqueue(
        url: imageUrl,
        fileName: imgFilename,
        savedDir: _localPath,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification: true,
      );
    }
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
}

class VideoInfo {
  final String videoUrl;
  final String videoDownloadUrl;
  final String imageUrl;
  final String resName;
  final String resId;
  final String courseId;

  const VideoInfo(
      {@required this.videoUrl,
      this.imageUrl,
      this.resName,
      this.resId,
      this.courseId,
      this.videoDownloadUrl});
}
