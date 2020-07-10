// import 'package:online_school/model/live_info_model.dart';
// import 'package:online_school/network/api_const.dart';
// import 'package:online_school/network/network_manager.dart';
// import 'package:online_school/network/response.dart';

// class CCLiveInfoDao {
//   static Future<ResultData> liveInfo(var roomId, var registerCourseId) async {
//     var url = ApiConstants.CC_BASE_URL +
//         ApiConstants.LIVE_INFO
//             .replaceAll('{roomId}', roomId.toString())
//             .replaceAll('{registerCourseId}', registerCourseId.toString());
//     var response = await Http.netFetch(url, null, null, null);
//     if (response.result) {
//       var liveInfoModel = LiveInfoModel.fromJson(response.data);
//       response.model = liveInfoModel;
//     }
//     return response;
//   }
// }
