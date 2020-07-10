import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/material_dao.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/ai_model.dart';
import 'package:online_school/model/material_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/my_course/choose_material_version/choose_material_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/wisdom_study_page.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/modules/widgets/expanded_listview.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:flutter_redux/flutter_redux.dart';
//import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:redux/redux.dart';
import 'package:umeng_plugin/umeng_plugin.dart';
import 'ai_webview_page.dart';

/// page shared data
List<DataEntity> freeData;
BuildContext pageContext;

///
/// @name AITestPage
/// @description AI 测试页面
/// @author liuca
/// @date 2020-01-10
///
class AITestPage extends StatefulWidget {
  var type = 1;
  var subjectId;
  var gradeId;
  var courseId;
  var memoizer;
  var previewMode;

  AITestPage(this.subjectId, this.gradeId,
      {this.memoizer, this.courseId, this.previewMode});

  @override
  _AITestPageState createState() => _AITestPageState();
}
  
class _AITestPageState extends State<AITestPage> {
  AsyncMemoizer memoizer;
  List<DataEntity> detailData;
  DataEntity selectedRes;

  @override
  void initState() {
    super.initState();
    pageContext = context;
    memoizer = widget.memoizer ?? AsyncMemoizer();
//    UMengAnalytics.beginPageView("AI测试");
    UmengPlugin.beginPageView("AI测试");
  }

  @override
  void dispose() {
    super.dispose();
    memoizer = null;
//    UMengAnalytics.endPageView("AI测试");
    UmengPlugin.endPageView("AI测试");
  }

  _getData(subjectId, gradeId, type) =>
      memoizer.runOnce(() => _getAll(subjectId, gradeId, type));

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store) {
      return _buildWidget();
    });
  }

  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
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
        var material = snapshot.data['material'];
        var list = snapshot.data['list'];
        var model = list.model as AiModel;
        var materialModel = material as MaterialDataEntity;
        detailData = model?.data;
        if (detailData == null) {
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png', message: '没有数据');
        }
        if (model.code == 1 && detailData != null) {
          freeData = _markTopTwo(detailData);
          return _buildList(materialModel, detailData);
        }
        return Expanded(child: Text('什么也没有呢'));
      // Text('Error: ${liveDetailModel.msg}');
      default:
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png', message: '没有数据');
    }
  }

  Widget _buildWidget() {
    return FutureBuilder(
      builder: _futureBuilder,
      future: _getData(widget.subjectId, widget.gradeId, widget.type),
    );
  }

  _getAll(subjectId, gradeId, type) async {
    var response = await MaterialDao.material(subjectId, gradeId, type);
    if (response.result && response.model.code == 1) {
      var materialId = (response.model as MaterialModel).data.defMaterialId;
      var materialModel = response.model.data;
      if (this.mounted) {
        setState(() {});
      }
      return CourseDaoManager.aiStudyList(materialId)
          .then((t) => {'material': materialModel, 'list': t});
    }
    return Future.error('获取教材信息失败');
  }

  Widget _buildList(MaterialDataEntity materialModel, List<DataEntity> data) {
    return Column(
      children: <Widget>[
        Divider(height: 0.5),
        materialModel == null
            ? const SizedBox()
            : Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Positioned(child: Container(height: 32, color: Colors.white,)),
                Container(height: 74, padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), child: _buildChooseMaterial(materialModel))
              ]),
        Flexible(
          child: ListView.separated(
            // padding: EdgeInsets.only(top: 20),
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.transparent, height: 2),
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => EntryItem(
                data[index],
                selectedItem: selectedRes,
                index: index,
                previewMode: widget.previewMode, onPress: (clickedItem, [p]) async {
              if (selectedRes != clickedItem) {
                selectedRes = clickedItem;
                setState(() {});
              }
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                var token = NetworkManager.getAuthorization();
                var versionId = materialModel.defVersionId;
                var subjectId = materialModel.subjectId;
                var nodeId = (clickedItem as DataEntity).chapterId;
                var url = '${APIConst.practiceHost}/ai.html?token=$token&versionid=$versionId&currentdirid=$nodeId&subjectid=$subjectId&courseid=${widget.courseId}';
                /// 跳转到AI详情页面
                return AIWebPage(
                  currentDirId: nodeId.toString(),
                  versionId: versionId.toString(),
                  subjectId: subjectId.toString(),
                  initialUrl: url,
                  title: (clickedItem as DataEntity).chapterName,
                );
              })).then((_) {
                setState(() {
                  memoizer = memoizer = AsyncMemoizer();
                });
              });
            }),
            itemCount: data.length,
          ),
        )
      ],
    );
  }

  Container _buildChooseMaterial(MaterialDataEntity materialModel) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
        boxShadow: [
          BoxShadow(
              color: Color(MyColors.shadow),
              offset: Offset(0, 2),
              blurRadius: 10.0,
              spreadRadius: 2.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          materialModel == null
              ? Container()
              : Expanded(
                  child: Text(
                      '${materialModel?.defAbbreviation} - ${materialModel?.defMaterialName}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14,
                          fontWeight: FontWeight.w600))),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              // width: 44,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(0x33F7B71D),
                border: Border.all(
                  color: Color(0xFFF8B739),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(MyIcons.SWITCH, size: 9, color: Color(0xFFF8B739)),
                  const SizedBox(width: 5),
                  Text('切换', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 13 : 9, color: Color(0xFFF8B739)))
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return ChooseMaterialPage(
                    subjectId: widget.subjectId,
                    gradeId: widget.gradeId,
                    type: widget.type,
                    materialId: materialModel?.defMaterialId,
                  materialDataEntity: materialModel,
                );
              })).then((v) {
                if (v ?? false) {
                  widget.memoizer = memoizer = AsyncMemoizer();
                  if (this.mounted) {
                    setState(() {});
                  }
                }
              });
            },
          ),
        ],
      ),
    );
  }

  isEmpty(List<DataEntity> list) {
    return (list?.length ?? 0) == 0;
  }

  isLeaf(DataEntity node) {
    return (node.chapterList?.length ?? 0) == 0;
  }

  // 遍历树形列表，取前2条数据存入列表，
  List<DataEntity> _markTopTwo(List<DataEntity> data) {
    var list = List<DataEntity>();
    var tmp = List<DataEntity>();
    var count = 0;

    // 空列表，返回
    if (isEmpty(data)) return list;

    // 遍历
    tmp.addAll(data);
    while (tmp.length > 0) {
      // 队列首部取
      var node = tmp.removeAt(0);
      // 是叶子则处理
      if (isLeaf(node)) {
        list.add(node);
        count++;
        if (count > 1) break;
      } else {
        // 非叶子，则入队列
        node.chapterList.reversed.forEach((i) => tmp.insert(0, i));
      }
    }

    return list;
  }
}

///
/// @name EntryItem
/// @description 构建章节树组件
/// @author liuca
/// @date 2019-12-25
///
class EntryItem extends StatelessWidget {
  OnPress onPress;
  final DataEntity entry;

  var selectedItem;
  var previewMode;

  var index;

  EntryItem(this.entry, {this.onPress, this.selectedItem, this.previewMode = false, this.index});

  _isFree(DataEntity leaf) {
    return freeData.contains(leaf);
  }

  Widget _buildTiles(DataEntity root, {bool selected = false, bool isFirst = false}) {
    // 叶子节点
    if (root.chapterList?.isEmpty ?? true) {
      var rating = root.starNum;
      return InkWell(
          child: Container(
            padding: EdgeInsets.only(left: (root.level == 1 ? 0 : 1) * 10.0),
            child: ListTile(
                key: PageStorageKey<DataEntity>(root),
                dense: true,
                selected: selected,
                title: Text(root.chapterName, style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14),),
                trailing: previewMode
                    ? _isFree(root) ? _tryTag() : _lockTag()
                    : root.publishable
                        ? Container(
                            // color: Colors.red,
                            width: 80,
                            height: 20,
                            child: StarRating(
                              size: 20.0,
                              rating: rating.toDouble(),
                              color: Colors.orange,
                              borderColor: Colors.grey,
                              starCount: 4,
                            ),
                          )
                        : null),
          ),
          onTap: (!previewMode || _isFree(root))
              ? () => onPress(root)
              : () {
                  showDialog(context: pageContext, builder: _dialogBuilder);
                });
    }

    /// Widget组件列表
    List<Widget> children = root.chapterList
            ?.map((i) => _buildTiles(i,
                selected: selectedItem == i,
                isFirst: root.chapterList.indexOf(i) == 0 && isFirst))
            ?.toList() ??
        [];

    /// 显示列表
    return Padding(
      padding: EdgeInsets.only(left: (root.level - 1) * 10.0),
      child: ExpandedList(
        initiallyExpanded: previewMode && isFirst,
        key: PageStorageKey<DataEntity>(root),
        title: Expanded(
            child:
                Text(root.chapterName.trim(), overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14),)),
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _buildTiles(entry, isFirst: index == 0),
    );
  }
}

Widget _lockTag() {
  return Icon(Icons.lock, size: 20);
}

Container _tryTag() {
  return Container(
      width: 38,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(
          color: Color(0xFF6B8DFF),
        ),
      ),
      child: Text('体验', style: textStyle11Blue));
}

Widget _dialogBuilder(BuildContext context) {
  return ActivityCourseAlert(
    tapCallBack: () {
      Navigator.of(context).pop();
    },
  );
}