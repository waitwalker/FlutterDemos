import 'package:online_school/common/redux/theme_data_reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'mtt_theme.dart';

///颜色
class MTTColors {
  static const String primaryValueString = "#24292E";
  static const String primaryLightValueString = "#42464b";
  static const String primaryDarkValueString = "#121917";
  static const String miWhiteString = "#ececec";
  static const String actionBlueString = "#267aff";
  static const String webDraculaBackgroundColorString = "#282a36";

  static const int primaryValue = 0xFF24292E;
  static const int primaryLightValue = 0xFF42464b;
  static const int primaryDarkValue = 0xFF121917;

  static const int cardWhite = 0xFFFFFFFF;
  static const int textWhite = 0xFFFFFFFF;
  static const int miWhite = 0xffececec;
  static const int white = 0xFFFFFFFF;
  static const int actionBlue = 0xff267aff;
  static const int subTextColor = 0xff959595;
  static const int subLightTextColor = 0xffc4c4c4;

  static const int mainBackgroundColor = miWhite;
  static const int mainTextColor = primaryDarkValue;
  static const int textColorWhite = white;

  static const MaterialColor primarySwatch = const MaterialColor(
    primaryValue,
    const <int, Color>{
      50: const Color(primaryLightValue),
      100: const Color(primaryLightValue),
      200: const Color(primaryLightValue),
      300: const Color(primaryLightValue),
      400: const Color(primaryLightValue),
      500: const Color(primaryValue),
      600: const Color(primaryDarkValue),
      700: const Color(primaryDarkValue),
      800: const Color(primaryDarkValue),
      900: const Color(primaryDarkValue),
    },
  );
}

///
/// @Class: ThemeManager
/// @Description: 主题管理类 切换主题等功能
/// @author: lca
/// @Date: 2019-08-01
///
class ThemeManager {

  static getTheme(int index) {
    List<MTTTheme> themeList = [
      MTTTheme(
          textColor: Colors.black,
          homeIconContainerColor: Colors.black,
          homeIconColor: Color(0xff34443D),
          homeMenuColor: Color(0xff34443D),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xffF8D353),
          appBarBackgroundColor: Color(0xffF8D353),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xff34443D),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.65),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.orange,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Colors.yellow,
          homeIconContainerColor: Colors.black,
          homeIconColor: Colors.yellow,
          homeMenuColor: Colors.yellow,
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xff5A8973),
          appBarBackgroundColor: Color(0xff5A8973),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xffF4B249),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.65),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.green,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Colors.red,
          homeIconContainerColor: Colors.black,
          homeIconColor: Color(0xff6F7394),
          homeMenuColor: Color(0xff6F7394),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xffF1D6E1),
          appBarBackgroundColor: Color(0xffF1D6E1),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xff6F7394),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.65),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.cyan,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Colors.blue,
          homeIconContainerColor: Colors.black,
          homeIconColor: Color(0xff1F0216),
          homeMenuColor: Color(0xff1F0216),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xffD1B99F),
          appBarBackgroundColor: Color(0xffD1B99F),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xff1F0216),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.65),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.purple,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Colors.deepPurple,
          homeIconContainerColor: Colors.black,
          homeIconColor: Color(0xff46655D),
          homeMenuColor: Color(0xff46655D),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xff9FC7DF),
          appBarBackgroundColor: Color(0xff9FC7DF),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xff46655D),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.65),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.lightGreenAccent,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Colors.cyan,
          homeIconContainerColor: Colors.black,
          homeIconColor: Color(0xffC7DCE8),
          homeMenuColor: Color(0xffC7C8CA),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xffF2F7FF),
          homePageContainerColor: Color(0xff4344A1),
          appBarBackgroundColor: Color(0xff4344A1),
          appBarTitleColor: Colors.white,
          commonTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          settingLineColor: Color.fromRGBO(0, 0, 0, 0.25),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xffC7C8CA),
          homeIconTitleColor: Color.fromRGBO(0, 0, 0, 0.85),
          dialogContainerColor:Color(0xffF2F7FF),
          dialogTextColor: Color.fromRGBO(0, 0, 0, 0.85),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.brown,brightness: Brightness.light)
      ),

      MTTTheme(
          textColor: Color(0xffDCDCDC),
          homeIconContainerColor: Colors.black,
          homeIconColor: Colors.white,
          homeMenuColor: Color(0xffC7C8CA),
          statusBarStyleIndex: 1,
          pageContainerColor: Color(0xff1E1E1E),
          homePageContainerColor: Color(0xff1E1E1E),
          appBarBackgroundColor: Color(0xff85A6A0),
          appBarTitleColor: Color(0xffDCDCDC),
          commonTextColor: Color(0xffDCDCDC),
          settingLineColor: Color(0xff545454),
          settingButtonHighlightColor: Colors.lightBlue,
          settingAppNameColor: Colors.white,
          homeIconHighlightColor: Color(0xffC7C8CA),
          homeIconTitleColor: Color(0xffDCDCDC),
          dialogContainerColor:Color(0xffC7C8CA),
          dialogTextColor: Color(0xff85A6A0),
          recognizeListIconTextColor: Colors.white,
          themeData: ThemeData(primaryColor: Colors.brown,brightness: Brightness.light)
      ),

    ];
    return themeList[index];
  }

  ///
  /// @Method: pushTheme
  /// @Parameter: store index
  /// @ReturnType:
  /// @Description: 更换主题
  /// @author: lca
  /// @Date: 2019-08-01
  ///
  static pushTheme(Store store, int index) {
    MTTTheme theme = getTheme(index);
    store.dispatch(new RefreshThemeDataAction(theme));
  }

  static getThemeData(Color color) {
    return ThemeData(primarySwatch: color);
  }

  static defaultTheme() {
    return MTTTheme(
        textColor: Colors.yellow,
        homeIconContainerColor: Colors.black,
        homeIconColor: Colors.yellow,
        homeMenuColor: Colors.yellow,
        themeData: ThemeData(primaryColor: Colors.white)
    );
  }
}
