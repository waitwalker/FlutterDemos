import 'dart:convert';

import 'package:online_school/model/document_model.dart';
import 'package:online_school/model/live_courseware_model.dart';
import 'package:online_school/model/material_list_model.dart';
import 'package:online_school/model/material_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:dio/dio.dart';

class MaterialDao {
  /// listType：AI 1，智慧学习 2
  static Future<ResponseData> getMaterials(subjectId, gradeId, listType) async {
    var url = APIConst.CC_BASE_URL +
        'api-service-general-wx/materials/version/material';
    var query = mapToQuery({
      'subjectId': subjectId.toString(),
      'gradeId': gradeId.toString(),
      'listType': listType.toString()
    });
    url = '$url?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = MaterialListModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// 获取已选教材
  /// type：
  /// 1，AI测试（AI）
  /// 2，智慧学习
  static Future<ResponseData> material(subjectId, gradeId, type) async {
    var url = APIConst.CC_BASE_URL +
        'api-service-general-wx/materials/grade/subject';
    var query = mapToQuery({
      'subjectId': subjectId.toString(),
      'gradeId': gradeId.toString(),
      'type': type.toString()
    });
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = MaterialModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  /// 获取已选教材下的所有课程文档
  /// 传参说明：(gradeId, subjectId) 和 (materialId) 等价，二选一
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-29-V2.0
  static Future<ResponseData> getMaterialDocuments(
      {String gradeId, String subjectId, String materialId}) async {
    // assert((gradeId != null && subjectId != null && materialId == null) ||
    //     (gradeId == null && subjectId == null && materialId != null));

    var url =
        APIConst.CC_BASE_URL + 'api-service-course-wx/wx-chapter/resource';
    var query;
    if (materialId != null) {
      query = mapToQuery({'materialId': materialId});
    } else {
      query = mapToQuery({
        'subjectId': subjectId,
        'gradeId': gradeId,
      });
    }
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var docs = DocumentModel.fromJson(response.data);
      response.model = docs;
    }
    return response;
  }

  /// 获取直播课的课件
  static Future<ResponseData> getLiveCourseware({String courseId}) async {
    // assert((gradeId != null && subjectId != null && materialId == null) ||
    //     (gradeId == null && subjectId == null && materialId != null));

    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/course/{courseId}/coursewares/list';
    url = url.replaceFirst('{courseId}', courseId);
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var docs = LiveCoursewareModel.fromJson(response.data);
      response.model = docs;
    }
    return response;
  }

  /// 保存教材
  /// type：1 AI， 2 自学
  static Future<ResponseData> saveMaterial(
      versionId, materialId, subjectId, gradeId, type) async {
    var url = APIConst.CC_BASE_URL + 'api-service-general-wx/materials';
    var body = jsonEncode({
      'versionId': versionId.toString(),
      'materialId': materialId.toString(),
      'subjectId': subjectId.toString(),
      'gradeId': gradeId.toString(),
      'type': type.toString()
    });
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = MaterialListModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }
}
