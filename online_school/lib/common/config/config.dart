class Config {
  static const PAGE_SIZE = 20;
  /// 生产和测试环境切换 static const DEBUG = bool.fromEnvironment("dart.vm.product"); //生产环境
  ///static const DEBUG = !bool.fromEnvironment("dart.vm.product"); ///上线时候状态
  static const DEBUG = !bool.fromEnvironment("dart.vm.product");
  static const USE_NATIVE_WEBVIEW = true;

  /// //////////////////////////////////////常量////////////////////////////////////// ///
  static const TOKEN_KEY = "access_token";
  static const USER_NAME_KEY = "user-name";
  static const PW_KEY = "user-pw";
  static const USER_BASIC_CODE = "user-basic-code";
  static const USER_INFO = "user-info";
  static const LANGUAGE_SELECT = "language-select";
  static const LANGUAGE_SELECT_NAME = "language-select-name";
  static const REFRESH_LANGUAGE = "refreshLanguageApp";
  static const THEME_COLOR = "theme-color";
  static const LOCALE = "locale";
  static const LOGIN_JSON = "login_json";
  static const USER_INFO_JSON = "user_info_json";
}
