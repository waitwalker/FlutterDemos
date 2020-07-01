import 'dart:ui';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/redux/local_reducer.dart';
import 'package:redux/redux.dart';


///
/// @Class: LocaleManager
/// @Description: 国际化管理类
/// @author: lca
/// @Date: 2019-08-01
///
class LocaleManager {

  static getLocale(int index) {
    List<Locale> localeList = [
      Locale('zh',"CH"),
      Locale('en',"US")
    ];
    return localeList[index];
  }

  static titleList(int index) {
    List<String> titleList = [
      "中文",
      "英文"
    ];
    return titleList[index];
  }

  ///
  /// @Method: changeLocale
  /// @Parameter: store index
  /// @ReturnType:
  /// @Description: 切换语言
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static changeLocale(Store<AppState> store, int index) {
    store.dispatch(RefreshLocaleAction(getLocale(index)));
  }

}