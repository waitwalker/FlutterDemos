import 'package:logger/logger.dart';

///
/// @name LoggerManager
/// @description 日志基于level 输出
/// @author liuca
/// @date 2020-02-14
///
class LoggerManager {

  ///
  /// @name debug
  /// @description debug level 日志输出
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-02-24
  ///
  static debug(String message) {
    var logger = Logger();
    logger.d("Debug Level 日志输出:$message\n\n");
  }

  ///
  /// @name error
  /// @description error level 日志输出
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-02-24
  ///
  static error(String message) {
    var logger = Logger();
    logger.e("Error Level 日志输出:$message\n\n");
  }

  ///
  /// @name info
  /// @description info level 日志输出
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-02-24
  ///
  static info(String message) {
    var logger = Logger();
    logger.i("Info Level 日志输出:$message\n\n");
  }

  static full(String message) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(message).forEach((match) => print(match.group(0)));
  }
}