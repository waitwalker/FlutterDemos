import 'dart:io';
import 'package:online_school/common/tools/share_preference.dart';
//import 'package:flutter_umeng_analytics/flutter_umeng_analytics.dart';
import 'package:package_channels/package_channels.dart';
import 'package:umeng_plugin/umeng_plugin.dart';


///
/// @name 注册友盟
/// @description 
/// @author liuca
/// @date 2020-01-11
///
class Global {
  static init() async {
    // 设置了本地化，和这条冲突
    // initializeDateFormatting('zh_CN');
    await SharedPrefsUtils.init();
//    if (Platform.isAndroid)
//      UMengAnalytics.init('5cbd8c740cafb2e076000fb5',
//          channel: await PackageChannels.getChannel,
//          policy: Policy.BATCH,
//          encrypt: true,
//          reportCrash: true,
//          logEnable: true);
//    else if (Platform.isIOS)
//      UMengAnalytics.init('5cbd8cdd3fc195db0a0008bc',
//          policy: Policy.BATCH,
//          encrypt: true,
//          reportCrash: true,
//          logEnable: true);

    // 测试App统计
//    if (Platform.isAndroid)
//      UmengPlugin.init('5efc417f978eea08339b82a6',
//          channel: await PackageChannels.getChannel,
//          policy: Policy.BATCH,
//          encrypt: true,
//          reportCrash: true,
//          logEnable: true);
//    else if (Platform.isIOS)
//      UmengPlugin.init('5efc41efdbc2ec078c813284',
//          policy: Policy.BATCH,
//          encrypt: true,
//          reportCrash: true,
//          logEnable: true);

    if (Platform.isAndroid)
      UmengPlugin.init('5cbd8c740cafb2e076000fb5',
          channel: await PackageChannels.getChannel,
          policy: Policy.BATCH,
          encrypt: true,
          reportCrash: true,
          logEnable: true);
    else if (Platform.isIOS)
      UmengPlugin.init('5cbd8cdd3fc195db0a0008bc',
          policy: Policy.BATCH,
          encrypt: true,
          reportCrash: true,
          logEnable: true);
  }
}
