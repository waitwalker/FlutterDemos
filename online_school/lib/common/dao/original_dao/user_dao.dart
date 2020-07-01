import 'package:online_school/common/dao/original_dao/dao_result.dart';
import 'package:online_school/model/basic/login_model.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:online_school/common/tools/sign.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDao {
  static Future<DataResult> initUserData() async {
    String result = SharedPrefsUtils.getString('userinfo');
    if (result != null) {
      return new DataResult(result, true);
    }

    return new DataResult(null, false);
  }

  static login(String _userName, String _passwordValue) async {
    var url =
        'http://i2.m.etiantian.com:48081/study-im-service-2.0/user/login.do';
    var form = {
      "uName": _userName,
      "pwd": SignUtil.desEncrypt(_passwordValue),
      "time": DateTime.now().millisecondsSinceEpoch.toString(),
    };
    url += '?${mapToQuery(form)}';
    var headers = {
      'user-agent': 'dio',
      'client': 'android',
      'Content-Type': 'application/x-www-form-urlencoded'
    };
    var response =
        await NetworkManager.netFetch(url, null, headers, Options(method: 'POST'));
    if (response.result) {
      var loginModel = LoginModel.fromJson(response.data);

      if (loginModel.result == 1) {
        saveLogin(loginModel.data).then((v) {
          getConfig();
          getProtocol();
        }, onError: (err) {
          // onLoginError(err);
        });
      }
    }
  }

  static Future getConfig() async {
    var url = 'http://school.etiantian.com/aixue30t/im2.2?m=getConfig.do';
    //'&appId=1&deviceCode=abcdefg&time=1540890042603&sign=NzIxYjJjNmM0Mzc5YzRkZWEzMjIzODc3MzQyMmM1ZmU';
    var form = {
      'appId': 1.toString(),
      'deviceCode': 'abcdefg',
      'time': DateTime.now().millisecondsSinceEpoch.toString()
    };

    form['sign'] = SignUtil.makeSign('getConfig.do', form);

    var fullUrl = url + '&' + SignUtil.joinParam(form);

    ResponseData res =
        await NetworkManager.netFetch(fullUrl, null, null, Options(method: 'POST'));

    if (res.result) {
      var body = res.data;
    }
  }

  static Future getProtocol() async {
    var url =
        'http://school.etiantian.com/aixue30t/im2.2?m=getProtocolConfig.do';
    //'&jid=8521356&time=1540891664460&sign=YzA1OTNlMWU3NDE3ZTkyY2Y1ZWZjMWNiOTlmNmY5Mzc';
    var form = {
      'jid': 8521356,
      'time': DateTime.now().millisecondsSinceEpoch.toString()
    };

    form['sign'] = SignUtil.makeSign('getProtocolConfig.do', form);
    var fullUrl = url + '&' + SignUtil.joinParam(form);

    ResponseData res =
        await NetworkManager.netFetch(fullUrl, null, null, Options(method: 'POST'));

    if (res.result) {
      var body = res.data;

      toHome();
    }
  }

  static void toHome() {}

  static Future saveLogin(LoginData loginData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLogin', true);
    prefs.setInt('jid', loginData.jid);
    prefs.setInt('schoolId', loginData.schoolId);
    prefs.setInt('grade', loginData.gradeId);
    prefs.setInt('sex', loginData.sex);
    prefs.setInt('squareFlag', loginData.squareFlag);
    prefs.setInt('classCircleFlag', loginData.classCircleFlag);
    prefs.setInt('hbhxFlag', loginData.hbhxFlag);
    prefs.setInt('uType', loginData.uType);
    prefs.setInt('isHorizontal', loginData.isHorizontal);
    prefs.setInt('shouldComplete', loginData.shouldComplete);
    prefs.setString('schoolName', loginData.schoolName);
    prefs.setString('accessToken', loginData.accessToken);
    prefs.setString('photo', loginData.photo);
    prefs.setString('childCode', loginData.childCode);
    prefs.setString('city', loginData.city);
    prefs.setString('expires', loginData.expires);
    prefs.setString('liveLessonUrl', loginData.liveLessonUrl);
    prefs.setString('onlineTestUrl', loginData.onlineTestUrl);
    prefs.setString('vodLessonUrl', loginData.vodLessonUrl);
    prefs.setString('userName', loginData.userName);
    prefs.setString('realName', loginData.realName);
  }
}
