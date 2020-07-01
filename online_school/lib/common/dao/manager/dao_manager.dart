import 'dart:convert';
import 'package:online_school/common/logger/logger_manager.dart';
import 'package:online_school/model/activity_course_model.dart';
import 'package:online_school/model/ett_pdf_model.dart';
import 'package:online_school/model/live_material_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/model/new/add_card_model.dart';
import 'package:online_school/model/new/college_entrance_model.dart';
import 'package:online_school/model/new/review_status_model.dart';
import 'package:online_school/model/new/submit_review_info_model.dart';
import 'package:online_school/model/upload_file_model.dart';
import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';


class DaoManager {

  ///
  /// @name fetchPDFURL
  /// @description 根据试题id获取pdf 路径
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2019-12-31
  ///
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-91-V1.2.6
  static Future<ResponseData> fetchPDFURL(Map<String,dynamic> parameter) async {
    var url = APIConst.pdfURL +
        'ai-report?m=getErrorQuestionPDF';
    var response = await NetworkManager.netFetch(url, null, null, null,queryParameters: parameter);
    if (response.code == 200) {

      print("response.data: ${response.data}");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var pdfModel = ETTPDFModel.fromJson(resultMap);
        response.model = pdfModel;
        return response;
      } else {
        var pdfModel = ETTPDFModel.fromJson(response.data);
        response.model = pdfModel;
        return response;
      }
    } else {
      var ettpdfModel = ETTPDFModel();
      ettpdfModel.type = "error";
      ResponseData responseData = ResponseData(ettpdfModel,false,-200);
      return responseData;
    }
  }

  ///
  /// @name fetchLiveMaterial
  /// @description 获取资料包
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-01-11
  ///
  /// http://192.168.10.8:8090/display/zz/NEW-ETT-API-92-V1.2.6
  static Future<ResponseData> fetchLiveMaterial(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL +
        'api-study-service/api/course/coursewares/list';
    var response = await NetworkManager.netFetch(url, null, null, null,queryParameters: parameter);
    if (response.code == 200) {
      print("response.data: ${response.data}");
      String string = json.encode(response.data);
      print("编码后:$string");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var liveMaterial = LiveMaterialModel.fromJson(resultMap);
        response.model = liveMaterial;
        return response;
      } else {
        var liveMaterial = LiveMaterialModel.fromJson(response.data);
        response.model = liveMaterial;
        return response;
      }
    } else {
      var liveMaterial = LiveMaterialModel();
      ResponseData responseData = ResponseData(liveMaterial,false,-200);
      return responseData;
    }
  }

  ///
  /// @name fetchAddCard
  /// @description 给爱学跳转过来的用户加卡
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-07
  ///
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-94-V1
  static Future<ResponseData> fetchAddCard(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL +
        'api-study-service/api/course-card/app-add-speci-card';
    var response = await NetworkManager.netFetch(url, null, null, Options(method: 'POST'),queryParameters: parameter);
    if (response.code == 200) {
      print("response.data: ${response.data}");
      String string = json.encode(response.data);
      print("编码后:$string");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var addCard = ETTAddCardModel.fromJson(resultMap);
        response.model = addCard;
        return response;
      } else {
        var addCard = ETTAddCardModel.fromJson(response.data);
        response.model = addCard;
        return response;
      }
    } else {
      var addCard = ETTAddCardModel();
      ResponseData responseData = ResponseData(addCard,false,-200);
      return responseData;
    }
  }

  ///
  /// @name fetchReviewStatus
  /// @description 获取湖北审核状态
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-25
  ///
  /// http://int.etiantian.com:39804/display/zz/HBGYHD-WEB-API-01-V1.0
  static Future<ResponseData> fetchReviewStatusInfo(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL +
        'api-study-service/api/activities/infos';
    var response = await NetworkManager.netFetch(url, null, null, Options(method: 'GET'));
    if (response.code == 200) {
      print("response.data: ${response.data}");
      String string = json.encode(response.data);
      print("编码后:$string");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var statusModel = ReviewStatusModel.fromJson(resultMap);
        response.model = statusModel;
        return response;
      } else {
        var statusModel = ReviewStatusModel.fromJson(response.data);
        response.model = statusModel;
        return response;
      }
    } else {
      var statusModel = ReviewStatusModel();
      ResponseData responseData = ResponseData(statusModel,false,-200);
      return responseData;
    }
  }


  ///
  /// @name fetchSubmitReviewInfo
  /// @description 提交审核信息
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-25
  ///
  /// http://int.etiantian.com:39804/display/zz/HBGYHD-WEB-API-02-V1.0
  static Future<ResponseData> fetchSubmitReviewInfo(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL +
        'api-study-service/api/activities/infos';
    var headers = {'content-type': 'application/json'};
    var body = jsonEncode(parameter);
    var response = await NetworkManager.netFetch(url, body, headers, Options(method: 'POST'));
    if (response.code == 200) {
      print("response.data: ${response.data}");
      String string = json.encode(response.data);
      print("编码后:$string");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var submitModel = SubmitReviewInfoModel.fromJson(resultMap);
        response.model = submitModel;
        return response;
      } else {
        var submitModel = SubmitReviewInfoModel.fromJson(response.data);
        response.model = submitModel;
        return response;
      }
    } else {
      var submitModel = SubmitReviewInfoModel();
      ResponseData responseData = ResponseData(submitModel,false,-200);
      return responseData;
    }
  }

  ///
  /// @name fetchUploadImage
  /// @description 上传审核图片
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-26
  ///
  /// http://int.etiantian.com:39804/display/zz/NEW-ETT-API-79-V1.2.4
  static fetchUploadImage(String imagePath) async {
    var url = APIConst.uploadImage;
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(imagePath),
    });

    ResponseData response = await NetworkManager.netFetch(url, formData, null, Options(method: 'POST'));

    if (response.result) {
      var model = UploadFileModel.fromJson(jsonDecode(response.data));
      String imgPath = "https://attach.etiantian.com/common/xwx/wrong/photo/";
      if (model.result == 1) {
        DateTime dateTime = DateTime.now();
        String month = formatDate(dateTime, [mm]);
        imgPath = imgPath + month + "/" + model.data.filePath;
        LoggerManager.info("上传图片完整路径:$imgPath");
        model.data.filePath = imgPath;
      } else {
        model.data.filePath = null;
      }

      response.model = model;
    } else {
      var model = UploadFileModel();
      ResponseData responseData = ResponseData(model,false,-200);
      return responseData;
    }
    return response;
  }


  ///
  /// @name fetchCollegeEntrance
  /// @description 获取高考冲刺数据
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-03-16
  ///
  /// http://int.etiantian.com:39804/display/zz/ACTIVITY-API-01-V1.0
  static Future<ResponseData> fetchCollegeEntrance(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL + 'api-study-service/api/course/activity';
    var response = await NetworkManager.netFetch(url, null, null, null,queryParameters: parameter);
    if (response.code == 200) {
      print("response.data: ${response.data}");

      /// 因为服务器返回的响应信息格式和其他接口不一样,要先decode一下
      if (response.data is String) {
        String jsonString = response.data;
        var resultMap = json.decode(jsonString);
        var activityModel = CollegeEntranceModel.fromJson(resultMap);
        response.model = activityModel;
        return response;
      } else {
        var activityModel = CollegeEntranceModel.fromJson(response.data);
        response.model = activityModel;
        return response;
      }
    } else {
      var activityModel = CollegeEntranceModel();
      ResponseData responseData = ResponseData(activityModel,false,-200);
      return responseData;
    }
  }

  ///
  /// @name fetchLiveAuthority
  /// @description 获取大师直播权限
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-05-25
  ///
  /// http://int.etiantian.com:39804/display/zz/ACTIVITY-API-01-V1.0
  static Future<ResponseData> fetchLiveAuthority(Map<String,dynamic> parameter) async {
    var url = APIConst.kBaseServerURL + 'api-cloudaccount-service/api/user/column/permits';
    var response = await NetworkManager.netFetch(url, null, null, null,queryParameters: parameter);
    if (response.code == 200) {
      print("response.data: ${response.data}");
      return response;
    } else {
      ResponseData responseData = ResponseData(null,false,-200);
      return responseData;
    }
  }
}