/// @fileName singleton_manager.dart
/// @description 单例类 提供一些全局变量&方法访问
/// @date 2022/3/23 10:39 上午
/// @author LiuChuanan
class SingletonManager {
  ///游戏前后台管理 true 前台  false 后台
  late bool unityAtFront = false;

  late String tag = "home";

  /// 是否登录成功
  late bool isLogin = false;


  /// 是否应该检查通知权限
  late bool shouldCheck = true;

  ///是否检查过崩溃 app 声明周期内执行一次就可以
  bool checkCrash = false;

  /// methodName resetDefaultValue
  /// description 恢复一些默认值
  /// date 2022/9/2 09:33
  /// author LiuChuanan
  void resetDefaultValue() {
    SingletonManager.sharedInstance.isLogin = false;
    SingletonManager.sharedInstance.shouldCheck = false;
  }

  SingletonManager._privateConstructor();

  static final SingletonManager _instance =
  SingletonManager._privateConstructor();

  static SingletonManager get sharedInstance => _instance;
}
