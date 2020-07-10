import 'dart:io';

import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/ab_test_model.dart';
import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/modules/widgets/microcourse_webview.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


///
/// @name ExerciseRecordPage
/// @description 练习记录页面
/// @author liuca
/// @date 2020-01-11
///
class ExerciseRecordPage extends StatefulWidget {
  num resouceId;

  // 1,微课 2,AB测试
  int type = 1;

  String srcAbPaperId;

  /// srcAbPaperId 只有在type=2时才有效
  ExerciseRecordPage(this.resouceId, {this.type = 1, this.srcAbPaperId});

  @override
  _ExerciseRecordPageState createState() => _ExerciseRecordPageState();
}

class _ExerciseRecordPageState extends State<ExerciseRecordPage> {
  AsyncMemoizer _memoizer;
  DateTime _selected;
  List<DataEntity> detailData;

  bool get fromMicroCourse => widget.type == 1;

  @override
  void initState() {
    _memoizer = AsyncMemoizer();
    _selected = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('练习记录'),
        elevation: 1.0,
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: FutureBuilder(builder: _futureBuilder, future: _fetchData()),
    );
  }

  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        if (snapshot.hasError) {
          return EmptyPlaceholderPage();
        }
        if (!snapshot.data.result) {
          return EmptyPlaceholderPage();
        }
        var model = snapshot.data.model as AbTestModel;
        detailData = model.data;
        if (detailData.length == 0) {
          return EmptyPlaceholderPage();
        }
        return _createView();
        break;
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Center(
          child: CircularProgressIndicator(),
        );
      default:
        return Text('unknow error');
    }
  }

  _fetchData() {
    return _memoizer.runOnce(() => CourseDaoManager.getExerciseHistory(
        widget.resouceId,
        fromMicroCourse: fromMicroCourse));
  }

  Widget _createView() {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: detailData.length,
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var item = detailData[index];
    return Column(children: <Widget>[
      Divider(
        height: 1,
      ),
      ListTile(
        leading: Icon(
          MyIcons.ANSWER_CARD,
          size: 20.0,
        ),
        title: Text(item.paperName, style: textStyleContent333),
        trailing: Icon(
          MyIcons.ARROW_R,
          size: 16.0,
        ),
        onTap: () async {
          if (widget.type == 1) {
            await onMicroExerPressed(item, context);
          } else {
            var token = await NetworkManager.getAuthorization();
            var paperid = item.paperId;
            var abpid = item.srcABPaperId;
            var url =
                '${APIConst.practiceHost}/abreport.html?token=$token&abpid=$abpid&paperid=$paperid';
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return MicrocourseWebPage(
                initialUrl: url,
                isReport: true,
                resourceId: abpid,
                resourceName: item.srcABPaperName,
                isAb: true,
                srcABPaperQuesIds: item.srcABPaperQuesIds,
              );
            }));
          }
        },
      ),
    ]);
  }

  Future onMicroExerPressed(DataEntity item, BuildContext context) async {
    var paperId = item.paperId;
    var token = await NetworkManager.getAuthorization();
    var resourceId = item.resourceId;
    var url =
        '${APIConst.practiceHost}/report.html?token=$token&resourceid=$resourceId&paperid=$paperId';
    // _controller.future.then((controller) => controller.loadUrl(url));
    // 去报告页，新开页面

    ResponseData response =
        await CourseDaoManager.getMicroCourseResourseInfo(item.resourceId);
    if (response.result && response.model != null && response.model.code == 1) {
      var model = response.model as MicroCourseResourceModel;
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MicrocourseWebPage(
            initialUrl: url,
            isReport: true,
            resourceId: model.data.resouceId,
            resourceName: model.data.resourceName);
      }));
    } else {
      Fluttertoast.showToast(msg: '获取资源详情失败');
    }
  }
}
