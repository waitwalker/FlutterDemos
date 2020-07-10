import 'dart:convert';
import 'dart:io';

import 'package:online_school/model/upload_avatar_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/tools/sign.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class AvatarUploadDao {
  static upload(String jid, String userType, File photo) async {
    var url = '${APIConst.commonHost}/uploadUserPhoto.do';
    var param = {
      'jid': jid,
      'userType': userType,
      'time': DateTime.now().millisecondsSinceEpoch.toString()
    };

    param['sign'] = SignUtil.makeSign('uploadUserPhoto.do', param);

    var fullUrl = url + '?' + SignUtil.joinParam(param);

    FormData formData = new FormData.fromMap({
      "photo": await MultipartFile.fromFile(photo.path,
          filename: path.basename(photo.path)),
    });

    ResponseData response =
        await NetworkManager.netFetch(fullUrl, formData, null, Options(method: 'POST'));

    if (response.result) {
      var model = UploadAvatarModel.fromJson(jsonDecode(response.data));

      response.model = model;
    }
    return response;
  }
}
