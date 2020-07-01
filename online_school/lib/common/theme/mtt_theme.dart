import 'package:flutter/material.dart';

///
/// @Class: MTTTheme
/// @Description: 主题model类
/// @author: lca
/// @Date: 2019-08-01
///
class MTTTheme {
  final Color textColor; /// 文字颜色
  final Color homeMenuColor; /// 首页menu颜色
  final Color homeIconContainerColor; /// 首页icon容器颜色
  final Color homeIconHighlightColor; /// 首页icon容器高亮颜色
  final Color homeIconColor; /// 首页icon颜色
  final Color homeIconTitleColor; /// 首页icon标题颜色
  final Color pageContainerColor; /// 页面容器背景色
  final Color homePageContainerColor; /// 首页容器背景色
  final Color appBarBackgroundColor; /// appBar颜色
  final Color appBarTitleColor; /// appBar字体颜色
  final Color commonTextColor; /// 关于页面文本颜色
  final Color settingLineColor; /// 设置页面线条颜色
  final Color settingButtonHighlightColor; /// 设置页面按钮高亮颜色
  final Color settingAppNameColor; /// 设置页面appName颜色
  final ThemeData themeData;
  final int statusBarStyleIndex; /// 状态栏索引
  final Color dialogContainerColor; /// 主题/语言dialog容器颜色
  final Color dialogTextColor; /// 主题/语言dialog容器颜色
  final Color recognizeListIconTextColor;

  MTTTheme({
    this.textColor,
    this.homeIconContainerColor,
    this.homeMenuColor,
    this.homeIconColor,
    this.themeData,
    this.statusBarStyleIndex,
    this.pageContainerColor,
    this.homePageContainerColor,
    this.appBarBackgroundColor,
    this.appBarTitleColor,
    this.commonTextColor,
    this.settingLineColor,
    this.settingButtonHighlightColor,
    this.settingAppNameColor,
    this.homeIconHighlightColor,
    this.homeIconTitleColor,
    this.dialogContainerColor,
    this.dialogTextColor,
    this.recognizeListIconTextColor,
  });
}