import 'dart:ui';
import 'package:flutter/material.dart';
import 'string_base.dart';
import 'string_en.dart';
import 'string_zh.dart';


///自定义多语言实现
class MTTLocalization {
  final Locale locale;

  MTTLocalization(this.locale);

  ///根据不同 locale.languageCode 加载不同语言对应
  ///MTTStringEn和MTTStringZh都继承了MTTStringBase
  static Map<String, MTTStringBase> _localizedValues = {
    'en': MTTStringEn(),
    'zh': MTTStringZh(),
  };

  MTTStringBase get currentLocalized {
    return _localizedValues[locale.languageCode];
  }

  ///通过 Localizations 加载当前的 MTTLocalizations
  ///获取对应的 MTTStringBase
  static MTTLocalization of(BuildContext context) {
    return Localizations.of(context, MTTLocalization);
  }
}