
class EnvironmentConfig {
  /// app 运行环境 默认Release
  /// 其他的情况 还有 Debug
  static const app_environment = String.fromEnvironment("APP_ENVIRONMENT", defaultValue: "Release");

  /// 其他调试变量
  static const other = String.fromEnvironment("OTHER", defaultValue: "Test");
}