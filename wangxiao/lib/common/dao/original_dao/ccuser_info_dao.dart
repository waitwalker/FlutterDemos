import 'dart:async';
import 'dart:convert';

import 'package:online_school/common/config/config.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/model/user_info_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:dio/dio.dart';

class CCUserInfoDao {
  /// 获取用户信息
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-11-V1.0
  static getUserInfo({String token}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-cloudaccount-service/api/user/info';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var userInfo = UserInfoModel.fromJson(response.data);

      saveCCUserInfo(jsonEncode(response.data));
      response.model = userInfo;
    }
    return response;
  }

  static setUserInfo(String userId,
      {realName, sex, birthday, address, email}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-cloudaccount-service/api/user/info';

    var param = {
      'userId': userId,
    };
    param['realName'] = realName;
    param['sex'] = sex.toString();
    param['birthday'] = birthday;
    param['address'] = address;
    param['email'] = email;
    var body = jsonEncode(param);

    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'PUT'));
    if (response.result) {
      var userInfo = BaseModel.fromJson(response.data);

      response.model = userInfo;
    }

    return response;
  }

  static Future saveCCUserInfo(var json) async {
    SharedPrefsUtils.putString(Config.USER_INFO_JSON, json);
  }

  static UserInfoModel loadUserInfo() {
    var json = SharedPrefsUtils.getString(Config.USER_INFO_JSON, '{}');
    var info = UserInfoModel.fromJson(jsonDecode(json));
    return info;
  }

  /// 激活卡之前，完善个人信息
  static completeUserInfo(
      {schoolId,
      realName,
      address,
      gradeId,
      schoolName,
      cardId,
      onlineCourseId}) async {
    var url = APIConst.CC_BASE_URL +
        'api-cloudaccount-service/api/user/authentication';

    var param = {
      'schoolId': schoolId,
      'realName': realName,
      'address': address,
      'gradeId': gradeId,
      'schoolName': schoolName,
      'cardId': cardId,
      'onlineCourseId': onlineCourseId
    };
    var body = jsonEncode(param);

    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var userInfo = BaseModel.fromJson(response.data);

      response.model = userInfo;
    }

    return response;
  }
}
