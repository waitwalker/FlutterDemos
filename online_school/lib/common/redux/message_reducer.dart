import 'package:online_school/model/message_list_model.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:redux/redux.dart';

/**
 * 消息相关Redux
 */
/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final MsgReducer = combineReducers<List<Message>>([
  TypedReducer<List<Message>, UpdateMsgAction>(_updateLoaded),
]);

/// 如果有 UpdateMsgAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的ConfigInfo，并返回
List<Message> _updateLoaded(List<Message> msgs, action) {
  msgs = action.count;
  var len = msgs?.where((m) => m.userMsgState == 0)?.length ?? 0;
  JPush().setBadge(len);
  return msgs;
}

///定一个 UpdateMsgAction ，用于发起 configInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateMsgAction {
  final List<Message> msgs;

  UpdateMsgAction(this.msgs);
}
