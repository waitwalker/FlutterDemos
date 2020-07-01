import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/modules/personal/settings/wifi_only_check_widget.dart';
import 'package:online_school/modules/widgets/pdf_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../widgets/local_video_play_widget.dart';


///
/// @name MyDownloadPage
/// @description 我的下载
/// @author liuca
/// @date 2020-01-10
///
class MyDownloadPage extends StatefulWidget {
  @override
  _MyDownloadPageState createState() => _MyDownloadPageState();
}

class _MyDownloadPageState extends State<MyDownloadPage> with WifiOnlyCheckWidget {
  List<DownloadTask> tasks;

  Timer _timer;

  List<FileSystemEntity> pdfFiles;

  @override
  void initState() {
    initPdf();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimerSafe();
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Widget build(BuildContext context) {
    var length = (tasks?.length ?? 0) + (pdfFiles?.length ?? 0);
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(MTTLocalization.of(context).currentLocalized.my_download_page_navigator_title),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: length == 0
          ? EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png',
              message: '没有数据',)
          : Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemBuilder: _buildItem,
                itemCount: length,)),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index < tasks.length) {
      return _buildVideoItem(index);
    } else {
      return _buildPdfItem(index - tasks.length);
    }
  }

  InkWell _buildVideoItem(int index) {
    DownloadTask task = tasks.elementAt(index);
    var dir = task.savedDir;
    var name = task.filename;
    var path = p.join(dir, name);
    File f = File(path);
    String flen = f.existsSync()
        ? (f.lengthSync() / (1024 * 1024)).toStringAsFixed(1)
        : '0';

    var namePart = name.split('.').first;
    var split = namePart.split('-');
    var courseName = utf8.decode(base64Decode(split.last));
    var courseFrom = '未知';
    if (split.length == 3) {
      courseFrom = utf8.decode(base64Decode(split.first));
    }
    var imageUrl = p.setExtension(path, '.jpg');
    var imageFile = File(imageUrl);
    Image image;
    if (imageFile.existsSync()) {
      image = Image.file(imageFile, width: 104, height: 69);
    } else {
      image = Image.asset("static/images/logo.png",
          width: 104, height: 69, fit: BoxFit.fitWidth);
    }
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          Padding(
              padding: EdgeInsets.only(
            left: 12,
          )),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 2, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(courseName, style: textStyleContent333),
                  Padding(padding: EdgeInsets.only(top: 0)),
                  Text(courseFrom, style: textStyleSub999),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${flen}M', style: textStyleSub999),
                      InkWell(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          child: Text(_getTaskStatus(task.status),
                              style: textStyle12666),
                          decoration: new BoxDecoration(
                            border:
                                Border.all(color: Color(MyColors.background)),
                            borderRadius: const BorderRadius.all(
                                const Radius.circular(4.0)),
                          ),
                        ),
                        onTap: () => _onTapBtn(task),
                      ),
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () => _play(task, path),
      onLongPress: () => _onDeleteTask(task),
    );
  }

  // DownloadTaskStatus 重写了 == ，不能使用switch
  String _getTaskStatus(DownloadTaskStatus status) {
    String s;
    if (status == DownloadTaskStatus.enqueued ||
        status == DownloadTaskStatus.running) {
      s = '下载中';
    } else if (status == DownloadTaskStatus.complete) {
      s = '完成';
    } else if (status == DownloadTaskStatus.failed) {
      s = '失败';
    } else if (status == DownloadTaskStatus.canceled) {
      s = '取消';
    } else if (status == DownloadTaskStatus.paused) {
      s = '暂停';
    } else {
      s = '错误';
    }
    return s;
  }

  void _play(DownloadTask task, String path) {
    print(path);
    var complete = task.status == DownloadTaskStatus.complete;
    if (complete) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return LocalVideoPlayWidget(path);
      }));
    }
  }

  Future initData() async {
    tasks = await FlutterDownloader.loadTasksWithRawQuery(query: "SELECT * FROM task WHERE url LIKE '%.mp4'");

    // tasks = tasks.where((t) => valid(t)).toList();

    // 文件不存在的任务，清除
    // List<DownloadTask> invalidTasks = tasks.where((t) => !valid(t)).toList();
    // invalidTasks.forEach((t) async {
    //   var mp4FileName = t.filename;
    //   var imgFileName = mp4FileName.replaceAll('.mp4', '.png');
    //   var imgTasks = await FlutterDownloader.loadTasksWithRawQuery(
    //       query: 'SELECT * FROM task WHERE file_name = $imgFileName');
    //   // 删除视频任务
    //   FlutterDownloader.remove(taskId: t.taskId, shouldDeleteContent: true);
    //   // 删除封面图任务
    //   if (imgTasks != null && imgTasks.isNotEmpty) {
    //     FlutterDownloader.remove(
    //         taskId: imgTasks[0].taskId, shouldDeleteContent: true);
    //   }
    // });

    var len = tasks?.where((t) => _taskInProgress(t.status))?.length ?? 0;
    if (len > 0 && (_timer == null || !_timer.isActive)) {
      _startTimer();
      // } else {
      // _cancelTimerSafe();
    }

    setState(() {});
  }

  bool _taskInProgress(DownloadTaskStatus status) {
    return status == DownloadTaskStatus.enqueued ||
        status == DownloadTaskStatus.running;
  }

  _onTapBtn(DownloadTask task) async {
    var status = task.status;
    if (status == DownloadTaskStatus.enqueued ||
        status == DownloadTaskStatus.running) {
      FlutterDownloader.pause(taskId: task.taskId);
    } else if (status == DownloadTaskStatus.paused) {
      checkWifiOnly(context, FlutterDownloader.resume, null,
          {Symbol('taskId'): task.taskId});
    } else {
      // await FlutterDownloader.remove(
      //     taskId: task.taskId, shouldDeleteContent: true);
    }
    initData();
  }

  valid(DownloadTask task) {
    var dir = task.savedDir;
    var name = task.filename;
    var path = p.join(dir, name);
    File f = File(path);

    if (!f.existsSync()) {
      return false;
    }

    var namePart = name.split('.').first;
    var valid = namePart.split('-')?.length == 2;

    if (!valid) {
      return false;
    }

    String courseName;
    try {
      var courseId =
          String.fromCharCodes(base64Decode(namePart.split('-').first));
      courseName = utf8.decode(base64Decode(namePart.split('-').last));
    } on Exception catch (e) {
      return false;
    }
    if (courseName == null || courseName.isEmpty) {
      return false;
    }
    if (isImage(p.extension(name))) {
      return false;
    }
    return true;
  }

  bool isImage(String ext) {
    String formedExt = ext.replaceAll('.', '').toLowerCase();
    if (formedExt == 'jpg' || formedExt == 'jpeg' || formedExt == 'png') {
      return true;
    }
    return false;
  }

  void _timerCallback(Timer timer) {
    initData();
  }

  void _cancelTimerSafe() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  void _startTimer() {
    _cancelTimerSafe();

    _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
  }

  _onDeleteTask(DownloadTask task) async {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Text('确定删除视频？'),
          actions: <Widget>[
            new FlatButton(
              child: new Text('确定'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            new FlatButton(
              child: new Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((del) async {
      if (del) {
        await FlutterDownloader.remove(
            taskId: task.taskId, shouldDeleteContent: true);
        initData();
      }
    });
  }

  Future<void> initPdf() async {
    final dir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    var pdf = Directory(p.join(dir.path, 'pdf'));
    if (pdf.existsSync()) {
      pdfFiles = pdf.listSync();
      pdfFiles.sort((FileSystemEntity a,FileSystemEntity b) => b.path.compareTo(a.path));
      setState(() {

      });
      //pdfs = pdf.listSync();
    }
  }

  Widget _buildPdfItem(int i) {
    var image = Image.asset('static/images/pdf_cover.png',
        width: 104, height: 69, fit: BoxFit.fitWidth);
    var pdf = pdfFiles.elementAt(i).path;
    var basename = p.basename(pdf);
    bool isPDF = basename.contains(".pdf");
    print("文件是否PDF:$isPDF");
    File f = File(pdf);
    String flen = f.existsSync()
        ? (f.lengthSync() / (1024 * 1024)).toStringAsFixed(1)
        : '0';
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          Padding(
              padding: EdgeInsets.only(
            left: 12,
          )),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 2, right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(basename, style: textStyleContent333),
                  Padding(padding: EdgeInsets.only(top: 0)),
                  Padding(padding: EdgeInsets.only(top: 5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${flen}M', style: textStyleSub999),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Text('完成', style: textStyle12666),
                        decoration: new BoxDecoration(
                          border: Border.all(color: Color(MyColors.background)),
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(4.0)),
                        ),
                      ),
                    ],
                  ),
                  Divider()
                ],
              ),
            ),
          )
        ],
      ),
      onTap: () => _playPdf(pdf, isPDF),
      onLongPress: () => _onDeletePdf(pdf),
    );
  }

  _playPdf(String path, bool isPDF) async {
    if (isPDF) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return PDFPage(
          path,
          title: p.basename(path),
        );
      }));
    } else {
      final result = await OpenFile.open(path);
      print("文件打开结果:$result");
    }
  }

  ///
  /// @name _onDeletePdf
  /// @description 删除PDF回调
  /// @parameters 
  /// @return 
  /// @author liuca
  /// @date 2020-01-13
  ///
  _onDeletePdf(String pdf) async{
    File file = File(pdf);
    bool exist = await file.exists();
    if (exist) {
      showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('确定删除文件？'),
            actions: <Widget>[
              FlatButton(
                child: Text('确定'),
                onPressed: () {
                  file.deleteSync();
                  initPdf();
                  Navigator.of(context).pop(true);
                  setState(() {

                  });
                },
              ),
              FlatButton(
                child: Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      ).then((del) async {
      });
    } else {
      Fluttertoast.showToast(msg: "文件不存在!",gravity: ToastGravity.CENTER);
    }
  }
}
