import 'dart:core';

import 'package:intl/intl.dart';

class DateUtils {
  static DateTime convertToDate(String date) {
    if (date != null) {
      return DateTime.parse(date);
    }
    return DateTime.now();
  }

  static String currentTimeStamp() {
    return DateTime.now().toIso8601String();
  }

  static String formateCourseNotStartedDate(String date) {
    if (date != null) {
      return DateFormat.yMMMEd().format(convertToDate(date));
    }
    return null;
  }

  static String formateDateWithNoYear(DateTime date) {
    if (date != null) return DateFormat('M月d日', 'zh_CN').format(date);
    return '';
  }

  static String formateDateMdEhm(DateTime date) {
    if (date != null)
      return DateFormat('MM月d日 · E HH:mm', 'zh_CN').format(date);
    return '';
  }

  static String formateDateMdhm(DateTime date) {
    if (date != null) return DateFormat('M月d日 HH:mm', 'zh_CN').format(date);
    return '';
  }
}
