
///
/// @Class: 单例管理类
/// @Description: 
/// @author: lca
/// @Date: 2019-08-30
///
class SingletonManager {

  /// 是否已经登录过
  /// 1.登录过,也就是现在已经进入主页, 主页处理跳转
  /// 2.没有登录过,登录页处理跳转
  /// 要判断是冷启动 热启动
  bool isHaveLogined = false;

  /// 是否从爱学跳转过来
  bool isJumpFromAixue = false;

  /// 是否显示活动课
  /// 如果跳转过来正好处于加载活动课的过程 则不显示
  bool shouldShowActivityCourse = true;

  /// 是否跳转过来触发的冷启动
  bool isJumpColdStart = false;

  /// 爱学传过来的参数
  String aixueAccount;
  String aixuePassword;
  String isVip = "";
  String gradeId = "";

  /// 错题本是否需要刷新 & 弹出相机
  /// 0 不刷新 不处理
  /// 1 只刷新
  /// 2 刷新 & 弹出相机
  int errorBookCameraState = 0;

  /// 是否是新用户
  bool isNewUser = true;

  /// 是否加载过弹框 默认没有加载过
  bool isHaveLoadedAlert = false;

  /// 是否pad的设备
  bool isPadDevice = false;

  /// 屏幕宽高
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  /// 是否有大师直播权限
  bool isHaveLiveAuthority = false;

  // 当前语言索引
  int currentLocaleIndex = 0;

  // 手机名称
  String mobileName = "";

  /// 类调用实例
  static SingletonManager get sharedInstance => _getInstance();

  /// 构造方法
  factory SingletonManager() => _getInstance();
  static SingletonManager _sharedInstance;

  SingletonManager._internal() {
    print("初始化相关");
  }
  static SingletonManager _getInstance() {
    if (_sharedInstance == null) {
      _sharedInstance = SingletonManager._internal();
    }
    return _sharedInstance;
  }
}
