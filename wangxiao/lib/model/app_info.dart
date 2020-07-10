import 'video_source_model.dart';

class AppInfo {
  bool isLogin;

  bool backgroundPlay;
  VideoSource line;

  AppInfo({this.isLogin, this.backgroundPlay, this.line});

  AppInfo only({isLogin, backgroundPlay = false, line}) {
    return AppInfo(
        isLogin: isLogin ?? this.isLogin,
        backgroundPlay: backgroundPlay ?? this.backgroundPlay,
        line: line ?? this.line);
  }

  AppInfo merge(AppInfo delta) {
    return AppInfo(
        isLogin: delta.isLogin ?? this.isLogin,
        backgroundPlay: delta.backgroundPlay ?? this.backgroundPlay,
        line: delta.line ?? this.line);
  }
}
