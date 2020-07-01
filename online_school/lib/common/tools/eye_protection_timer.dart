import 'dart:async';

import 'package:online_school/common/config/config.dart';
import 'package:online_school/modules/widgets/eye_protect_dialog_widget.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:flutter/material.dart';
import 'share_preference.dart';


///
/// @name EyeProtectionTimer
/// @description 护眼提醒定时器
/// @author liuca
/// @date 2020-01-11
///
class EyeProtectionTimer {
  static final int eye_protection_seconds = 20 * 60;
  static Timer _timer;
  static Stopwatch _stopwatch;

  static Future startEyeProtectionTimer(BuildContext context,
      {Duration startAt}) async {
    if (_timer?.isActive ?? false) {
      return;
    }
    bool isOpen = SharedPrefsUtils.get<bool>('eye_protect_on', true);
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

    int timeRemain = eye_protection_seconds - timeElapsed;
    _timer = Timer.periodic(Duration(seconds: timeRemain), (_) async {
      debugLog('${_timer.tick}', tag: 'TICK_');
      _timer.cancel();
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return EyeProtectDialogWidget(
              tapCallBack: () {
                print("点击");
                Navigator.of(context).pop();
                debugLog('${_stopwatch.elapsed.inSeconds}');
                _stopwatch
                  ..stop()
                  ..reset();
                startEyeProtectionTimer(context);
              },
            );
          });
    });
    debugLog('${_timer.tick}', tag: 'TICK_');
  }

  static stopTimer() {
    bool isOpen = SharedPrefsUtils.get<bool>('eye_protect_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    showToast(msg: '停止计时');
    _timer?.cancel();
    _stopwatch?.stop();
    _stopwatch?.reset();
  }

  static pauseTimer() {
    bool isOpen = SharedPrefsUtils.get<bool>('eye_protect_on', true);
    // 护眼模式关闭
    if (!isOpen) {
      return;
    }
    showToast(msg: '暂停计时');
    if (_timer?.isActive ?? false) {
      // 暂停计时，但不清零
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  static showToast({String msg}) {
    if (Config.DEBUG) {
      // Fluttertoast.showToast(msg: msg);
    }
  }
}
