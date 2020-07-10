import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/message_detail_model.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/unread_msg_count_reducer.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:async/async.dart';

import '../../widgets/list_type_loading_placehold_widget.dart';

///
/// @name MessageDetailPage
/// @description 消息列表详情页面
/// @author liuca
/// @date 2020-01-11
///
class MessageDetailPage extends StatefulWidget {
  var msgId;
  bool unread;

  MessageDetailPage({this.msgId, this.unread = true});
  @override
  _MessageDetailPageState createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  String versionName;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    if (widget.unread) {
      CourseDaoManager.setMessageStatus(msgId: widget.msgId, status: 1 /*read*/)
          .then((_) {
        var unread = _getStore().state.unread;
        _getStore().dispatch(UpdateMsgAction(--unread));
      });
    }
  }

  Store<AppState> _getStore() => StoreProvider.of<AppState>(context);

  Future getData() =>
      _memoizer.runOnce(() => CourseDaoManager.messageDetail(msgId: widget.msgId));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('消息详情'),
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(MyColors.background),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return FutureBuilder(
      future: getData(),
      initialData: null,
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
            ResponseData result = snapshot.data;
            var model = result.model as MessageDetailModel;
            if (model?.data == null) {
              return EmptyPlaceholderPage(
                  assetsPath: 'static/images/empty.png', message: '没有数据');
            }
            return _messageContent(model.data);
          default:
            return Text('xx');
        }
      },
    );
  }

  _messageContent(var data) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 16, right: 16, top: 25, bottom: 25),
      child: Container(
          padding: EdgeInsets.all(18),
          width: MediaQuery.of(context).size.width,
          child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(data.releaseTime, style: textStyleSubTime),
                const SizedBox(height: 7),
                Text(data.msgTitle, style: textStyleCalendarMedium),
                const SizedBox(height: 20),
                Text(data.msgContent, style: textStyleSub999),
              ]),
          decoration: _boxDecoration()),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color(0x66B2C1D9),
            offset: Offset(0, 1),
            blurRadius: 5.0,
            spreadRadius: 0.0)
      ],
    );
  }
}
