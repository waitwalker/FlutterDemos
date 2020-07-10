import 'dart:async';

import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'share_preference.dart';

class ReportTimer {
  static final int report_seconds = 5 * (Config.DEBUG ? 12 : 12);
  static Timer _timer;
  static Stopwatch _stopwatch;

  static var logId = 0;

  static Future startReportTimer(BuildContext context,
      {Duration startAt}) async {
    if (_timer?.isActive ?? false) {
      return;
    }
    bool isOpen = SharedPrefsUtils.get<bool>('report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    int timeElapsed = 0;
    if (_stopwatch == null) {
      _stopwatch = Stopwatch()..start();
      showToast(msg: '开始计时');
    } else {
      // 读取计时器的已消耗时间，如果有，在timer里减去
      timeElapsed = _stopwatch.elapsed.inSeconds;
      _stopwatch = _stopwatch..start();
      showToast(msg: '恢复计时');
    }

    int timeRemain = report_seconds - timeElapsed;
    reportRunnable(null);
    _timer = Timer.periodic(Duration(seconds: timeRemain), reportRunnable);
  }

  static void reportRunnable(Timer timer) async {
    debugLog('${_timer?.tick}', tag: 'TICK_REPORT');
    // _timer.cancel();
    showToast(msg: 'report');
    var reportTime = await AnalysisDao.reportTime(logId: logId);
    if (reportTime.result &&
        reportTime.model != null &&
        reportTime.model.code == 1 &&
        reportTime.model.data != null) {
      logId = reportTime.model.data.logId;
    }
  }

  static stopTimer() {
    logId = 0;
    bool isOpen = SharedPrefsUtils.get<bool>('report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    showToast(msg: '停止报告');
    _timer?.cancel();
    _stopwatch?.stop();
    _stopwatch?.reset();
  }

  static pauseTimer() {
    bool isOpen = SharedPrefsUtils.get<bool>('report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    showToast(msg: '暂停报告');
    if (_timer?.isActive ?? false) {
      // 暂停计时，但不清零
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  static showToast({String msg}) {
    if (Config.DEBUG) {
      Fluttertoast.showToast(msg: msg);
    }
  }
}
