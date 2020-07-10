import 'package:flutter/material.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';

ThemeData appTheme = new ThemeData(
  primaryColor: new Color.fromRGBO(102, 51, 153, 0.8),
  primaryTextTheme: new TextTheme(
    display1: new TextStyle(
      color: new Color.fromRGBO(68, 68, 68, 1.0),
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    display2: new TextStyle(
      color: new Color.fromRGBO(153, 153, 153, 1.0),
      fontSize: 11.0,
      fontWeight: FontWeight.w100,
    ),
    display3: new TextStyle(
      color: new Color.fromRGBO(153, 153, 153, 1.0),
      fontSize: 10.0,
      fontWeight: FontWeight.bold,
    ),
    display4: new TextStyle(
      color: new Color.fromRGBO(153, 153, 153, 1.0),
      fontSize: 11.0,
      fontWeight: FontWeight.w400,
    ),
  ),
  iconTheme: new IconThemeData(
    color: const Color.fromRGBO(35, 92, 254, 10.0),
  ),
  primaryColorBrightness: Brightness.light,
  secondaryHeaderColor: new Color.fromRGBO(255, 255, 255, 10.0),
);
const Color transparentColor = const Color.fromRGBO(0, 0, 0, 0.2);
List<Color> kitGradients2 = [Color(0xffb7ac50), Colors.orange.shade900];

// custom style of text

TextStyle textStyleMini = TextStyle(fontSize: 8, color: Color(MyColors.black333));
TextStyle textStyleWhite = TextStyle(fontSize: 9, color: Colors.white);
TextStyle textStyle9999 = TextStyle(fontSize: 9, color: Color(0xff979797));
TextStyle textStyle10ccc = TextStyle(
  fontSize: 10,
  color: Color(MyColors.ccc),
  decoration: TextDecoration.none,
  fontWeight: FontWeight.w200,
);
TextStyle textStyle10BlackMiduim = TextStyle(
  fontSize: 10,
  color: Colors.black,
  fontWeight: FontWeight.w700,
);
TextStyle textStyle10999 = TextStyle(fontSize: 10, color: Color(MyColors.black999));
TextStyle textStyle10Time = TextStyle(fontSize: 10, color: Color(MyColors.txt_time));
TextStyle textStyle10White = TextStyle(fontSize: 10, color: Colors.white);
TextStyle textStyle11666 = TextStyle(fontSize: 11, color: Color(MyColors.black666));
TextStyle textStyle11999 =
    TextStyle(fontSize: 11, color: Color(MyColors.black999));
TextStyle textStyle11Blue =
    TextStyle(fontSize: 11, color: Color(MyColors.primaryLightValue));
TextStyle textStyle11White = TextStyle(fontSize: 11, color: Colors.white);
TextStyle textStyle12ccc = TextStyle(fontSize: 12, color: Color(MyColors.ccc));
TextStyle textStyle12666 = TextStyle(fontSize: 12, color: Color(MyColors.black666));
TextStyle textStyle12999 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w200,
    letterSpacing: 2,
    color: Color(MyColors.black999),
    decoration: TextDecoration.none);
TextStyle textStyle12Black =
    TextStyle(fontSize: 12, color: Color(MyColors.black222));
TextStyle textStyle12LightGrey =
    TextStyle(fontSize: 12, color: Color(MyColors.shadow2));
TextStyle textStyle12primaryLight =
    TextStyle(fontSize: 12, color: Color(MyColors.courseScheduleCardLight));
TextStyle textStyle12primary =
    TextStyle(fontSize: 12, color: Color(MyColors.primaryValue));
TextStyle textStyle12WhiteBold =
    TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold);
TextStyle textStyle13WhiteMid =
    TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w400);
TextStyle textStyle13TitleBlackMid = TextStyle(
    fontSize: 13,
    color: Color(MyColors.title_black),
    fontWeight: FontWeight.bold);
TextStyle textStyleSub333 =
    TextStyle(fontSize: 13, color: Color(MyColors.black333));
TextStyle textStyleSub =
    TextStyle(fontSize: 13, color: Color(MyColors.black666));
TextStyle textStyleSub999 =
    TextStyle(fontSize: 13, color: Color(MyColors.black999));
TextStyle textStyleSubTime =
    TextStyle(fontSize: 13, color: Color(MyColors.txt_time));
TextStyle textStyleSubWhite = TextStyle(fontSize: 13, color: Colors.white);
TextStyle textStyleSubLargeBlack =
    TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
TextStyle textStyleSubLargeBlue =
    TextStyle(fontSize: 14, color: Color(MyColors.primaryLightValue));
TextStyle textStyleSubLarge333 =
    TextStyle(fontSize: 14, color: Color(MyColors.black333));
TextStyle textStyleSubLarge333Bold = TextStyle(
    fontSize: 14, color: Color(MyColors.black333), fontWeight: FontWeight.bold);
TextStyle textStyleSubLarge =
    TextStyle(fontSize: 14, color: Color(MyColors.black666));
TextStyle textStyle14999 =
    TextStyle(fontSize: 14, color: Color(MyColors.black999));
TextStyle textStyle14Normal = TextStyle(fontSize: 14, color: Color(MyColors.title_black),);
TextStyle textStyletitle = TextStyle(
    fontSize: 14,
    color: Color(MyColors.title_black),
    fontWeight: FontWeight.w600);
TextStyle textStyleBtnWhite =
    TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);
TextStyle textStyle15White = TextStyle(fontSize: 15, color: Colors.white);
TextStyle textStyleNormal = TextStyle(fontSize: SingletonManager.sharedInstance.screenWidth > 500.0 ? 18 : 15, color: Color(MyColors.black333));
TextStyle textStyleNormal666 =
    TextStyle(fontSize: 15, color: Color(MyColors.black666));
TextStyle textStyleNormalMedium =
    TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
TextStyle textStyleHint = TextStyle(fontSize: 15, color: Color(MyColors.black999));
TextStyle textStyleHintPrimary =
    TextStyle(fontSize: 15, color: Color(MyColors.primaryValue));
TextStyle textStyleTab = TextStyle(fontSize: 16, color: Colors.black);
TextStyle textStyleContent = TextStyle(fontSize: 16, color: Color(MyColors.black666));
TextStyle textStyleContentMedium = TextStyle(
    fontSize: 16, color: Color(MyColors.black666), fontWeight: FontWeight.bold);
TextStyle textStyleCalendarWhiteMedium =
    TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
TextStyle textStyleCalendarMedium = TextStyle(fontSize: 16, color: Color(MyColors.title_black), fontWeight: FontWeight.w600);
TextStyle textStyleContent222 =
    TextStyle(fontSize: 16, color: Color(MyColors.black222));
TextStyle textStyleContent333 = TextStyle(fontSize: 16, color: Color(MyColors.black333));
TextStyle textStyleContentMid333 = TextStyle(
    fontSize: 16, color: Color(MyColors.black333), fontWeight: FontWeight.bold);
TextStyle textStyleTabUnselected =
    TextStyle(fontSize: 16, color: Color(MyColors.black999));
TextStyle textStyleLarge =
    TextStyle(fontSize: 17, color: Color(MyColors.black333));
TextStyle textStyleLargeTitle = TextStyle(fontSize: 17, color: Color(MyColors.title_black), fontWeight: FontWeight.bold);
TextStyle textStyleLarge999 =
    TextStyle(fontSize: 17, color: Color(MyColors.black999));
TextStyle textStyleLargeWhite = TextStyle(fontSize: 17, color: Colors.white);
TextStyle textStyleLargeNormal = TextStyle(
    fontSize: 18,
    color: Color(MyColors.black333),
    fontWeight: FontWeight.normal);
TextStyle textStyleLargeMedium = TextStyle(
    fontSize: 18, color: Color(MyColors.black333), fontWeight: FontWeight.bold);
TextStyle textStyleLargeWhiteMedium =
    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500);
TextStyle textStyle18WhiteBold =
    TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);
TextStyle textStyleLargeMediumPrimary = TextStyle(
    fontSize: 18,
    color: Color(MyColors.primaryValue),
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold);
TextStyle textStyle24666 = TextStyle(
  color: Color(MyColors.black666),
  fontSize: 24,
  fontWeight: FontWeight.w500,
  decoration: TextDecoration.none,
);
TextStyle textStyle24222 = TextStyle(
  color: Color(MyColors.black222),
  fontSize: 24,
  fontWeight: FontWeight.bold,
  decoration: TextDecoration.none,
);
TextStyle textStyle25Primary =
    TextStyle(color: Color(MyColors.primaryValue), fontSize: 25);

///颜色
class MyColors {
  static const int primaryValue = 0xFFFF9918;
  static const int primaryLightValue = 0xFF6B8DFF;
  static const int primaryDarkValue = 0xFF121917;

  static const int cardWhite = 0xFFFFFFFF;
  static const int textWhite = 0xFFFFFFFF;
  static const int miWhite = 0xffececec;
  static const int white = 0xFFFFFFFF;
  static const int actionBlue = 0xff267aff;
  static const int subTextColor = 0xff959595;
  static const int subLightTextColor = 0xffc4c4c4;
  static const int cardEndTimeGrey = 0xffD5DAEB;
  static const int subjectDot = 0xffBABBD4;
  static const int subjectTopText = 0xffA9ABC9;
  static const int liveNotice = 0xffE39524;

  static const int courseScheduleCardMain = 0xFF6B85FF;
  static const int courseScheduleCardLight = 0xFF6A99FF;
  static const int eyeProtectGrey = 0xff666666;
  static const int eyeProtectBackground = 0xff666666;
  static const int eyeProtectRemindBlack = 0xff212121;

  static const Color normalTextColor = Color.fromRGBO(0, 0, 0, 0.87);

  static const int mainBackgroundColor = miWhite;

  static const int mainTextColor = primaryDarkValue;
  static const int textColorWhite = white;

  static const int black = 0xff000000;
  static const int black222 = 0xff222222;
  static const int black333 = 0xff333333;
  static const int black666 = 0xff666666;
  static const int black999 = 0xff999999;
  static const int ccc = 0xffcccccc;
  static const int cccp4 = 0x66cccccc;
  static const int line = 0xFFE0E0E0;
  static const int background = 0xFFF2F7FF;
  static const int choosedLine = 0xFFF5F5F5;
  static const int shadow = 0x33000000;
  static const int shadow2 = 0x66000000;
  static const int tagblue = 0xFF4A90E2;
  static const int tagblue02 = 0x194A90E2;
  static const int title_black = 0xFF262525;
  static const int txt_time = 0xFFAEAEAE;
  static const int btn_solid = 0xFFF7B71D;

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

class MyIcons {
  static const FONT_FAMILY = 'aliIconFont';

  // static const IconData SETTINGS =
  //     const IconData(0xe67f, fontFamily: FONT_FAMILY);
  static const IconData DELETE =
      const IconData(0xe6bc, fontFamily: FONT_FAMILY);
  static const IconData VISIABLE =
      const IconData(0xe6bb, fontFamily: FONT_FAMILY);
  static const IconData INVISIABLE =
      const IconData(0xe6ba, fontFamily: FONT_FAMILY);
  static const IconData CLOSE = const IconData(0xe6b9, fontFamily: FONT_FAMILY);
  static const IconData SCHEDULE =
      const IconData(0xe6bd, fontFamily: FONT_FAMILY);
  static const IconData MINE_TAB =
      const IconData(0xe6c0, fontFamily: FONT_FAMILY);
  static const IconData COURSE_TAB =
      const IconData(0xe6c1, fontFamily: FONT_FAMILY);
  static const IconData ACTIVATE =
      const IconData(0xe6d0, fontFamily: FONT_FAMILY);
  static const IconData SETTING_DOWNLOAD =
      const IconData(0xe6ce, fontFamily: FONT_FAMILY);
  static const IconData SETTING =
      const IconData(0xe6d2, fontFamily: FONT_FAMILY);
  static const IconData BIND = const IconData(0xe6d1, fontFamily: FONT_FAMILY);
  static const IconData ARROW_R =
      const IconData(0xe6d3, fontFamily: FONT_FAMILY);
  static const IconData UNCHECKED =
      const IconData(0xe6dd, fontFamily: FONT_FAMILY);
  static const IconData CHECKED =
      const IconData(0xe6de, fontFamily: FONT_FAMILY);
  static const IconData DOWNLOAD =
      const IconData(0xe6df, fontFamily: FONT_FAMILY);
  static const IconData ANSWER_CARD =
      const IconData(0xe6e1, fontFamily: FONT_FAMILY);
  static const IconData PENCIL =
      const IconData(0xe6e3, fontFamily: FONT_FAMILY);
  static const IconData ARROW_UP =
      const IconData(0xe6e5, fontFamily: FONT_FAMILY);
  static const IconData ARROW_DOWN =
      const IconData(0xe6e6, fontFamily: FONT_FAMILY);
  static const IconData SUPPORT =
      const IconData(0xe6ea, fontFamily: FONT_FAMILY);
  static const IconData LIVE = const IconData(0xe6e9, fontFamily: FONT_FAMILY);
  static const IconData FEEDBACK =
      const IconData(0xe6e8, fontFamily: FONT_FAMILY);
  static const IconData DOCUMENT =
      const IconData(0xe6e7, fontFamily: FONT_FAMILY);
  static const IconData ORDER = const IconData(0xe6eb, fontFamily: FONT_FAMILY);
  static const IconData HELP = const IconData(0xe6f2, fontFamily: FONT_FAMILY);
  static const IconData MORE = const IconData(0xe698, fontFamily: FONT_FAMILY);
  static const IconData MINUS = const IconData(0xe6f5, fontFamily: FONT_FAMILY);
  static const IconData PLUS = const IconData(0xe6f6, fontFamily: FONT_FAMILY);
  static const IconData REPORT =
      const IconData(0xe729, fontFamily: FONT_FAMILY);
  static const IconData ERROR_BOOK =
      const IconData(0xe722, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_YUWEN =
      const IconData(0xe745, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_SHUXUE =
      const IconData(0xe73F, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_YINGYU =
      const IconData(0xe741, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_WULI =
      const IconData(0xe749, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_HUAXUE =
      const IconData(0xe748, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_SHENGWU =
      const IconData(0xe74c, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_ZHENGZHI =
      const IconData(0xe74b, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_LISHI =
      const IconData(0xe74a, fontFamily: FONT_FAMILY);
  static const IconData SUBJECT_DILI =
      const IconData(0xe747, fontFamily: FONT_FAMILY);
  static const IconData EYE_PROTECTION =
      const IconData(0xe76d, fontFamily: FONT_FAMILY);
  static const IconData NEW_DOWNLOAD =
      const IconData(0xe787, fontFamily: FONT_FAMILY);
  static const IconData NEW_PLAY =
      const IconData(0xe788, fontFamily: FONT_FAMILY);
  static const IconData SWITCH =
      const IconData(0xe78a, fontFamily: FONT_FAMILY);
  static const IconData MESSAGE =
      const IconData(0xe7fe, fontFamily: FONT_FAMILY);
  static const IconData CAMERA =
      const IconData(0xe806, fontFamily: FONT_FAMILY);
  static const IconData REMOVE =
      const IconData(0xe808, fontFamily: FONT_FAMILY);
  static const IconData RIGHT = const IconData(0xe80a, fontFamily: FONT_FAMILY);
  static const IconData WRONG = const IconData(0xe80b, fontFamily: FONT_FAMILY);
  static const IconData HOMEWORK = const IconData(0xe828, fontFamily: FONT_FAMILY);
}
