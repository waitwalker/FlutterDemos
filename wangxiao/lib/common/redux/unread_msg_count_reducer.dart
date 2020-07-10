import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:redux/redux.dart';

/**
 * 消息相关Redux
 */

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final UnreadMsgCountReducer = combineReducers<int>([
  TypedReducer<int, UpdateMsgAction>(_updateLoaded),
]);

/// 如果有 UpdateMsgAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的ConfigInfo，并返回
int _updateLoaded(int count, action) {
  count = action.count;
  JPush().setBadge(count);
  return count;
}

///定一个 UpdateMsgAction ，用于发起 configInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateMsgAction {
  final int count;

  UpdateMsgAction(this.count);
}
