import 'package:shared_preferences/shared_preferences.dart';

//Singleton
class SharedPrefsUtils {
  static final SharedPrefsUtils _sharePref = new SharedPrefsUtils._internal();
  static SharedPreferences _sharedPrefence;

  factory SharedPrefsUtils() {
    return _sharePref;
  }

  SharedPrefsUtils._internal();

  static Future<SharedPreferences> init() async {
    if (_sharedPrefence == null) {
      _sharedPrefence = await SharedPreferences.getInstance();
    }
    return _sharedPrefence;
  }

  static String getString(String key, [String defalutValue]) {
    init();
    String value = _sharedPrefence.get(key);
    return (value == null) ? defalutValue : value;
  }

  static putString(String key, String value) {
    init();
    _sharedPrefence.setString(key, value);
  }

  static T get<T>(String key, T defalutValue) {
    init();
    T value = _sharedPrefence.get(key);
    return (value == null) ? defalutValue : value;
  }

  static put<T>(String key, T value) {
    init();
    switch (value.runtimeType) {
      case String:
        {
          _sharedPrefence.setString(key, value as String);
          break;
        }
      case int:
        {
          _sharedPrefence.setInt(key, value as int);
          break;
        }
      case bool:
        {
          _sharedPrefence.setBool(key, value as bool);
          break;
        }
      case double:
        {
          _sharedPrefence.setDouble(key, value as double);
          break;
        }
      case List:
        {
          _sharedPrefence.setStringList(key, value as List<String>);
          break;
        }
    }
  }

  static remove(String key) {
    init();
    _sharedPrefence.remove(key);
  }
}
