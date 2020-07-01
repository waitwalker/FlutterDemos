import 'dart:async';

import 'package:online_school/common/config/config.dart';
import 'package:online_school/common/dao/original_dao/analysis.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'share_preference.dart';

class DocTimer {
  static final int report_seconds = 5 * 1;
  static Timer _timer;
  static Stopwatch _stopwatch;

  static var logId = 0;

  static Future startReportTimer(
    BuildContext context, {
    String resId,
  }) async {
    if (_timer?.isActive ?? false) {
      return;
    }
    bool isOpen = SharedPrefsUtils.get<bool>('doc_report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    int timeElapsed = 0;
    if (_stopwatch == null) {
      _stopwatch = Stopwatch()..start();
      // showToast(msg: '开始计时');
    } else {
      // 读取计时器的已消耗时间，如果有，在timer里减去
      timeElapsed = _stopwatch.elapsed.inSeconds;
      _stopwatch = _stopwatch..start();
      // showToast(msg: '恢复计时');
    }

    int timeRemain = report_seconds - timeElapsed;
    _timer = Timer.periodic(Duration(seconds: timeRemain), (_) async {
      debugLog('${_timer.tick}', tag: 'TICK_');
      // _timer.cancel();
      // showToast(msg: 'report');
      var reportVideo = await AnalysisDao.reportVideo(
        resId: resId,
        videoDuration: 5,
        isViewEnd: 0,
        refId: 0,
        resType: 4,
        logId: logId,
      );
      if (logId == 0 &&
          reportVideo.result &&
          reportVideo.model != null &&
          reportVideo.model.code == 1 &&
          reportVideo.model.data != null) {
        logId = reportVideo.model.data.logId;
      }
    });
    debugLog('${_timer.tick}', tag: 'TICK_');
  }

  static stopTimer() {
    bool isOpen = SharedPrefsUtils.get<bool>('doc_report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    // showToast(msg: '停止报告');
    _timer?.cancel();
    _stopwatch?.stop();
    _stopwatch?.reset();
  }

  static pauseTimer() {
    bool isOpen = SharedPrefsUtils.get<bool>('doc_report_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    // showToast(msg: '暂停报告');
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
