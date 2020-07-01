import 'dart:convert';
import 'dart:io';
import 'package:online_school/common/config/config.dart';

///
/// @name 接口常量
/// @description 
/// @author liuca
/// @date 2020-01-11
///
class APIConst {
  static final String EDX_BASE = 'http://192.168.9.90:8001';
  static final String EDX_CLIENT_ID = 'f0e9c98eeb6d1c46f1a8';
  static final String ORGNIZATION = 'etiantian';

  static final String COURSE_ID = "courseId";
  static final String USER_NAME = "username";
  static final String GROUP_ID = "groupId";
  static final String ORG_CODE = "org";

  static final String URL_MY_USER_INFO = "/api/mobile/v0.5/my_user_info";

  static final String URL_COURSE_ENROLLMENTS =
      "/api/mobile/v0.5/users/{username}/course_enrollments";

  static final String URL_VIDEO_OUTLINE =
      "/api/mobile/v0.5/video_outlines/courses/{courseId}";

  static final String URL_ACCESS_TOKEN = "/oauth2/access_token/";

  static final String URL_PASSWORD_RESET = "/password_reset/";

  static final String URL_EXCHANGE_ACCESS_TOKEN =
      "/oauth2/exchange_access_token/{" + GROUP_ID + "}/";

  static final String URL_REVOKE_TOKEN = "/oauth2/revoke_token/";

  static final String URL_LOGIN = "/oauth2/login/";

  static final String URL_LAST_ACCESS_FOR_COURSE =
      "/api/mobile/v0.5/users/{username}/course_status_info/{courseId}";

  static final String URL_REGISTRATION = "/user_api/v1/account/registration/";

  static final String URL_ENROLLMENT = "/api/enrollment/v1/enrollment";

  static final String URL_COURSE_OUTLINE_SHORT = "/api/courses/v1/blocks/";
  static final String URL_COURSE_OUTLINE =
      "/api/courses/v1/blocks/?course_id={courseId}&username={username}&depth=all&requested_fields={requested_fields}&student_view_data={student_view_data}&block_counts={block_counts}&nav_depth=3";

  static final int STANDARD_PAGE_SIZE = 20;

  static final String PARAM_PAGE_SIZE =
      "page_size=" + STANDARD_PAGE_SIZE.toString();

  static String getOAuthGroupIdForAuthBackend(AuthBackend authBackend) {
    switch (authBackend) {
      case AuthBackend.WECHAT:{
          return "0"; //PrefManager.Value.BACKEND_FACEBOOK;
        }
      case AuthBackend.WEIBO:{
          return "1"; //PrefManager.Value.BACKEND_GOOGLE;
        }
      default:{
          throw new Exception(authBackend);
        }
    }
  }

// YOUZAN
  static String client_id = '4c7a9db8011e2e5bd0';
  static String client_secret = '5f71208038d7db0277c25a2ad8764772';
  static String kdt_id = '42376938'; // 绑定的店铺的ID
  static String shop_url =
      'https://h5.youzan.com/wscshop/showcase/homepage?alias=shELg1X8sS';

// CC LOGIN

  //ANDROID版本：正式
  static String appIdAnd = Config.DEBUG
      ? '61205659F875DE5F8116A616E7489DB7'
      : 'C2ABCA7EBE1A93D1F0A1C3D9E8D6B79E';
  static String appSecretAnd = Config.DEBUG
      ? '3F56D81773FEE0D0A104B3D32FB880D3'
      : '2765F72C83B05066CB7B65F3650E3440';

  static String appIdIos = Config.DEBUG
      ? '071DC04BB4053F236AD7DF478A8E4A17'
      : '2F5EE5930505950FA5D0F215171C15F9';
  static String appSecretIos = Config.DEBUG
      ? 'BA451F0E9F31B3A270C08F3BB38E33BE'
      : '832E7959E349487D043D1561894AFD74';

  static String get appId => Platform.isAndroid ? appIdAnd : appIdIos;

  static String get appSecret =>
      Platform.isAndroid ? appSecretAnd : appSecretIos;

  static String get basicToken => base64Encode('$appId:$appSecret'.codeUnits);

  static const CC_BASE_URL = Config.DEBUG
      ? 'http://gw5.bj.etiantian.net:42393/'
      : 'https://school.etiantian.com/';

  static String courseList =
      'api-study-service/api/course/online/grade/{gradeId}';
  static String USER_INFO = 'api-study-service/api/students/info';
  static String LIVE_INFO =
      'api-study-service/api/lives/{roomId}/{registerCourseId}';

  // 找回密码
  static String RESET_PWD = 'api/user/password';

  // 修改密码
  static String CHANGE_PWD = 'api/user/info/password';

  static String liveHost = Config.DEBUG
      ? 'http://school.etiantian.com/cc-webt/mobile2.html'
      : 'http://school.etiantian.com/cc-web/mobile2.html';
  static String backHost = Config.DEBUG
      ? 'http://school.etiantian.com/cc-webt/back.html'
      : 'http://school.etiantian.com/cc-web/back.html';

  // 练习题，ai，自我学习
  static String practiceHost = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:15283/nwx-app'
      : 'https://item.etiantian.com/nwx-app';

  // 通用服务
  static String commonHost = Config.DEBUG
      ? 'http://i2.m.etiantian.com:48083/app-common-service'
      : 'https://i.im.etiantian.com/app-common-service';

  // app store 应用详情页
  static String appstoreUrl =
      'https://apps.apple.com/cn/app/%E5%8C%97%E4%BA%AC%E5%9B%9B%E4%B8%AD%E7%BD%91%E6%A0%A1/id1456594477';

  //学习报告url
  static String studyReport = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:15283/nwx-app/learningreporta.html'
      : 'https://item.etiantian.com/nwx-app/learningreporta.html';
  static String studyReportall = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:15283/nwx-app/learningreportall.html'
      : 'https://item.etiantian.com/nwx-app/learningreportall.html';

  //错题本url
  static String errorBook = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:15283/nwx-app/errorbooklist.html'
      : 'https://item.etiantian.com/nwx-app/errorbooklist.html';

  //数校错题本url
  static String errorBookShuXiao = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:15283/nwx-app/errorbookschoollist.html'
      : 'https://item.etiantian.com/nwx-app/errorbookschoollist.html';

  //图片上传url
  static String uploadImage = Config.DEBUG
      ? 'http://gw1.bj.etiantian.net:18480/ett20/totalmanage/service/testonline/paper/uploadFileXWXBackstage.jsp'
      : 'https://resource.etiantian.com/ett20/totalmanage/service/testonline/paper/uploadFileXWXBackstage.jsp';

  /// 获取pdf url
  static String pdfURL = Config.DEBUG
      ? 'http://ai-classes.com/qiyi_school_filet125/'
      : 'http://www.ai-classes.com/qiyi_school_file/';

  /// 服务器主URL
  static String kBaseServerURL = Config.DEBUG
      ? 'http://gw5.bj.etiantian.net:42393/'
      : 'https://school.etiantian.com/';
}

enum Token_Type { TOKEN_TYPE_ACCESS, TOKEN_TYPE_REFRESH }

enum AuthBackend { WECHAT, WEIBO }
