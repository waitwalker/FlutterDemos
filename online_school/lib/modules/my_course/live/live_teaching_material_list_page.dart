import 'dart:io';
import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/model/live_material_model.dart';
import 'package:online_school/modules/widgets/common_webview_page.dart';
import 'package:online_school/modules/widgets/list_type_loading_placehold_widget.dart';
import 'package:online_school/modules/widgets/pdf_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



///
/// @name LiveMaterialListPage
/// @description 资料包列表
/// @author liuca
/// @date 2020-01-11
///
class LiveMaterialListPage extends StatefulWidget {

  final String courseIds;
  LiveMaterialListPage(this.courseIds);
  @override
  State<StatefulWidget> createState() {
    return _LiveMaterialListState();
  }
}

class _LiveMaterialListState extends State<LiveMaterialListPage> {
  List <Data>materialList;
  AsyncMemoizer _memoizer = AsyncMemoizer();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    setState(() {
      AsyncMemoizer _memoizer = AsyncMemoizer();
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(MyColors.background),
      child: materialList != null ? _buildWidget() : FutureBuilder(builder: _builder, future: _fetchMaterialData(),),
    );
  }

  Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Text('还没有开始网络请求');
      case ConnectionState.active:
        return Text('ConnectionState.active');
      case ConnectionState.waiting:
        return Scaffold(
          appBar: AppBar(
            title: Text("资料包"),
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: Center(
              child: LoadingListWidget(),
            ),
          ),
        );
      case ConnectionState.done:
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        var liveDetailModel = snapshot.data.model as LiveMaterialModel;
        materialList = liveDetailModel?.data;
        if (materialList == null) {
          return _buildNoDataWidget();
        }
        if (liveDetailModel.code == 1 && materialList != null) {
          return _buildWidget();
        }
        return EmptyPlaceholderPage(
            assetsPath: 'static/images/empty.png',
            message: '${liveDetailModel.msg}');
    // Text('Error: ${liveDetailModel.msg}');
      default:
        return _buildNoDataWidget();;
    }
  }

  Widget _buildWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("资料包"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: Container(
        color: Color(MyColors.background),
        child: Padding(
          padding: EdgeInsets.only(top: 10,),
          child: Column(
            children: <Widget>[
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context,LoadStatus mode){
                      Widget body ;
                      if(mode==LoadStatus.idle){
                        body =  Text("上拉加载");
                      }
                      else if(mode==LoadStatus.loading){
                        body =  CupertinoActivityIndicator();
                      }
                      else if(mode == LoadStatus.failed){
                        body = Text("加载失败！点击重试！");
                      }
                      else if(mode == LoadStatus.canLoading){
                        body = Text("松手,加载更多!");
                      }
                      else{
                        body = Text("没有更多数据了!");
                      }
                      return Container(
                        height: 55.0,
                        child: Center(child:body),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  //onLoading: _onLoading,
                  child: ListView.builder(
                    itemBuilder: _itemBuilder,
                    itemCount: materialList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  ///
  /// @name _buildNoDataWidget
  /// @description 没有数据占位
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-13
  ///
  Widget _buildNoDataWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text("资料包"),
        backgroundColor: Colors.white,
        centerTitle: Platform.isIOS ? true : false,
      ),
      body: EmptyPlaceholderPage(
          assetsPath: 'static/images/empty.png', message: '没有数据'),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Data model = materialList[index];
    return ListTile(
      leading: Icon(MyIcons.DOCUMENT),
      title: Text(model.name),
      trailing: Icon(
        MyIcons.ARROW_R,
        size: 15,
      ),
      onTap: () async {
        if (model?.fileUrl == null) {
          Fluttertoast.showToast(msg: '暂无资料包');
          return;
        }
        var regex = 'https?://(\\w+\\.)+(\\w+/)+(\\w+).pdf';
        var re = new RegExp(regex);
        var pdfUrl = re.firstMatch(model.fileUrl)?.group(0);
        if (pdfUrl != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return PDFPage(
              pdfUrl,
              title: model.name,
            );
          }));
        } else {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return WebviewPage(model.fileUrl, title: model.name);
          }));
        }
      },
    );
  }

  ///
  /// @name _fetchMaterialData
  /// @description 获取资料包列表
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-11
  ///
  _fetchMaterialData() {
    return _memoizer.runOnce(()=>DaoManager.fetchLiveMaterial({"courseIds":widget.courseIds}));
  }

}