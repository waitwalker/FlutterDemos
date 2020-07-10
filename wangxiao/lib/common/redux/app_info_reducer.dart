import 'package:online_school/model/app_info.dart';
import 'package:redux/redux.dart';


///
/// @name
/// @description app info reducer
/// @author liuca
/// @date 2020-01-11
///
/// redux 的 combineReducers, 通过 TypedReducer 将 UpdateAppInfoAction 与 reducers 关联起来
final AppInfoReducer = combineReducers<AppInfo>([
  TypedReducer<AppInfo, UpdateAppInfoAction>(_updateLoaded),
  TypedReducer<AppInfo, UpdateReplaceAppInfoAction>(_updateReplaceLoaded),
]);

/// 如果有 UpdateAppInfoAction 发起一个请求时
/// 就会调用到 _updateLoaded
/// _updateLoaded 这里接受一个新的appInfoInfo，并返回
AppInfo _updateLoaded(AppInfo appInfo, action) {
  return appInfo.merge(action.appInfo);
}

AppInfo _updateReplaceLoaded(AppInfo appInfo, action) {
  appInfo = action.appInfo;
  return appInfo;
}

///定一个 UpdateAppInfoAction ，用于发起 appInfoInfo 的的改变
///类名随你喜欢定义，只要通过上面TypedReducer绑定就好
class UpdateAppInfoAction {
  final AppInfo appInfo;

  UpdateAppInfoAction(this.appInfo);
}

class UpdateReplaceAppInfoAction {
  final AppInfo appInfo;

  UpdateReplaceAppInfoAction(this.appInfo);
}
