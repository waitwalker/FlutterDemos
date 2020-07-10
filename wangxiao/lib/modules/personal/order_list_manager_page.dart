import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/model/order_list_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

///
/// @name 我的卡记录页面
/// @description
/// @author liuca
/// @date 2020-01-11
///
class OrderListManagerPage extends StatefulWidget {
  @override
  _OrderListManagerPageState createState() => _OrderListManagerPageState();
}

class _OrderListManagerPageState extends State<OrderListManagerPage> {
  AsyncMemoizer _memoizer;
  List<DataEntity> detailData;

  @override
  void initState() {
    _memoizer = AsyncMemoizer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          title: Text(MTTLocalization.of(context).currentLocalized.my_card_page_navigator_title),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
        ),
        body: FutureBuilder(builder: _futureBuilder, future: _fetchData()),
      );
    });
  }

  Widget _futureBuilder(BuildContext context, AsyncSnapshot snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.done:
        var model = snapshot.data.model as OrderListModel;
        if (model == null || model.code != 1) {
          return EmptyPlaceholderPage();
        }
        detailData = model.data;
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
    return _memoizer.runOnce(() => CourseDaoManager.getOrderList());
  }

  Widget _createView() {
    return ListView.builder(
      itemBuilder: _itemBuilder,
      itemCount: detailData.length,
      padding: EdgeInsets.only(top: 10),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var item = detailData[index];
    return Card(
        elevation: 2.0,
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(4.0)), //设置圆角
            boxShadow: <BoxShadow>[
              new BoxShadow(
                color: const Color(MyColors.background),
                blurRadius: 8.0,
                spreadRadius: 3.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 13, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.courseCardName,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: textStyleLarge,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('激活期：${item.activationTime ?? "--"}', style: TextStyle(fontSize: 13, color: Color(MyColors.black666)),),
                ],
              ),
            ],
          ),
        ));
  }
}
