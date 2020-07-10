import 'package:online_school/common/theme/mtt_theme.dart';
import 'package:redux/redux.dart';


/// 事件Reduc

/// 通过combineRecucers实现Reducer
final ThemeDataReducer = combineReducers<MTTTheme>([
  TypedReducer<MTTTheme,RefreshThemeDataAction>(_refresh),
]);

/// 定义处理Action方法,返回新的State
MTTTheme _refresh(MTTTheme theme, action){
  theme = action.theme;
  return theme;
}

/// 定义Action,将Action在Reducer中与处理该Action的方法绑定
///
/// @Class: RefreshThemeDataAction
/// @Description: 主题Action
/// @author: lca
/// @Date: 2019-08-01
///
class RefreshThemeDataAction {
  final MTTTheme theme;
  RefreshThemeDataAction(this.theme);
}