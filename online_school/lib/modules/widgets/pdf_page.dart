import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/doc_timer.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// @name PDFPage
/// @description PDF页面
/// @author liuca
/// @date 2020-01-10
///
class PDFPage extends StatefulWidget {
  String _uri;
  String title;
  String resId;

  // 来自知识导学
  bool fromZSDX = false;

  PDFPage(this._uri, {Key key, this.title, this.fromZSDX = false, this.resId})
      : assert(!(fromZSDX && resId == null)),
        super(key: key);

  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  String path;
  Uri get uri => Uri.parse(widget._uri);
  String get scheme => uri.scheme;
  bool get isUrl => scheme == 'http' || scheme == 'https';
  bool get isFile => scheme == '';
  bool get loaded => path != null && File(path).existsSync();
  bool isLoading = true;

  var content_prefix = 'content://com.etiantian.online.wangxiao.flutter_downloader.provider/external/pdf';
  String get name => getName(widget._uri);

  @override
  initState() {
    super.initState();
    if (isUrl)
      loadPdf(widget._uri);
    else if (isFile) {
      path = Uri.decodeComponent(uri.toString());
    }
    debugLog('---');
    if (widget.fromZSDX) {
      DocTimer.startReportTimer(context, resId: widget.resId);
    }
  }

  @override
  void dispose() {
    if (widget.fromZSDX) {
      DocTimer.stopTimer();
    }
    super.dispose();
  }

  Future<String> get _localPath async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var pdfDir = Directory(directory.path + '/pdf');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return pdfDir.path;
  }

  Future<File> get _localFile async {
    final dir = await _localPath;
    return File('$dir/$name');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  loadPdf(String url) async {
    writeCounter(await fetchPost(url));
    path = (await _localFile).path;

    if (!mounted) return;

    setState(() {});
  }

  getName(String url) {
    // check url format
    if (widget.title == null || widget.title.length == 0) {
      var d = url.lastIndexOf("/");

      if (d != -1) {
        print("${url.split('/').last}");
        return url.split('/').last;
      }
      return 'unknow.pdf';
    } else {
      print('${widget.title}.pdf');
      return '${widget.title}.pdf';
    }
  }

  @override
  Widget build(BuildContext context) {
    String title;
    if (widget.title != null) {
      title = widget.title.replaceAll(".pdf", "");
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(title ?? '',style: TextStyle(fontSize: 14),),
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          actions: <Widget>[
            InkWell(
                child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.menu)),
                onTap: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) => Container(
                      height: 155,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      // alignment: Alignment.center,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (isUrl) ...[
                              InkWell(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Image.asset('static/images/download.png',
                                          width: 50, height: 50),
                                      const SizedBox(height: 9),
                                      Text('下载', style: textStyleMini)
                                    ],
                                  ),
                                  onTap: () {
                                    Fluttertoast.showToast(msg: '已下载，可以在我的下载查看');
                                  }),
                              const SizedBox(width: 17),
                            ],
                            InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('static/images/qita.png',
                                        width: 50, height: 50),
                                    const SizedBox(height: 9),
                                    Text('其他应用打开', style: textStyleMini)
                                  ],
                                ),
                                onTap: () {
                                  debugLog('$path');
                                  debugLog('${File(path).existsSync()}');
                                  if (Platform.isAndroid) {
                                    launch('$content_prefix/$name');
                                  } else {
                                    launch(uri.toString(), forceSafariVC: true);
                                  }
                                  Navigator.of(context).pop();
//                                  ShareExtend.share(path, "file");

                                }),
                            const SizedBox(width: 17),

                            InkWell(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('static/images/send.png',
                                        width: 50, height: 50),
                                    const SizedBox(height: 9),
                                    Text('发送至电脑', style: textStyleMini)
                                  ],
                                ),
                                onTap: () async {
                                  /// 分享文件
                                  File file = await _localFile;
                                  if (!await file.exists()) {
                                  await file.create(recursive: true);
                                  file.writeAsStringSync("test for share documents file");
                                  }
                                  ShareExtend.share(file.path, "file");
                                }),
                            const SizedBox(width: 17),
                          ]),

                    ),
                  ).then((_) {
                    debugLog('####');
                  });
                })
          ]),
      body: Container(child: loaded ? PdfViewer(filePath: path) : Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )),
    );
  }
}
