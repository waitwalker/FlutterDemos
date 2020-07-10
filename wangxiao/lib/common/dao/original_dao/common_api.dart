import 'dart:convert';
import 'dart:io';

import 'package:online_school/model/check_update_model.dart';
import 'package:online_school/model/config_model.dart';
import 'package:online_school/model/upload_file_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/tools/sign.dart';
import 'package:dio/dio.dart';

class CommonServiceDao {

  ///
  /// @MethodName checkUpdate
  /// @Parameter
  /// @ReturnType
  /// @Description 检查更新
  /// @Author waitwalker
  /// @Date 2020-03-13
  ///
  /// http://int.etiantian.com:39804/pages/viewpage.action?pageId=5374559
  static checkUpdate({
    String version,
    int jid = 0,
    int appId = 703,
    int identifyId = 0,
    int schoolId = 0,
  }) async {
    var url = '${APIConst.commonHost}/checkAppVersion.do';
    int deviceType = Platform.isIOS ? 1 : Platform.isAndroid ? 2 : 3;
    var param = {
      'jid': jid,
      'version': version,
      'appId': appId,
      'identifyId': identifyId,
      'schoolId': schoolId,
      'deviceType': deviceType,
      'time': DateTime.now().millisecondsSinceEpoch.toString()
    };

    param['sign'] = SignUtil.makeSign('checkAppVersion.do', param);

    url = url + '?' + SignUtil.joinParam(param);

    ResponseData response = await NetworkManager.netFetch(url, null, null, null);

    if (response.result) {
      var model = CheckUpdateModel.fromJson(jsonDecode(response.data));

      response.model = model;
    }
    return response;
  }

  static configs({
    String ver,
  }) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/configs';
    int devType = Platform.isIOS ? 2 : Platform.isAndroid ? 1 : -1;
    var param = {
      'ver': ver,
      'devType': devType,
    };

    url = url + '?' + SignUtil.joinParam(param);
    ResponseData response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = ConfigModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  static uploadImage({
    String image,
  }) async {
    var url = APIConst.uploadImage;

    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(image),
    });

    ResponseData response = await NetworkManager.netFetch(url, formData, null, Options(method: 'POST'));
    if (response.result) {
      var model = UploadFileModel.fromJson(jsonDecode(response.data));
      response.model = model;
    }
    return response;
  }
}
