import 'dart:convert';
import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:redux/redux.dart';
import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/cc_login_model.dart';
import 'package:online_school/model/errorbook_list_model.dart';
import 'package:online_school/model/ett_pdf_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/modules/widgets/loading_view.dart';
import 'package:online_school/modules/widgets/pdf_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/common/tools/grade_utils.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:async/async.dart';
import 'errorbook_detail_page.dart';


///
/// @name ErrorBookDetailPage
/// @description 原生错题本详情页面
/// @author liuca
/// @date 2020-01-11
///
class ErrorBookItemListPage extends StatefulWidget {
  var subjectId;

  ErrorBookItemListPage({Key key, this.subjectId}) : super(key: key);

  _ErrorBookItemListPageState createState() => _ErrorBookItemListPageState();
}

class _ErrorBookItemListPageState extends State<ErrorBookItemListPage> {
  AsyncMemoizer _memoizer = AsyncMemoizer();
  ScrollController _scrollController;
  bool selectMode = false;

  DataEntity detailData;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      debugLog(_scrollController.position.extentAfter);
    });
  }

  _toggle() {
    setState(() {
      selectMode = !selectMode;
    });
  }





  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      Map subjects = {
        1: MTTLocalization.of(context).currentLocalized.common_chinese,
        2: MTTLocalization.of(context).currentLocalized.common_mathematics,
        3: MTTLocalization.of(context).currentLocalized.common_english,
        4: MTTLocalization.of(context).currentLocalized.common_physical,
        5: MTTLocalization.of(context).currentLocalized.common_chemistry,
        6: MTTLocalization.of(context).currentLocalized.common_history,
        7: MTTLocalization.of(context).currentLocalized.common_biology,
        8: MTTLocalization.of(context).currentLocalized.common_geography,
        9: MTTLocalization.of(context).currentLocalized.common_politics,
        10: '科学',
      };
      String title = subjects[widget.subjectId];
      return Scaffold(
        appBar: AppBar(
            title: Text(title ?? "错题本"),
            backgroundColor: Colors.white,
            centerTitle: Platform.isIOS ? true : false,
            elevation: 1,
            actions: <Widget>[
              FlatButton(
                child: Text(selectMode ? MTTLocalization.of(context).currentLocalized.error_book_page_cancel : MTTLocalization.of(context).currentLocalized.error_book_page_choose),
                onPressed: () {
                  _toggle();
                },
              ),
            ]),
        backgroundColor: Color(MyColors.background),
        body: Stack(children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              child: _buildBody()),
          if (selectMode)
            Positioned.directional(
              bottom: 0,
              end: 0,
              start: 0,
              textDirection: TextDirection.ltr,
              child: Container(
                // width: double.infinity,
                  height: 60,
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        InkWell(
                          child: Container(
                            height: 39,
                            width: 85,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: Color(0xFF6B8DFF),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                              border: Border.all(
                                color: Color(0xFFFF665F),
                              ),
                            ),
                            child: Text('删除', style: TextStyle(fontSize: 12, color: Color(0xFFFF665F))),
                          ),
                          onTap: _onDeleteTask,
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                            child: Container(
                              height: 39,
                              width: 165,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xFF6B8DFF),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
                              ),
                              child: Text('已选 ${_selectedCount()} 题，生成试卷', style: textStyle12WhiteBold),
                            ),
                            onTap: _submitAndGetPdf),
                        const SizedBox(width: 12),
                      ])),
            ),
        ]),
      );
    });
  }

  _buildBody() {
    return FutureBuilder(
      builder: _builder,
      future: _getDetail(),
    );
  }

  _getDetail() => _memoizer.runOnce(() => CourseDaoManager.errorbookList(
      currentPage: 1, pageSize: 1000, subjectId: widget.subjectId));

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

        var errorbookModel = snapshot.data.model as ErrorbookListModel;
        detailData = errorbookModel?.data;
        if (detailData == null) {
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png', message: '没有数据');
        }
        if (errorbookModel.code == 1 && detailData != null) {
          return _buildList();
        }
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png',
            message: '${errorbookModel.msg}');
      // Text('Error: ${liveDetailModel.msg}');
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  Widget _buildList() {
    double imageHeight = 120.0;
    if (SingletonManager.sharedInstance.screenHeight > 1000) {
      imageHeight = 350;
    }
    return GridView.builder(
      controller: _scrollController,
      itemCount: detailData.list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 8 / 9.0),
      itemBuilder: (BuildContext context, int index) {
        ListEntity item = detailData.list[index];
        return InkWell(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // width: 160,
                        height: imageHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4.0)),
                          image: DecorationImage(
                            image: NetworkImage(item.photoUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                        child: Text(item.uploadTime, style: textStyle11999),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 0),
                        child: Text(item.wrongReason,
                            style: textStyle13TitleBlackMid),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                        alignment: Alignment.topCenter,
                        child: Text(
                            gradeSample.entries
                                .where((kv) => kv.key == item.gradeId)
                                .single
                                .value,
                            style: textStyle10White),
                        height: 16,
                        width: 32,
                        decoration: _boxDecoration()),
                  ),
                  if (selectMode)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ClipOval(
                              child: Container(
                                  width: 18.5,
                                  height: 18.5,
                                  alignment: Alignment.center,
                                  color: item.selected
                                      ? Color(0xFF6B8DFF)
                                      : Color(0XFFD8D8D8),
                                  child: Icon(MyIcons.RIGHT,
                                      color: Colors.white, size: 9))),
                        ),
                        onTap: () => _onSelectTask(item),
                      ),
                    ),
                ])),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ErrorbookDetailPage(reasonId: item.wrongPhotoId);
              }));
            });
      },
    );
  }

  _onDeleteTask() {
    var countToDel = _selectedCount();
    if (countToDel == 0) {
      Fluttertoast.showToast(msg: '请先选择错题');
      return;
    }
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Text('确定删除错题？'),
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
    ).then((agree) async {
      if (agree) {
        var listToDel = detailData.list.where((i) => i.selected).toList();
        var ids = listToDel.map((i) => i.wrongPhotoId).join(',');
        CourseDaoManager.delErrorbook(wrongPhotoIds: ids).then((response) {
          if (response.result) {
            detailData.list.removeWhere((i) => i.selected);
            setState(() {});
          } else {
            Fluttertoast.showToast(msg: '删除失败');
          }
        });
      }
    });
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Color(0xFF6B8DFF),
      borderRadius: BorderRadius.all(
        Radius.circular(2),
      ),
    );
  }

  _onSelectTask(ListEntity item) {
    setState(() {
      item.selected = !item.selected;
    });
  }

  _selectedCount() {
    return detailData?.list?.where((i) => i.selected)?.toList()?.length ?? 0;
  }

  void _submitAndGetPdf() async {
    var countToDel = _selectedCount();
    if (countToDel == 0) {
      Fluttertoast.showToast(msg: '请先选择错题');
      return;
    }
    var listToDel = detailData.list.where((i) => i.selected).toList();
    var ids = listToDel.map((i) => i.wrongPhotoId).join(',');

    /// 显示加载圈
    _showLoading();

    // 查询token
    String authorizationCode = await getAuthorization();
    ResponseData responseData = await DaoManager.fetchPDFURL({
      "questionIds":ids,
      "questionType":3,
      "subjectId":widget.subjectId,
      "accessToken":authorizationCode
    });

    print("data:$responseData");

    /// 移除加载圈
    _hideLoading();

    if (responseData != null && responseData.model != null) {
      ETTPDFModel pdfModel = responseData.model;
      if (pdfModel.type == "success" && pdfModel.msg == "成功") {
        print("url: ${pdfModel.data.previewUrl}");
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return PDFPage(pdfModel.data.previewUrl,title: pdfModel.data.presentationName,);
        })).then((value){
          setState(() {
            selectMode = false;
          });
        });
      } else {
        Fluttertoast.showToast(msg: '您的作业被小怪兽吃了，再生成一次吧。',gravity: ToastGravity.CENTER);
      }
    } else {
      Fluttertoast.showToast(msg: '您的作业被小怪兽吃了，再生成一次吧。',gravity: ToastGravity.CENTER);
    }
  }

  ///获取授权token
  static getAuthorization() {
    var json = SharedPrefsUtils.getString(Config.LOGIN_JSON, '{}');
    var ccLoginModel = CcLoginModel.fromJson(jsonDecode(json));
    String token = ccLoginModel.access_token;
    if (token == null) {
      String basic = APIConst.basicToken;
      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      return token;
    }
  }

  ///
  /// @name _showLoading 显示加载圈
  /// @description
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-31
  ///
  _showLoading() {
    /// 1.上传所选的题目id
    /// 2.获取组装完的pdf文档
    /// 3.刷一下当前页面状态
    showDialog(context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingView();
      },
    );
  }

  ///
  /// @name _hideLoading
  /// @description 隐藏加载圈
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-31
  ///
  _hideLoading() {
    Navigator.pop(context);
  }

}
