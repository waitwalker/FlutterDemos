import 'dart:convert';
import 'dart:io';

import 'package:online_school/model/base_model.dart';
import 'package:online_school/model/video_record.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:udid/udid.dart';

class AnalysisDao {
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-35-V2.0
  static Future<ResponseData> log(materialId, nodeId, resType, resId) async {
    var url = APIConst.CC_BASE_URL +
        'api-service-general-wx/materials/material/resource/log';

    var body = jsonEncode({
      "materialId": materialId,
      "nodeId": nodeId,
      "resType": resType,
      "resId": resId
    });
    var headers = <String, String>{'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-48-V2.0
  static Future<ResponseData> records() async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/students/login/records/v2';
    var udid = await Udid.udid;
    var packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    printAndroidDeviceInfo(AndroidDeviceInfo info) {
      var sb = StringBuffer();
      sb.writeln('品牌: ${info.brand}');
      sb.writeln('CPU: ${info.hardware}');
      sb.writeln('制造商: ${info.manufacturer}');
      sb.writeln('型号: ${info.display}');
      sb.writeln('Android ${info.version.release}');
      sb.writeln('SDK Level: ${info.version.sdkInt}');
      sb.writeln(info.supportedAbis);
      return sb.toString();
    }

    printIosDeviceInfo(IosDeviceInfo info) {
      var sb = StringBuffer();
      sb.writeln('型号: ${info.name}');
      sb.writeln('系统: ${info.systemName} ${info.systemVersion}');
      return sb.toString();
    }

    Future<String> deviceDesc() async {
      return Platform.isAndroid
          ? printAndroidDeviceInfo(await deviceInfo.androidInfo)
          : printIosDeviceInfo(await deviceInfo.iosInfo);
    }

    var body = jsonEncode({
      "uniqueId": udid,
      "deviceDesc": await deviceDesc(),
      "systemDesc": Platform.operatingSystem,
      "systemVersion": Platform.operatingSystemVersion,
      "appVersion": packageInfo.version,
    });
    var response =
        await NetworkManager.netFetch(url, body, null, Options(method: 'POST'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  static Future<ResponseData> report(
      appVer, devType, osVer, devModel, netType, netStatus) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/problem/records';

    var body = jsonEncode({
      "appVer": appVer,
      "devType": devType,
      "osVer": osVer,
      "devModel": devModel,
      "netType": netType,
      "netStatus": netStatus
    });
    var response =
        await NetworkManager.netFetch(url, body, null, Options(method: 'POST'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-59-V2.0
  static Future<ResponseData> reportVideo(
      {resId,
      resType = 1,
      source = 1,
      refId,
      logId = 0,
      viewDuration = 5,
      isViewEnd,
      videoDuration}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/resviewlogs';

    var body = jsonEncode({
      "resId": resId,
      "resType": resType,
      "source": source,
      "refId": refId ?? 0,
      "logId": logId,
      "viewDuration": viewDuration,
      "isViewEnd": isViewEnd,
      "videoDuration": videoDuration
    });
    var response =
        await NetworkManager.netFetch(url, body, null, Options(method: 'POST'));
    if (response.result) {
      var model = VideoRecord.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-71-V1.2.3
  static Future<ResponseData> reportTime({int source = 2, int logId = 0}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/resviewlogs/use/log';

    var body = jsonEncode({
      'source': source,
      'logId': logId,
    });

    var response =
        await NetworkManager.netFetch(url, body, null, Options(method: 'POST'));
    if (response.result) {
      var model = VideoRecord.fromJson(response.data);
      response.model = model;
    }
    return response;
  }
}
