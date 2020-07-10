import 'package:online_school/model/activity_course_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:dio/dio.dart';

/// 活动课dao
/// author lca
class ActivityCourseDao {
  /// http://int.etiantian.com:39804/display/zz/SUMMER-WEB-API-01-V1.0
  static Future<ResponseData> fetch(List<int> gradeIds) async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/course/online/summer/grade';
    Options options = Options(method: "post");
    Map<String, dynamic> parameter = {"gradeIds": gradeIds};
    var response = await NetworkManager.netFetch(url, parameter, null, options);
    if (response.result) {
      var activityCourseList = ActivityCourseModel.fromJson(response.data);
      response.model = activityCourseList;
      print("活动课返回数据:${response.data}");
      return response;
    } else {
      throw Exception("活动课数据请求失败");
    }
  }
}
