import 'package:online_school/common/redux/runtime_data_reducer.dart';
import 'package:online_school/common/redux/theme_data_reducer.dart';
import 'package:online_school/common/runtime_data/runtime_data.dart';
import 'package:online_school/common/theme/mtt_theme.dart';
import 'package:online_school/model/app_info.dart';
import 'package:online_school/model/config_model.dart';
import 'package:online_school/model/course_model.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/redux/app_info_reducer.dart';
import 'package:online_school/common/redux/course_reducer.dart';
import 'package:online_school/common/redux/config_reducer.dart';
import 'package:online_school/common/redux/theme_reducer_old.dart';
import 'package:online_school/common/redux/unread_msg_count_reducer.dart';
import 'package:online_school/common/redux/user_reducer.dart';
import 'package:flutter/material.dart';

import 'local_reducer.dart';

/**
  *
  * @ClassName:      AppState类
  * @Description:    类作用描述
  * @Author:         作者名：liuchuanan
  * @CreateDate:     2019-07-05 09:46
  * @UpdateUser:     更新者：
  * @UpdateDate:     2019-07-05 09:46
  * @UpdateRemark:   更新说明：
  * @Version:        1.0
 */
class AppState {
  MTTTheme theme;
  Locale locale;
  Locale platformLocale;
  RuntimeData runtimeData;

  ///用户信息
  UserInfoModel userInfo = UserInfoModel();

  AppInfo appInfo = AppInfo();
  ConfigModel config = ConfigModel();

  ///CC用户课程信息
  List<CourseEntity> cccourses = List();

  ///未读消息数
  int unread = 0;

  ///主题数据
  ThemeData themeData;
  AppState({
    this.theme,
    this.locale,
    this.runtimeData,
    this.userInfo,
    this.themeData,
    this.cccourses,
    this.unread,
    this.config,
    this.appInfo
  });
}

/**
 * @method  创建Reducer
 * @description 描述一下方法的作用
 * @date: 2019-07-05 09:47
 * @author: liuca
 * @param
 * @return
 */
AppState appReducer(AppState state, action) {
  return AppState(
    theme: ThemeDataReducer(state.theme, action),
    locale: LocaleReducer(state.locale, action),
    runtimeData: RuntimeDataReducer(state.runtimeData, action),
    ///通过 UserReducer 将 GSYState 内的 userInfo 和 action 关联在一起
    userInfo: UserReducer(state.userInfo, action),

    ///通过 ThemeDataReducer 将 GSYState 内的 themeData 和 action 关联在一起
    themeData: ThemeReducer(state.themeData, action),
    cccourses: CourseReducer(state.cccourses, action),
    unread: UnreadMsgCountReducer(state.unread, action),
    config: ConfigReducer(state.config, action),
    appInfo: AppInfoReducer(state.appInfo, action),

  );
}

