import 'package:online_school/model/video_source_model.dart';
import 'package:online_school/model/video_url_model.dart';
import 'package:online_school/common/const/api_const.dart';
import 'package:online_school/common/network/network_manager.dart';
import 'package:online_school/common/network/response.dart';

class VideoDao {
  static Future<ResponseData> getVideoUrl(String courseId) async {
    var url = APIConst.CC_BASE_URL +
        'api-study-service/api/lives/download?onlineCourseId=$courseId';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = VideoUrlModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }

  /// 获取视频播放源列表
  static Future<ResponseData> getVideoSource() async {
    var url =
        APIConst.CC_BASE_URL + 'api-resource-service/api/resources/lines';
    var response = await NetworkManager.netFetch(url, null, null, null);
    if (response.result) {
      var model = VideoSourceModel.fromJson(response.data);
      response.model = model;
    }
    return response;
  }
}
