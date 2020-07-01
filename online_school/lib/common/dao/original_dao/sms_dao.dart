import 'dart:convert';

import 'package:online_school/model/base_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:dio/dio.dart';

class SmsDao {
  static getSms(String mobile,
      {smsType = SmsType.bind, bool forBasicToken = true}) async {
    int value = getSmsTypeValue(smsType);
    return await _getSmsByType(mobile, value, forBasicToken: forBasicToken);
  }

  static _getSmsByType(String mobile, int type,
      {bool forBasicToken = true}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-cloudaccount-service/api/user/sms';
    var body = jsonEncode({"mobile": mobile, "smsType": type.toString()});
    var headers = {'content-type': 'application/json'};
    var response = await NetworkManager.netFetch(
        url, body, headers, Options(method: 'POST'),
        forceBasicToken: forBasicToken);
    if (response.result) {
      var model = BaseModel.fromJson(response.data);

      if (model.code != 1) {
        response.result = false;
      }
      response.model = model;
    }

    return response;
  }

  static int getSmsTypeValue(SmsType type) {
    var ret = type == SmsType.login
        ? 101
        : type == SmsType.register
            ? 102
            : type == SmsType.modify
                ? 103
                : type == SmsType.forget
                    ? 104
                    : type == SmsType.bind ? 106 : -1;
    return ret;
  }

  static int getSmsType(int code) {
    var ret;
    switch (code) {
      case 101:
        ret = SmsType.login;
        break;
      case 102:
        ret = SmsType.register;
        break;
      case 103:
        ret = SmsType.modify;
        break;
      case 104:
        ret = SmsType.forget;
        break;
      case 106:
        ret = SmsType.bind;
        break;
      default:
        throw FormatException('SmsType by $code not exist');
    }
    return ret;
  }
}

enum SmsType { bind, login, register, forget, modify }
