import 'package:online_school/model/config_model.dart';
import 'package:redux/redux.dart';

/**
 * 用户相关Redux
 */

/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateUserAction 与 reducers 关联起来
final ConfigReducer = combineReducers<ConfigModel>([
  TypedReducer<ConfigModel, UpdateConfigAction>(_updateLoaded),
]);

/// 如果有 UpdateConfigAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的ConfigInfo，并返回
ConfigModel _updateLoaded(ConfigModel config, action) {
  config = action.config;
  return config;
}

///定一个 UpdateUserAction ，用于发起 configInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateConfigAction {
  final ConfigModel config;

  UpdateConfigAction(this.config);
}
