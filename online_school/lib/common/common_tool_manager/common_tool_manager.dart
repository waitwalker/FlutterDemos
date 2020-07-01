import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';

///
/// @name CommonToolManager
/// @description 通用工具管理类,比如获取某个权限之类
/// @author liuca
/// @date 2020/5/25
///
class CommonToolManager {
  static fetchLiveAuthority() async {
    ResponseData responseData = await DaoManager.fetchLiveAuthority({});
    if (responseData.code == 200) {
      var originalData = responseData.data;
      if (originalData != null) {
        Map data = originalData["data"];
        int isHaveLiveAuthority = data["zllivePermits"];
        if (isHaveLiveAuthority != null && isHaveLiveAuthority == 1) {
          SingletonManager.sharedInstance.isHaveLiveAuthority = true;
        } else {
          SingletonManager.sharedInstance.isHaveLiveAuthority = false;
        }
      }
    } else {
      SingletonManager.sharedInstance.isHaveLiveAuthority = false;
    }
    print("response:$responseData");
  }
}