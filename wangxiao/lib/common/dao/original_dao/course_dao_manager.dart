import 'dart:convert';
import 'package:online_school/model/ab_test_model.dart';
import 'package:online_school/model/activity_dialog_model.dart';
import 'package:online_school/model/ai_model.dart';
import 'package:online_school/model/ai_score_model.dart';
import 'package:online_school/model/base_model.dart';
import 'package:online_school/model/course_model.dart';
import 'package:online_school/model/error_book_model.dart';
import 'package:online_school/model/errorbook_detail_model.dart';
import 'package:online_school/model/errorbook_list_model.dart';
import 'package:online_school/model/live_detail_model.dart';
import 'package:online_school/model/live_schedule_model.dart';
import 'package:online_school/model/message_detail_model.dart';
import 'package:online_school/model/message_list_model.dart';
import 'package:online_school/model/micro_course_resource_model.dart';
import 'package:online_school/model/new/activity_entrance_model.dart';
import 'package:online_school/model/new_home_course_model.dart';
import 'package:online_school/model/order_list_model.dart';
import 'package:online_school/model/recommend_model.dart';
import 'package:online_school/model/resource_info_model.dart';
import 'package:online_school/model/self_model.dart';
import 'package:online_school/model/self_study_model.dart';
import 'package:online_school/model/subject_detail_model.dart';
import 'package:online_school/model/unread_count_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/tools/logger.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class CourseDaoManager {
  static liveList() async {
    debugLog('@@@@@@@@@liveList');
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/course/v2/courses';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = CourseModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  static liveDetail(String courseId) async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/course/online/info?onlineCourseId=$courseId';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = LiveDetailModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 课程表
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-09-V1.0
  static Future<ResponseData> liveSchedule(var startTime, var endTime) async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/course/online/info?startTime=$startTime&endTime=$endTime';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = LiveDetailModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 智慧学习 章 节 知识点 资源。
  /// 4级列表分层请求
  /// type=1，章节，附带资源
  /// type=2，节，附带资源
  /// type=3，知识点，附带资源
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-20-V2.0
  static Future<ResponseData> selfStudyList(versionId, materialId, type,
      [nodeId]) async {
    var url =
        APIConst.CC_BASE_URL + 'api-service-course-wx/wx-chapter/tree';
    var map = {
      'versionId': versionId.toString(),
      'materialId': materialId.toString(),
      'type': type.toString()
    };
    if (nodeId != null) {
      map['nodeId'] = nodeId?.toString();
    }
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = SelfStudyModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-33-V2.0
  /// 自学列表
  static Future<ResponseData> selfStudyListV2(materialId) async {
    var url = APIConst.CC_BASE_URL +
        'api-service-course-wx/wx-chapter/node/points';
    var map = {'materialId': materialId.toString()};
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = SelfModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/shuzixiaoyuan/JIAOXUE-SERVICE-API-253
  static Future<ResponseData> aiStudyList(materialId) async {
    var url = APIConst.CC_BASE_URL +
        'api-service-general-wx/student-class/chapters';
    var map = {'materialId': materialId.toString()};
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = AiModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  static Future<ResponseData> getResourseInfo(resourceId, {int lineId}) async {
    var url = APIConst.CC_BASE_URL + 'api-resource-service/api/resources/';
    url = '$url$resourceId';
    if (lineId != null) {
      url += '?lineId=$lineId';
    }
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = ResourceInfoModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  static Future<ResponseData> getMicroCourseResourseInfo(resourceId) async {
    var url =
        APIConst.CC_BASE_URL + 'api-resource-service/api/resources/wk/';
    url = '$url$resourceId';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = MicroCourseResourceModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  static Future<ResponseData> getExerciseHistory(resourceId,
      {bool fromMicroCourse = true}) async {
    var url;
    var map = <String, String>{};
    if (fromMicroCourse) {
      url = APIConst.CC_BASE_URL + 'api-study-service/api/papers/list';
      map['resourceId'] = resourceId.toString();
    } else {
      // ab测试
      url = APIConst.CC_BASE_URL + 'api-study-service/api/ab-papers/list';
      map['srcAbPaperId'] = resourceId.toString();
    }
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = AbTestModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  static Future<ResponseData> getOrderList() async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/card/user/course/card';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = OrderListModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  static Future<ResponseData> feedback(
      {@required String courseId,
      String courseType = '3',
      @required String content,
      String contact,
      String deviceType,
      String systemVersion,
      String appVersion}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/feedbacks';
    var body = jsonEncode({
      "courseId": courseId,
      "courseType": courseType,
      "content": content,
      "contact": contact,
      "deviceType": deviceType,
      "systemVersion": systemVersion,
      "appVersion": appVersion
    });
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// 打分，评分，rating
  /// courseType: 不传，默认反馈的是课程卡下的课程，类型为3
  /// typeId: 1 评价课程 2 评价老师
  static Future<ResponseData> rating(
      {@required String courseId,
      String courseType = '3',
      String typeId = '1',
      @required String score}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/evaluates';
    var body = jsonEncode({
      "courseId": courseId,
      "courseType": courseType,
      "typeId": typeId,
      "score": score
    });
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// 新版首页学科列表
  /// See http://int.etiantian.com:39804/display/zz/NEW-ETT-API-64-V1.1
  static Future<ResponseData> newCourses() async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/course/v2.2/courses';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = NewHomeCourseModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-65-V2.1
  /// cardType: 1: 普通卡，和courseId配合使用
  /// cardType: 2: 智领卡，和gradeId，subjectId配合使用
  /// cardType: 3: 智学卡，和gradeId，subjectId配合使用
  static subjectDetail({int gradeId, int subjectId, num courseId, int cardType = 2}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/course/v2.1/courses/grade/subject';
    var map;
    if (courseId == null) {
      map = {
        'gradeId': gradeId.toString(),
        'subjectId': subjectId.toString(),
        'cardType': cardType.toString(),
      };
    } else {
      map = {'cardType': cardType.toString(), 'courseId': courseId.toString()};
    }
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = SubjectDetailModel.fromJson(response.data);
      response.model = courseList;
    }
    return response;
  }

  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-66-V2.1
  /// 大师直播列表
  /// [typeId] 0=当前 1=预告 2=回放
  static Future<ResponseData> liveScheduleNew(
      {@required int gradeId, @required int subjectId, int typeId}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/lives/plans';
    var body = jsonEncode(
        {"gradeId": gradeId, "subjectId": subjectId, "typeId": typeId});
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = LiveScheduleModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-68-V2.1
  static Future<ResponseData> activityInfo() async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/activity/prompt';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = ActivityEntranceModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-67-V2.1
  static Future<ResponseData> recommend() async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/course/home/recommend';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = RecommendModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  static Future<ResponseData> aiScore(
      {@required String currentDirId,
      @required String subjectId,
      @required String versionId,
      int classId = -1,
      int taskId = -1}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-service-honeycomb/intelligentsia/v2';
    var body = jsonEncode({
      "currentDirId": currentDirId,
      "subjectId": subjectId,
      "versionId": versionId,
      "classId": classId,
      "taskId": taskId,
    });
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = AiScoreModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// 保存错题本
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-80-V1.2.4
  static Future<ResponseData> saveErrorBook({
    @required int gradeId,
    @required int subjectId,
    @required String wrongReason,
    @required String photoUrl,
  }) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/wrong-notebook/photo';
    var body = jsonEncode({
      "gradeId": gradeId,
      "subjectId": subjectId,
      "wrongReason": wrongReason,
      "photoUrl": photoUrl,
    });
    var headers = {'content-type': 'application/json'};
    var response =
        await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.result) {
      var model = AiScoreModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-76-V1.2.4
  static messageList({int pageSize, int currentPage}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/message/user';
    var map = {
      'pageSize': pageSize.toString(),
      'currentPage': currentPage.toString(),
    };
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = MessageListModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-78-V1.2.4
  static setMessageStatus({int msgId, int status}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/message/user/lable';
    var map = {
      'msgId': msgId.toString(),
      'lableStatus': status.toString(),
    };
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, Options(method: 'PUT'));
    if (response.result) {
      var model = BaseModel.fromJson(response.data);

      response.model = model;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-81-V1.2.4
  /// 错题本列表
  static errorbookList(
      {int pageSize, int currentPage, int gradeId, int subjectId}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/wrong-notebook/photo';
    var map = {
      'pageSize': pageSize.toString(),
      'currentPage': currentPage.toString(),
      'subjectId': subjectId.toString(),
    };
    if (gradeId != null) {
      map['gradeId'] = gradeId.toString();
    }
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = ErrorbookListModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 错题本详情
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-84-V1.2.4
  static errorbookDetail({int wrongPhotoId}) async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/wrong-notebook/photo/info';
    var map = {
      'wrongPhotoId': wrongPhotoId.toString(),
    };
    var query = mapToQuery(map);
    url += '?$query';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = ErrorbookDetailModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 未读消息数
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-83-V1.2.4
  static unreadMsgCount() async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/message/unread';

    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = UnreadCountModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 删除错题
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-85-V1.2.4
  static delErrorbook({String wrongPhotoIds}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/wrong-notebook/photo';
    url += '?wrongPhotoIds=$wrongPhotoIds';
    var response =
        await NetworkManager.netFetch(url, null, null, Options(method: 'DELETE'));
    if (response.result) {
      var courseList = UnreadCountModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 错题生成pdf
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-91-V1.2.6
  static getPdf({String wrongPhotoIds}) async {
    var url =
        APIConst.CC_BASE_URL + 'api-study-service/api/wrong-notebook/pdf/';
    url += '?wrongPhotoIds=$wrongPhotoIds';
    var response =
        await NetworkManager.netFetch(url, null, null, Options(method: 'DELETE'));
    if (response.result) {
      var courseList = UnreadCountModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-76-V1.2.4
  static messageDetail({int msgId}) async {
    var url = APIConst.CC_BASE_URL + 'api-study-service/api/message';
    url += '?msgId=$msgId';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var courseList = MessageDetailModel.fromJson(response.data);

      response.model = courseList;
    }
    return response;
  }

  /// 获取错题本学科统计列表
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-61-V2.0
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-82-V1.2.4
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-86-V1.2.5
  static Future<ResponseData> errorBookList(ErrorBookType type) async {
    var url = APIConst.CC_BASE_URL +
        (type == ErrorBookType.CAMERA
            ? 'api-study-service/api/wrong-notebook/photo/subjects'
            : type == ErrorBookType.SHUXIAO
                ? 'api-study-service/api/wrong-notebook/school/subjects'
                : 'api-study-service/api/wrong-notebook/subjects');

    var response = await NetworkManager.netFetch(url, null, null, Options(method: 'GET'));
    if (response.result) {
      var model = ErrorBookModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }
}

/// [WEB]     网页错题
/// [CAMERA]  拍照错题
/// [SHUXIAO] 数校错题
enum ErrorBookType { WEB, SHUXIAO, CAMERA }
