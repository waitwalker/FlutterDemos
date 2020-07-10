import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/model/message_list_model.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/empty_placeholder_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'message_detail_page.dart';


enum LoadMoreStatus { loading, failed, noData }


///
/// @name MessageListPage
/// @description 消息列表
/// @author liuca
/// @date 2020-01-11
///
class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  String versionName;
  var _scrollController = ScrollController();

  var loadMoreStatus = LoadMoreStatus.loading;
  int currentPage = 1;
  List<Message> list = [];
  bool loadmore = true;

  @override
  void initState() {
    super.initState();
    // getData();
    onLoadMore();
    _scrollController.addListener(() {
      var maxScroll = _scrollController.position.maxScrollExtent;
      if (_scrollController.offset >= maxScroll) {
        if (loadMoreStatus != LoadMoreStatus.noData) {
          onLoadMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的消息'),
        elevation: 1.0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(MyColors.background),
      body: _buildBody(),
    );
  }

  Store<AppState> _getStore() => StoreProvider.of<AppState>(context);

  Future onLoadMore() async {
    var response =
        await CourseDaoManager.messageList(pageSize: 10, currentPage: currentPage++);
    if (response.result) {
      var model = response.model as MessageListModel;
      var more = model?.data?.list;
      if ((more?.length ?? 0) > 0) {
        setState(() {});
        list.addAll(more);
        if ((more?.length ?? 0) < 10) {
          loadmore = false;
          loadMoreStatus = LoadMoreStatus.noData;
        }
      } else {}
    }
    return response;
  }

  _buildBody() {
    if (list.length == 0 && loadMoreStatus == LoadMoreStatus.noData) {
      return EmptyPlaceholderPage(
          assetsPath: 'static/images/empty.png', message: '没有数据');
    } else {
      return _messageList();
    }
  }

  _messageList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: list?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(list.elementAt(index));
      },
    );
  }

  _buildItem(Message item) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 25),
          child: Container(
            height: 110,
            decoration: _boxDecoration(),
            child: Stack(children: <Widget>[
              Positioned.directional(
                  top: 18,
                  start: 18,
                  end: 18,
                  textDirection: TextDirection.ltr,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.msgTitle,
                          style: textStyleCalendarMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 12),
                      Text(item.msgContent,
                          style: textStyleSub999,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  )),
              Positioned.directional(
                end: 12,
                bottom: 12,
                textDirection: TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('查看', style: TextStyle(fontSize: 11, color: Color(MyColors.black666))),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Icon(MyIcons.ARROW_R, size: 11, color: Colors.grey),
                ],),
              ),
              if (item.userMsgState == 0)
                Positioned.directional(
                    end: 12,
                    top: 12,
                    textDirection: TextDirection.ltr,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        //用一个BoxDecoration装饰器提供背景图片
                        borderRadius: BorderRadius.all(Radius.circular(3.5)),
                      ),
                    )),
            ]),
          ),
        ),
        onTap: () => _onTapCard(item));
  }

  void _onTapCard(Message item) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => MessageDetailPage(
                msgId: item.msgId, unread: item.userMsgState == 0)))
        .then((_) {
      item.userMsgState = 1;
      setState(() {});
    });
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
