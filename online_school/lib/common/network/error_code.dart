import 'package:online_school/event/HttpErrorEvent.dart';
import 'package:event_bus/event_bus.dart';

///错误编码
class ErrorCode {
  ///网络错误
  static const NETWORK_ERROR = -1;

  ///网络超时
  static const NETWORK_TIMEOUT = -2;

  ///网络返回数据格式化异常
  static const NETWORK_JSON_EXCEPTION = -3;

  static const EXPIRED = -4;

  static const SUCCESS = 200;

  static final EventBus eventBus = EventBus();

  /// event 发出事件通知
  static errorHandleFunction(code, message, noTip) {
    if (noTip) {
      return message;
    }
    eventBus.fire(HttpErrorEvent(code, message));
    return message;
  }
}
