import 'dart:io';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/errorbook_detail_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/common/tools/grade_utils.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../widgets/image_browse_widget.dart';
import '../../widgets/list_type_loading_placehold_widget.dart';

///
/// @name ErrorbookDetailPage
/// @description 错题本详情页面
/// @author liuca
/// @date 2020-01-11
///
class ErrorbookDetailPage extends StatefulWidget {
  var reasonId;

  ErrorbookDetailPage({Key key, this.reasonId}) : super(key: key);

  _ErrorbookDetailPageState createState() => _ErrorbookDetailPageState();
}

class _ErrorbookDetailPageState extends State<ErrorbookDetailPage> {
  DataEntity detailData;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('错题详情'),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: Platform.isIOS ? true : false,
      ),
      backgroundColor: Color(MyColors.background),
      body: _build(),
    );
  }

  Widget _buildPage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: InkWell(
                child: Image.network(detailData.photoUrl),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ImageBrowseWidget(image: detailData.photoUrl)));
                }),
          ),
          flex: 454,
        ),
        Expanded(
          child: Container(child: _buildBottom()),
          flex: 105,
        ),
      ],
    );
  }

  _buildBottom() {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(),
      child: Container(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 3.0, // has the effect of softening the shadow
                spreadRadius: 0.0, // has the effect of extending the shadow
                offset: Offset(
                  0.0,
                  -0.5,
                ),
              )
            ],
          ),
          child: Stack(children: <Widget>[
            Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('上传时间', style: textStyle10999),
                      Padding(padding: EdgeInsets.only(left: 10),),
                      Text(detailData.uploadTime, style: textStyle13TitleBlackMid),
                    ],
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Row(
                    children: <Widget>[
                      Text('错题原因', style: textStyle10999),
                      Padding(padding: EdgeInsets.only(left: 10),),
                      Text(detailData.wrongReason, style: textStyle13TitleBlackMid),
                    ],
                  ),
                ]),
            Positioned.directional(
              bottom: 0,
              end: 0,
              textDirection: TextDirection.ltr,
              child: Container(
                  alignment: Alignment.center,
                  child: Text(
                      gradeSample.entries
                          .where((kv) => kv.key == detailData.gradeId)
                          .single
                          .value,
                      style: textStyle10White),
                  height: 16,
                  width: 32,
                  decoration: _boxDecoration()),
            ),
          ])),
    );
  }

  _getDetail() => _memoizer.runOnce(
      () => CourseDaoManager.errorbookDetail(wrongPhotoId: widget.reasonId));

  _build() {
    return FutureBuilder(
      future: _getDetail(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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

            var errorbookModel = snapshot.data.model as ErrorbookDetailModel;
            detailData = errorbookModel?.data;
            if (detailData == null) {
              return EmptyPlaceholderPage(
                  assetsPath: 'static/images/empty.png', message: '没有数据');
            }
            if (errorbookModel.code == 1 && detailData != null) {
              return _buildPage();
            }
            return EmptyPlaceholderPage(
                assetsPath: 'static/images/empty.png',
                message: '${errorbookModel.msg}');
          // Text('Error: ${liveDetailModel.msg}');
          default:
            return EmptyPlaceholderPage(
                assetsPath: 'static/images/empty.png', message: '没有数据');
        }
      },
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Color(0xFF6B8DFF),
      borderRadius: BorderRadius.all(
        Radius.circular(2),
      ),
    );
  }
}
