import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/video_dao.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/live_schedule_model.dart';
import 'package:online_school/model/self_study_record.dart';
import 'package:online_school/model/video_url_model.dart';
import 'package:online_school/modules/my_course/live/live_teaching_material_list_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/scroll_to_index/scroll_to_index.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/modules/personal/settings/wifi_only_check_widget.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/common/tools/date_utils.dart';
import 'package:online_school/common/tools/eye_protection_timer.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/screen_utils.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:online_school/common/tools/task_utils.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/common_webview.dart';
import 'video_play_page.dart';
import '../../widgets/common_webview_page.dart';
import '../../widgets/microcourse_webview.dart';
import '../../widgets/pdf_page.dart';


///
/// @name LiveCourseList
/// @description 直播课列表页面
/// @author liuca
/// @date 2020-01-10
///
class LiveCourseList extends StatefulWidget {
  var courseId;

  int i;
  int gradeId;
  int subjectId;
  AsyncMemoizer memoizer = AsyncMemoizer();

  ScrollController scrollController;
  LiveListRecord record;

  bool useRecord;
  bool previewMode;

  LiveCourseList(this.i, this.memoizer,
      {this.courseId,
      this.gradeId,
      this.subjectId,
      this.scrollController,
      this.previewMode = false,
      this.record});

  @override
  _LiveCourseListState createState() => _LiveCourseListState();
}

class _LiveCourseListState extends State<LiveCourseList> with WifiOnlyCheckWidget {
  Map<int, dynamic> courseStatus = <int, dynamic>{};
  Map<String, int> idIndex = <String, int>{};
  DataEntity detailData;

  AutoScrollController controller;
  AutoScrollController outer_controller;
  LiveListRecord record;

  bool created = false;

  int get lastResId => record.id;

  List<ListEntity> get courses => detailData?.list;
  AsyncMemoizer _memoizer;

  @override
  void initState() {
    record = widget.record != null
        ? widget.record
        : LiveListRecord(
            type: 1,
            id: -1,
            subjectId: widget.subjectId,
            gradeId: widget.gradeId);

    outer_controller = widget.scrollController;
    controller = AutoScrollController();
    _memoizer = widget.memoizer;
    UMengAnalytics.beginPageView("大师直播");
    super.initState();
  }

  @override
  void dispose() {
    _memoizer = null;
    UMengAnalytics.endPageView("大师直播");
    super.dispose();
  }

  void saveRecord() {
    if (widget.previewMode) return;
    if (record != null &&
        record.id != null &&
        record.type != null &&
        record.title.isNotEmpty) {
      debugLog(record.toString(), tag: 'save');
      SharedPrefsUtils.put('record', record.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(MyColors.background),
      child: detailData != null
          ? _buildWidget()
          : FutureBuilder(
              builder: _builder,
              future: _getDetail(),
            ),
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: LoadingListWidget(),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        var liveDetailModel = snapshot.data.model as LiveScheduleModel;
        detailData = liveDetailModel?.data;
        if (detailData == null) {
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png', message: '没有数据');
        }
        if (liveDetailModel.code == 1 && detailData != null) {
          return _buildWidget();
        }
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png',
            message: '${liveDetailModel.msg}');
      // Text('Error: ${liveDetailModel.msg}');
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  _initScrollToIndex() {
    var scrollToViewport = () => SchedulerBinding.instance.endOfFrame.then((d) {
          // Future.delayed(Duration(seconds: 3), () {
          // logD('++++++++$lastResId');
          // outer_controller.animateTo(120,
          //     duration: Duration(seconds: 1), curve: Curves.ease);
          controller
              .scrollToIndex(record.id,
                  duration: Duration(seconds: 1),
                  preferPosition: AutoScrollPosition.middle)
              .then((_) {
            controller.highlight(record.id,
                highlightDuration: Duration(seconds: 3));
          });
          // });
        });
    record != null &&
            courses.indexWhere((item) => item.courseId == record.id) != -1
        ? scrollToViewport()
        : null;
  }

  buildHeader() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              child: Container(
                width: ScreenUtil.getInstance().setWidth(156),
                height: ScreenUtil.getInstance().setHeight(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)), //设置圆角
                  image: DecorationImage(
                      image: AssetImage('static/images/live_card.png')),
                ),
                child: Text('班级群', style: textStyleLargeWhiteMedium),
              ),
              onTap: _onPressClassGroup),
          // const SizedBox(width: 16),
          InkWell(
              child: Container(
                width: ScreenUtil.getInstance().setWidth(156),
                height: ScreenUtil.getInstance().setHeight(50),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)), //设置圆角
                  image: DecorationImage(
                      image: AssetImage('static/images/live_card.png')),
                ),
                child: Text('资料包', style: textStyleLargeWhiteMedium),
              ),
              onTap: () {
                var courseIds = _loadCourseIds();
                print("courseIds:$courseIds");
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return LiveMaterialListPage(courseIds);
                }));
              }),
        ]);
  }

  ///
  /// @name _loadCourseIds
  /// @description 生成course id
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-13
  ///
  _loadCourseIds() {
    if (detailData.list != null && detailData.list.length > 0) {
      String courseIds = "";
      detailData.list.forEach((ListEntity value){
        courseIds = courseIds + "," + "${value.liveCourseId}";
      });
      courseIds = courseIds.substring(1);
      return courseIds;
    } else {
      return null;
    }
  }

  void _onPressClassGroup() {
    if (detailData.classCode == null) {
      Fluttertoast.showToast(msg: '没有班级二维码');
      return;
    }
    showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('二维码'),
          contentPadding: EdgeInsets.all(0),
          content: new SizedBox(
            height: 150,
            child: Image.network(detailData.classCode),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('保存'),
              onPressed: () async {
                await _onImageSaveButtonPressed(detailData.classCode);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onImageSaveButtonPressed(qrurl) async {
    var response = await http.get(qrurl);
    debugPrint(response.statusCode.toString());
    var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
    var savedFile = File.fromUri(Uri.file(filePath));
    Fluttertoast.showToast(msg: '图片已保存至$savedFile');
  }

  Widget _buildWidget() {
    if (!this.created) {
      this.created = true;
      _initScrollToIndex();
    }
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        if (widget.i != 2)
          Container(
              child: buildHeader(),
              padding: EdgeInsets.symmetric(horizontal: 16)),
        Flexible(
            child: ListView.builder(
          controller: controller,
          padding: EdgeInsets.only(bottom: 16),
          // physics: NeverScrollableScrollPhysics(),
          // shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) =>
              buildItem(context, index, controller),
          itemCount: courses.length,
        ))
      ],
    );
  }

  Widget buildItem(
      BuildContext context, int index, ScrollController controller) {
    // Store<AllState> store = StoreProvider.of<AllState>(context);
    var item = courses.elementAt(index);
    return AutoScrollTag(
        key: ValueKey(index),
        controller: controller,
        index: item.courseId,
        highlightColor: Color(MyColors.primaryValue).withOpacity(1),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 16, top: 12, right: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(MyColors.shadow),
                        offset: Offset(0, 2),
                        blurRadius: 10.0,
                        spreadRadius: 2.0)
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.courseName, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 19 : 17, color: Color(MyColors.title_black), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(item.startTime.toString(), style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 13 : 11, color: Color(MyColors.txt_time)),),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        ClipOval(
                            child: Container(
                          color: Colors.black12,
                          child: item.teacherPic == null
                              ? Image.asset('static/images/avatar.png',
                                  width: 28, height: 28)
                              : Image.network(item.teacherPic,
                                  width: 38, height: 38),
                        )),
                        const SizedBox(width: 12),
                        Text(item.showName)
                      ],
                    ),
                    if ((!widget.previewMode ||
                            (widget.previewMode && index == 0)) &&
                        item.stateId == 2)
                      ..._buildBottomRow(item, index),
                  ],
                ),
              ),
            ),
            if (widget.previewMode && index != 0)
              Positioned(
                bottom: 16,
                right: 32,
                child: _lockTag(),
              ),
            if ((!widget.previewMode || (widget.previewMode && index == 0)) &&
                item.stateId != 2)
              Positioned(
                bottom: 20,
                right: 30,
                child: InkWell(
                  child: Opacity(
                    child: Container(
                      height: 24,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8585),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12), //设置圆角
                        ),
                      ),
                      child: Text(item.stateId == 1 ? '进入直播' : '未开始',
                          style: textStyle12WhiteBold),
                    ),
                    opacity: item.stateId == 1 ? 1.0 : 0.4,
                  ),
                  onTap: () {
                    if (item.stateId == 1) {
                      record.id = item.courseId;
                      record.title = item.courseName;
                      record.courseId = item.liveCourseId;
                      record.subjectId = widget.subjectId;
                      record.gradeId = widget.gradeId;
                      record.tabIndex = widget.i;
                      saveRecord();

                      var token = NetworkManager.getAuthorization();
                      var url =
                          '${APIConst.liveHost}?utoken=$token&rcourseid=${item.liveCourseId}&ocourseId=${item.courseId}&roomid=${item.partnerRoomId}';
                      // 需求：护眼模式，直播不计时
                      EyeProtectionTimer.pauseTimer();
                      if (Platform.isAndroid) {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CommonWebview(
                                      initialUrl: url,
                                      title: '直播',
                                    )))
                            .then((_) =>
                                EyeProtectionTimer.startEyeProtectionTimer(
                                    context));
                      } else {
                        // fix ios 12.1 视频不能退出全屏问题
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (BuildContext context) => WebviewPage(
                                      url,
                                      title: '直播',
                                    )))
                            .then((_) =>
                                EyeProtectionTimer.startEyeProtectionTimer(
                                    context));
                      }
                    } else {
                      Fluttertoast.showToast(msg: '暂未开始');
                    }
                  },
                ),
              ),
            if ((!widget.previewMode || (widget.previewMode && index == 0)) &&
                item.stateId == 1)
              Positioned(
                  top: 28,
                  right: 16,
                  child: Container(
                    width: 40,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFFFDE63), Color(0xFFFF9C78)]),
                      color: Color(MyColors.primaryValue),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(9),
                          bottomLeft: Radius.circular(9),
                          topRight: Radius.circular(0),
                          bottomRight: Radius.circular(0)),
                    ),
                    child: Text('Live', style: textStyle10White),
                  )),
          ],
        ));
  }

  Future _onTapPlayback(ListEntity course) async {
    record.id = course.courseId;
    record.title = course.courseName;
    record.courseId = course.liveCourseId;
    record.subjectId = widget.subjectId;
    record.gradeId = widget.gradeId;
    record.tabIndex = widget.i;
    saveRecord();
    if (course.hdResourceId < 1) {
      var token = NetworkManager.getAuthorization();
      var url =
          '${APIConst.backHost}?token=$token&rcourseid=${course.liveCourseId}&ocourseId=${course.courseId}&roomid=${course.partnerRoomId}';
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => WebviewPage(
                url,
                title: '直播回放',
              )));
      return;
    }
    var videoUrl = await VideoDao.getVideoUrl(course.courseId.toString());
    var model = videoUrl.model as VideoUrlModel;
    if (model.code != 1) {
      Fluttertoast.showToast(msg: model.msg);
      return;
    }

    // local first
    var mp4Url = model.data.videoUrl;
    var videoPath = await getLocalVideoByUrl(mp4Url);
    if (videoPath != null && File(videoPath).existsSync()) {
      Fluttertoast.showToast(
          msg: '视频已下载，播放不消耗流量', gravity: ToastGravity.CENTER);
    } else {
      videoPath = null;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => VideoPlayPage(
            videoPath ?? model.data.playVideoUrl ?? mp4Url,
            resourceId: model.data.resourceId,
            courseId: model.data.onlineCourseId,
            title: model.data.onlineCourseName)));
    return;
  }

  _getDetail() => _memoizer.runOnce(() => CourseDaoManager.liveScheduleNew(
      subjectId: widget.subjectId, gradeId: widget.gradeId, typeId: widget.i));

  Future _onTapDownload(ListEntity course, int index) async {
    if (course.hdResourceId < 1) {
      Fluttertoast.showToast(msg: '该视频不能下载');
      return;
    }
    var videoUrl = await VideoDao.getVideoUrl(course.courseId.toString());
    var model = videoUrl.model as VideoUrlModel;
    if (model != null && model.code == 1) {
      var url = model.data.videoUrl;
      download(model.data.videoUrl, model.data.imageUrl, course.courseName, index);
    } else if (model != null) {
      Fluttertoast.showToast(msg: model.msg);
    } else {
      Fluttertoast.showToast(msg: '获取下载地址失败');
    }
  }

  getLocalVideoByUrl(String url) async {
    var resId = getMp4UrlId(Uri.parse(url));
    List<DownloadTask> tasks = await FlutterDownloader.loadTasksWithRawQuery(
        query: "SELECT * FROM task WHERE url LIKE '%$resId%.mp4'");
    if (tasks != null && tasks.length > 0) {
      var task = tasks.single;
      var status = task.status;
      if (status == DownloadTaskStatus.complete) {
        var videoPath = p.join(task.savedDir, task.filename);
        return videoPath;
      }
    }
    return null;
  }

  Future download(String url, String imageUrl, String resName, int index) async {
    url = url.replaceFirst('http:', 'https:');
    // 1. 获取权限
    var _permissisonReady = await _checkPermission();
    if (!_permissisonReady) {
      Fluttertoast.showToast(msg: '权限不足');
      return;
    }

    var retry = (taskId) {
      FlutterDownloader.retry(taskId: taskId);
      _addTaskCallback(taskId, index);
      Fluttertoast.showToast(msg: '视频下载重试');
    };

    var resume = (taskId, progress) async {
      var newId = await FlutterDownloader.resume(taskId: taskId);
      idIndex[newId] = index;
      _addTaskCallback(taskId, index, lastProgress: progress);
      Fluttertoast.showToast(msg: '视频下载恢复');
    };

    // 2. 检查是否已经下载过该资源
    // 是否已经下载？
    // 已经下载成功，不再下载
    // 进行中，不再下载
    // 下载失败或其他，重新下载
    var resId = getMp4UrlId(Uri.parse(url));
    List<DownloadTask> tasks = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE url LIKE '%$resId%.mp4'");
    if (tasks != null && tasks.length > 0) {
      var task = tasks.single;
      var status = task.status;
      idIndex[task.taskId] = index;
      if (status == DownloadTaskStatus.complete) {
        // 下载已完成
        Fluttertoast.showToast(msg: '该视频已下载');
        courseStatus[index] = '已下载';
        return;
      } else if (status == DownloadTaskStatus.enqueued ||
          status == DownloadTaskStatus.running) {
        var inProgress = courseStatus.containsKey(index);
        if (inProgress) {
          FlutterDownloader.pause(taskId: task.taskId);
          Fluttertoast.showToast(msg: '下载已暂停');
          // FlutterDownloader.registerCallback(null);
        } else {
          Fluttertoast.showToast(msg: '当前视频已在下载列表，将继续下载');
          _addTaskCallback(task.taskId, index, lastProgress: task.progress);
        }
      } else if (status == DownloadTaskStatus.paused) {
        checkWifiOnly(context, resume, [task.taskId, task.progress]);
      } else {
        checkWifiOnly(context, retry, [task.taskId]);
      }
      if (this.mounted) {
        setState(() {});
      }
      return;
    }

    // 首次下载一个资源
    await checkWifiOnly(context, _firstDownload, [resName, resId, url, index, imageUrl]);
  }

  Future _firstDownload(String resName, resId, String url, int index, String imageUrl) async {
    // 获取地址
    var _localPath = (await _findLocalPath()) + '/Videos';
    final savedDir = Directory(_localPath);
    bool hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      savedDir.createSync();
    }

    // 视频文件名规则，`${base64(resId)}-${base64(resName)}.mp4`
    // 目的，id为了定位唯一的资源。resName为了下载历史列表中资源的title
    var base64encodeFrom = base64Encode(utf8.encode('直播回放'));
    var base64encodeTitle = base64Encode(utf8.encode(resName));
    var base64encodeId = base64Encode(utf8.encode(resId.toString()));
    var suffix = url.split('.').last;
    var filename = '$base64encodeFrom-$base64encodeId-$base64encodeTitle.$suffix';

    // 下载
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      fileName: filename,
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    idIndex[taskId] = index;

    // 下载封面图
    var imgSuffix = imageUrl.split('.').last;
    var imgFilename = '$base64encodeFrom-$base64encodeId-$base64encodeTitle.$imgSuffix';
    Dio().download(imageUrl, _localPath + '/' + imgFilename);
    // final taskIdImg = await FlutterDownloader.enqueue(
    //   url: imageUrl,
    //   fileName: imgFilename,
    //   savedDir: _localPath,
    //   showNotification:
    //       false, // show download progress in status bar (for Android)
    //   openFileFromNotification: true,
    // );

    // 设置����载状态和进度
    _addTaskCallback(taskId, index);
  }

  void _addTaskCallback(String taskId, int index, {int lastProgress = 0}) {
    courseStatus[index] = '$lastProgress%';
    FlutterDownloader.registerCallback((id, status, progress) {
      var index = idIndex[id];
      debugLog('$index - ${status.value} - $progress - $id');
      courseStatus[index] = progress == 100 ? '已下载' : '$progress%';
      if (this.mounted) {
        setState(() {});
      }
    });
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

  String _formatTime(ListEntity course) {
    return DateUtils.formateDateMdEhm(DateTime.parse(course.startTime));
  }

  _buildBottomRow(ListEntity item, int index) {
    print("workStatus : ${item.workStatus}");
    return <Widget>[
      const SizedBox(height: 8),
      Container(height: 0.5, color: Color(0xFFD8D8D8)),
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // const SizedBox(width: 25),
          if (item.workStatus >= 1)
            Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(MyIcons.HOMEWORK, size: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2)),
                      const SizedBox(width: 4),
                      Text('作业', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2),),),
                    ],
                  ),
                ),
                onTap: (){
                  if (item.workStatus ==1) {
                    _onTapHomework(item);
                  } else {
                    Fluttertoast.showToast(msg: "作业未开始",gravity: ToastGravity.CENTER);
                  }
                },
              ),
            ),
          if (item.workStatus >= 1)
            Container(width: 0.5, height: 20, color: Color(0xFFD8D8D8)),
          if (item.hdResourceId > 0)
            Expanded(
              child: InkWell(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(MyIcons.NEW_DOWNLOAD,
                          size: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2),),
                      const SizedBox(width: 2),
                      Text(courseStatus[index] ?? '下载', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2),),)
                    ],
                  ),
                ),
                onTap: () => _onTapDownload(item, index),
              ),
            ),
          if (item.hdResourceId > 0)
            Container(width: 0.5, height: 20, color: Color(0xFFD8D8D8)),
          // const SizedBox(width: 25),
          Expanded(
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(MyIcons.LIVE,
                        size: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2),),
                    const SizedBox(width: 4),
                    Text('回放', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 14, color: Color(MyColors.shadow2),),)
                  ],
                ),
              ),
              onTap: () => _onTapPlayback(item),
            ),
          ),
        ],
      ),
    ];
  }

  _onTapHomework(ListEntity item) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      var token = NetworkManager.getAuthorization();
      var url = '${APIConst.practiceHost}/homework.html?token=$token&livecourseid=${item.courseId}';
      return MicrocourseWebPage(
        initialUrl: url,
        resourceId: item.courseId,
        resourceName: item.courseName,
      );
    }));
  }
}

class PauseTimerNotification extends Notification {
  bool pause;

  PauseTimerNotification(this.pause);
}

Widget _lockTag() {
  return Icon(Icons.lock, size: 20, color: Color(0xFFD5DAEB));
}
