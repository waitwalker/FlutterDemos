import 'dart:convert';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/material_dao.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/material_model.dart';
import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/model/self_model.dart';
import 'package:online_school/model/self_study_record.dart';
import 'package:online_school/modules/my_course/choose_material_version/choose_material_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/scroll_to_index/scroll_to_index.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/my_course/wisdom_study/test_paper_page.dart';
import 'package:online_school/modules/my_course/ai_test/change_material_page.dart';
import 'package:online_school/modules/my_course/wisdom_study/hd_video_page.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/my_course/wisdom_study/video_play_widget.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/activity_alert.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:online_school/modules/widgets/expanded_listview.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';
import '../../widgets/common_webview_page.dart';
import '../../widgets/pdf_page.dart';
import 'micro_course_page.dart';

/// 这个页面几经改变，有些复杂，修改的时候，注意一下功能
/// 1、record用于记录当前学习的资源
/// 因为是树形菜单，所以record记录了资源的各级父节点
/// 退出到首页，会显示一个飘窗，显示上次学习的课程资源
/// 点击飘窗，直接跳到本页面，打开上次学到的位置，沿途节点都需要展开
/// 还要滚动到改资源
/// 2、预览。如果是没有买卡的用户，前版本是不能到本页的
/// 现在可以了。要求第一章第一节第一知识点下面的前两个资源可以免费看
/// 其他的加锁，点击弹框提示用户咨询客服
///
/// @name WisdomStudyPage
/// @description 智慧学习页面
/// @author liuca
/// @date 2020-01-10
///
class WisdomStudyPage extends StatefulWidget {
  final int type = 2;
  var courseId;
  var subjectId;
  var gradeId;
  var memoizer;

  /// 预览模式，适用于未激活用户，只能看第一条，默认为用户打开
  var previewMode;

  AutoScrollController scrollController;

  /// 学习记录=>滚动到具体位置
  /// 记录用户点击的资源条目以及所有父列表的条目
  Record record;

  bool useRecord;

  WisdomStudyPage(this.courseId, this.subjectId, this.gradeId,
      {this.memoizer,
      this.scrollController,
      this.record,
      this.previewMode = false,
      this.useRecord = false});

  @override
  State<StatefulWidget> createState() {
    return _WisdomStudyPageState();
  }
}

class _WisdomStudyPageState extends State<WisdomStudyPage> {
  AsyncMemoizer memoizer;
  List<DataEntity> detailData;
  ResourceIdListEntity selectedRes;
  SelfStudyRecord record;

  int get lastResId => record?.id;
  AutoScrollController controller;
  AutoScrollController outer_controller;

  /// 是否预览
  bool previewMode;

  @override
  void initState() {
    super.initState();
    pageContext = context;
    outer_controller = widget.scrollController;
    controller = AutoScrollController();
    previewMode = widget.previewMode;
    if (!previewMode) {
      loadLocal();
    }
    UMengAnalytics.beginPageView("智慧学习");
    memoizer = widget.memoizer ?? AsyncMemoizer();
  }

  @override
  dispose() {
    if (record != null) {
      record.subjectId = widget.subjectId;
      record.gradeId = widget.gradeId;
      saveRecord(record);
    }
    UMengAnalytics.endPageView("智慧学习");
    memoizer = null;
    super.dispose();
  }

  _getData(subjectId, gradeId, type) =>
      memoizer.runOnce(() => _getAll(subjectId, gradeId, type));

  Store<AppState> _getStore() {
    return StoreProvider.of<AppState>(context);
  }

  /// 读取本地历史记录
  loadLocal() {
    var s = widget.useRecord ? SharedPrefsUtils.getString('record', '') : '';
    Map<String, dynamic> map;
    try {
      map = jsonDecode(s);
    } on Exception catch (e) {}
    if (map == null || !map.containsKey('type')) {
      record = SelfStudyRecord(
          type: 2, subjectId: widget.subjectId, gradeId: widget.gradeId);
      return;
    }
    if (map['type'] == 1) {
      record = SelfStudyRecord(
          type: 2, subjectId: widget.subjectId, gradeId: widget.gradeId);
    } else if (map['type'] == 2) {
      record = SelfStudyRecord.fromJson(map);
    }
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
        var model = list.model as SelfModel;
        var materialModel = material as MaterialDataEntity;
        detailData = model?.data;
        if (detailData == null) {
          return EmptyPlaceholderPage(
              assetsPath: 'static/images/empty.png', message: '没有数据');
        }
        if (model.code == 1 && detailData != null) {
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

  Widget _buildList(MaterialDataEntity materialModel, List<DataEntity> data) {

    /// 这个函数，用来自动滚动到树形菜单的某一项，滚动距离通过计算得出，不同屏幕有误差
    var scrollToViewport = () =>
        SchedulerBinding.instance.addPostFrameCallback((d) {
          // Future.delayed(Duration(seconds: 1), () {
          debugLog('++++++++$d');
          int listtile_height = 44;
          // controller.scrollToIndex(record?.firstId,
          //     preferPosition: AutoScrollPosition.begin);
          int firstIndex =
              detailData.indexWhere((item) => item.nodeId == record?.firstId);
          if (firstIndex == -1) return;
          int secondIndex = detailData[firstIndex]
                  .nodeList
                  ?.indexWhere((item) => item.nodeId == record?.secondId) ??
              -1;
          int thirdIndex = secondIndex == -1
              ? -1
              : detailData[firstIndex]
                      .nodeList[secondIndex]
                      .nodeList
                      ?.indexWhere((item) => item.nodeId == record?.thirdId) ??
                  -1;

          var lastList = secondIndex == -1
              ? detailData[firstIndex]
              : thirdIndex == -1
                  ? detailData[firstIndex].nodeList[secondIndex]
                  : detailData[firstIndex]
                      .nodeList[secondIndex]
                      .nodeList[thirdIndex];

          int resIndex = lastList.resourceIdList
              .indexWhere((item) => item.resId == record?.id);
          double lines = (firstIndex + 1) * (listtile_height + 10.0) +
              (secondIndex + 1 + thirdIndex + 1) * listtile_height +
              (resIndex) * 64 +
              20 -
              74; // 悬浮在顶部的选择教材栏的高度，需要减去，防止覆盖到当前高亮条目
          // outer_controller.animateTo(160,
          //     duration: Duration(seconds: 1), curve: Curves.ease);
          controller.animateTo(lines,
              duration: Duration(seconds: 1), curve: Curves.ease);
          controller.highlight(record?.firstId);
          // });
        });
    record != null &&
            detailData.indexWhere((i) => record?.firstId == i.nodeId) != -1
        ? scrollToViewport()
        : null;
    return Column(
      children: <Widget>[
        Divider(height: 0.5),
        materialModel == null
            ? const SizedBox()
            : Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                Positioned(
                    child: Container(
                  height: 32,
                  color: Colors.white,
                )),
                Container(
                    height: 74,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: _buildChooseMaterial(materialModel))
              ]),
        Flexible(
          flex: 1,
          child: ListView.separated(
            controller: controller,
            // padding: EdgeInsets.only(top: 20),
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.transparent, height: 2),
            // physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) => EntryItem(
                data[index],
                selectedItem: this.selectedRes,
                scrollController: widget.scrollController,
                previewMode: widget.previewMode,
                firstItem: index == 0,
                record: record, onPress: (clickedItem, [parent]) async {
              debugLog('---->');
              if (clickedItem is DataEntity) {
                await fetchChildren(clickedItem, materialModel);
              } else if (clickedItem is ResourceIdListEntity) {
                // if (selectedRes != clickedItem) {
                selectedRes = clickedItem;
                record?.id = clickedItem.resId;
                record?.firstId = data[index].nodeId;
                record?.courseId = widget.courseId;
                debugLog(record);
                setState(() {});
                // }
                AnalysisDao.log(materialModel.defMaterialId, parent.nodeId,
                    clickedItem.resType, clickedItem.resId);
                if (clickedItem.resType == 3) {
                  /// 测验 卷子
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return TestPaperPage(clickedItem, widget.courseId);
                  })).then((v) {
                    widget.memoizer = memoizer = AsyncMemoizer();
                    if (this.mounted) {
                      setState(() {});
                    }
                  });
                } else if (clickedItem.resType == 2) {
                  /// 微课
                  var microCourseResourseInfo =
                      await CourseDaoManager.getMicroCourseResourseInfo(
                          clickedItem.resId);
                  if (microCourseResourseInfo.result) {
                    MicroCourseResourceModel model = microCourseResourseInfo
                        .model as MicroCourseResourceModel;
                    _toMicroCourse(model.data, widget.courseId, parent.nodeName);
                  }
                } else if (clickedItem.resType == 1 ||
                    clickedItem.resType == 4) {
                  /// 高清课
                  var resourseInfo = await CourseDaoManager.getResourseInfo(clickedItem.resId);
                  if (resourseInfo.result &&
                      resourseInfo.model != null &&
                      resourseInfo.model.code == 1) {
                    if (clickedItem.resType == 1) {
                      // 微视频/高清
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return HDVideoPage(
                            source: resourseInfo.model.data.videoUrl,
                            title: clickedItem.resName,
                            coverUrl: resourseInfo.model.data.imageUrl,
                            from: parent.nodeName,
                            videoInfo: VideoInfo(
                              videoUrl: resourseInfo.model.data.videoUrl,
                              videoDownloadUrl:
                                  resourseInfo.model.data.downloadVideoUrl,
                              imageUrl: resourseInfo.model.data.imageUrl,
                              resName: resourseInfo.model.data.resourceName,
                              resId:
                                  resourseInfo.model.data.resouceId.toString(),
                              courseId: widget.courseId.toString(),
                            ));
                      })).then((v) {
                        widget.memoizer = memoizer = AsyncMemoizer();
                        if (this.mounted) {
                          setState(() {});
                        }
                      });
                    } else {
                      /// 导学 文档
                      var model = resourseInfo.model;
                      if (model.data.literatureDownUrl.endsWith('.pdf')) {
                        /// 调到PDF预览页
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return PDFPage(model.data.literatureDownUrl,
                              title: model.data.resourceName,
                              fromZSDX: true,
                              resId: model.data.resouceId.toString());
                        })).then((v) {
                          widget.memoizer = memoizer = AsyncMemoizer();
                          if (this.mounted) {
                            setState(() {});
                          }
                        });
                      } else {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return WebviewPage(
                            resourseInfo.model.data.literaturePreviewUrl,
                            title: clickedItem.resName,
                          );
                        })).then((v) {
                          widget.memoizer = memoizer = AsyncMemoizer();
                          if (this.mounted) {
                            setState(() {});
                          }
                        });
                      }
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: resourseInfo.model?.msg ?? '获取资源失败');
                  }
                }
              }
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
                          fontWeight: FontWeight.w600)),
                ),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 6),
              // width: 44,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(0x33F7B71D),
                border: Border.all(
                  color: Color(0xFFF8B739),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(MyIcons.SWITCH, size: 10, color: Color(0xFFF8B739)),
                  const SizedBox(width: 5),
                  Text('切换', style: TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 13 : 10, color: Color(0xFFF8B739)))
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
                widget.memoizer = memoizer = AsyncMemoizer();
                if (this.mounted) {
                  setState(() {});
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future fetchChildren(clickedItem, MaterialDataEntity materialModel) async {
    var response = await CourseDaoManager.selfStudyList(materialModel.defVersionId,
        materialModel.defMaterialId, clickedItem.level + 1, clickedItem.nodeId);
    if (response.result && response.model != null && response.model.code == 1) {
      var model = (response.model as SelfModel);
      clickedItem.nodeList = model.data;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  /// 跳转到微课详情
  void _toMicroCourse(
      MicroCourseResourceDataEntity data, dynamic courseId, String nodeName) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return MicroCoursePage(data, courseId, from: nodeName);
    })).then((v) {
      widget.memoizer = memoizer = AsyncMemoizer();
      if (this.mounted) {
        setState(() {});
      }
    });
  }

  _getAll(subjectId, gradeId, type) async {
    var response = await MaterialDao.material(subjectId, gradeId, type);
    if (response.result && response.model.code == 1) {
      var materialId = (response.model as MaterialModel).data.defMaterialId;
      var materialModel = response.model.data;
      if (this.mounted) {
        setState(() {});
      }
      return CourseDaoManager.selfStudyListV2(materialId)
          .then((t) => {'material': materialModel, 'list': t});
    }
    return Future.error('获取教材信息失败');
  }
}

typedef void OnPress(item, [DataEntity parent]);
BuildContext pageContext;

/// Displays one Entry. If the entry has children then it's displayed
/// with an ExpansionTile.
/// 文档 https://flutterchina.club/catalog/samples/expansion-tile-sample/
class EntryItem extends StatelessWidget {
  OnPress onPress;
  final DataEntity entry;

  var selectedItem;
  AutoScrollController scrollController;

  SelfStudyRecord record;
  bool previewMode;
  bool firstItem;

  EntryItem(this.entry, {this.onPress, this.selectedItem, this.scrollController, this.record, this.firstItem = false, this.previewMode = false});

  Widget _buildTiles(DataEntity root, OnPress onPress, {bool isFirst = false}) {
    OnPress _onPress = (m, [p]) {
      root.level == 1 ? record?.firstId = root.nodeId : root.level == 2 ? record?.secondId = root.nodeId : root.level == 3 ? record?.thirdId = root.nodeId : null;
      onPress(m, p);
    };

    if (root.level == 3) {
      return _buildResourseList(root, root.level,
          title: root.nodeName,
          onPress: _onPress,
          selectedItem: selectedItem,
          record: record,
          previewMode: previewMode,
          isFirst: isFirst,
          scrollController: scrollController);
    }

    /// 每一行，如果不是资源，是如下递归生成的树形菜单，
    /// [isFirst]，用于判断当前行是否是第一行，
    /// 注意，不只是当前行是第一行，他的上一层列表项，也必须是第一行
    /// 最终实现，第一章第一节第一知识点，下面的前2个资源免费体验
    List<Widget> children = root.nodeList
            ?.map((m) => _buildTiles(m, _onPress,
                isFirst: root.nodeList.indexOf(m) == 0&&isFirst))
            ?.toList() ??
        [];
    if (children.length == 0) {
      /// 章和节的直属资源
      if (root.resourceIdList?.isNotEmpty ?? false) {
        return _buildResourseList(root, root.level,
            onPress: _onPress,
            title: root.nodeName,
            selectedItem: selectedItem,
            record: record,
            previewMode: previewMode,
            isFirst: isFirst,
            scrollController: scrollController);
      }
    } else if ((root.resourceIdList?.length ?? 0) != 0) {
      var buildResourseList = _buildResourseList(root, root.level,
          onPress: _onPress,
          title: root.level == 1 ? '本章复习' : '本节复习',
          selectedItem: selectedItem,
          record: record,
          previewMode: previewMode,
          scrollController: scrollController);
      children.add(buildResourseList);
    }

    bool expandOrNot = (previewMode && isFirst) ||
        (record?.firstId == root.nodeId ||
            record?.secondId == root.nodeId ||
            record?.thirdId == root.nodeId);

/// AutoScrollTag 用来实现滚动到指定位置
    return AutoScrollTag(
      index: root.nodeId,
      controller: scrollController,
      highlightColor: Color(MyColors.primaryValue),
      key: PageStorageKey<DataEntity>(root),
      child: Padding(
        padding: EdgeInsets.only(left: (root.level - 1) * 10.0),
        child: InkWell(
          child: ExpandedList(
            initiallyExpanded: expandOrNot,
            key: PageStorageKey<DataEntity>(root),
            title: Expanded(
              child: Text(
                root.nodeName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14),
              ),
            ),
            children: children,
          ),
          onTap: () => onPress(root),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _buildTiles(entry, onPress, isFirst: firstItem),
    );
  }
}

/// 1微视频、2微课、3AB卷、4文献
String _getResTypeName(int type) {
  var resTypeName;
  switch (type) {
    case 1:
      resTypeName = '微课';
      break;
    case 2:
      resTypeName = '微课';
      break;
    case 3:
      resTypeName = '测验';
      break;
    case 4:
      resTypeName = '导学';
      break;
    default:
      resTypeName = '其他';
  }
  return resTypeName;
}

/// 资源列表，是树形列表的最里层
/// 树分4层，章 - 节 - 知识点 - 资源
/// 但是，并非所有资源都在知识点下，
/// 接口的数据，章、节都有直属资源，所以接口的数据，还需要简单洗一下：
/// 章下的资源，叫本章复习；节的叫本节复习
Widget _buildResourseList(DataEntity root, int level,
    {String title = '本节复习',
    OnPress onPress,
    selectedItem = null,
    AutoScrollController scrollController,
    SelfStudyRecord record,
    bool isFirst = false,
    bool previewMode = false}) {
  List<ResourceIdListEntity> list = root.resourceIdList;
  if (level < 1 || level > 3) {
    throw FormatException('level must in [1,2,3]!');
  }
  bool expanded = (previewMode && isFirst) ||
      (list.where((l) => l.resId == record?.id).toList().isNotEmpty);
  Widget resWidget = Container(
    padding: EdgeInsets.only(left: 1 * 10.0),
    child: ExpandedList(
      initiallyExpanded: expanded,
      key: PageStorageKey<DataEntity>(root),
      title: Expanded(
        child: Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black, fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 14),
        ),
      ),
      children: list
          .map<Widget>((l) => resBuilder(
                l,
                index: list.indexOf(l),
                isLast: list.indexOf(l) == list.length - 1,
                selected: selectedItem == l,
                scrollController: scrollController,
                previewMode: previewMode,
                isFirst: isFirst,
                record: record,
                onPress: (node, [p]) {
                  if (record != null) {
                    if (node is DataEntity) {
                      record.reset();
                      node.level == 1
                          ? record.firstId = node.nodeId
                          : node.level == 2
                              ? record.secondId = node.nodeId
                              : node.level == 3
                                  ? record.thirdId = node.nodeId
                                  : null;
                      record.title = node.nodeName;
                    } else if (node is ResourceIdListEntity) {
                      record.id = node.resId;
                      record.title = node.resName;
                    }
                    saveRecord(record);
                  }
                  onPress(node, root);
                },
              ))
          .toList(),
    ),
  );
  return resWidget;
}

/// 资源的一条，每一条qi前，有一个timeline，第一条，最后一条特殊处理
Widget resBuilder(ResourceIdListEntity l,
        {bool isFirst = false,
        OnPress onPress,
        int index,
        bool isLast = false,
        bool selected = false,
        bool previewMode = false,
        SelfStudyRecord record,
        AutoScrollController scrollController}) =>
    Container(
      width: double.infinity,
      // height: 60,
      padding: EdgeInsets.only(left: 2 * 10.0),
      child: Row(
        children: <Widget>[
          timeLine(
              isFirst: index == 0,
              isLast: isLast,
              selected: record?.id == l.resId),
          Expanded(
            child: Container(
                // width: 100,
                // height: 60,
                padding: EdgeInsets.only(left: 2 * 10.0),
                child: ListTile(
                  // key: PageStorageKey<ResourceIdListEntity>(l),
                  contentPadding: EdgeInsets.only(right: 20),
                  selected: record?.id == l.resId,
                  dense: true,
                  title: Text(l.resName),
                  subtitle: Text(_getResTypeName(l.resType),
                      style: TextStyle(color: Color(0xFFA9C6DE), fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 16 : 12)),
                  trailing: previewMode ? (index < 2 && isFirst) ? _tryTag() : _lockTag() : l.studyStatus != 1 ? null : Text('已学', style: textStyle12primaryLight),
                  onTap: onPress == null
                      ? null
                      : (previewMode && (index >= 2 || !isFirst))
                          ? () {
                              showDialog(
                                  context: pageContext,
                                  builder: _dialogBuilder);
                            }
                          : () => onPress(l),
                )),
          )
        ],
      ),
    );

Widget timeLine(
    {bool isFirst = false, bool isLast = false, bool selected = false}) {
  return Container(
    height: 64,
    child: Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Container(
            color: isFirst ? Colors.transparent : Color(MyColors.line),
            width: 2,
          ),
        ),
        Container(
          width: 10,
          height: 10,
          decoration: new BoxDecoration(
            border: Border.all(
              color: Color(selected ? MyColors.primaryValue : MyColors.line),
              width: 2.0,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: Color(MyColors.primaryValue),
                        offset: Offset(0, 0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0)
                  ]
                : null,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: isLast ? Colors.transparent : Color(MyColors.line),
            width: 2,
          ),
        )
      ],
    ),
  );
}

void saveRecord(record) {
  if (record != null &&
      record.id != null &&
      record.subjectId != null &&
      record.gradeId != null &&
      record.type != null &&
      (record.title?.isNotEmpty ?? false)) {
    debugLog(record.toString(), tag: 'save');
    SharedPrefsUtils.put('record', record.toString());
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
