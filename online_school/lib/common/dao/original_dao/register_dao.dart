import 'dart:convert';

import 'package:online_school/model/base_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:dio/dio.dart';

class RegisterDao {
  static register(String mobile, String code, String pwd) async {
    var url =
        APIConst.CC_BASE_URL + 'api-cloudaccount-service/api/user/register';
    var body =
        jsonEncode({"mobile": mobile, "phoneCode": code, "password": pwd});
    var headers = {'content-type': 'application/json'};
    var response = await NetworkManager.netFetch(
        url, body, headers, Options(method: 'POST'),
        forceBasicToken: true);

    if (response.result) {
      var model = BaseModel.fromJson(response.data);

      if (model.code != 1) {
        response.result = false;
      }
      response.model = model;
    }

    return response;
  }

  static bindPhone(String mobile, String code) async {
    var url =
        APIConst.CC_BASE_URL + 'api-cloudaccount-service/api/user/bind';
    var body = jsonEncode({"mobile": mobile, "phoneCode": code});
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));

    if (response.result) {
      var model = BaseModel.fromJson(response.data);

      if (model.code != 1) {
        response.result = false;
      }
      response.model = model;
    }

    return response;
  }
}
