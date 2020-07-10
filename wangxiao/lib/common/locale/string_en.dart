import 'dart:io';

import 'package:online_school/common/locale/string_base.dart';

class MTTStringEn extends MTTStringBase {

  @override
  String bottom_tabbar_item_home_title = "Course";


  // ******************** 通用 begin ********************
  // 语文
  @override
  String common_chinese = "Chinese";

  // 数学
  @override
  String common_mathematics = "Mathematics";

  // 英语
  @override
  String common_english = "English";

  // 物理
  @override
  String common_physical = "Physical";

  // 化学
  @override
  String common_chemistry = "Chemistry";

  // 历史
  @override
  String common_history = "History";

  // 生物
  @override
  String common_biology = "Biology";

  // 地理
  @override
  String common_geography = "Geography";

  // 政治
  @override
  String common_politics = "Politics";

  // 没有数据
  @override
  String common_no_data = "No Data";
  // ******************** 通用 end ********************


  // ******************** 1.2 个人中心 begin ********************
  // 标题
  @override
  String personal_page_navigator_title = "";

  // 用户名label
  @override
  String personal_page_user_name_label = "User Name: ";

  // 我的下载
  @override
  String personal_page_my_download = "My Download";

  // 学习报告
  @override
  String personal_page_study_report = "Study Report";

  // 报告详情
  @override
  String personal_page_report_detail = "Report Detail";

  // 错题本
  @override
  String personal_page_error_book = "Error Book";

  // 申请课程卡
  @override
  String personal_page_apply_for_course_card = "Apply for Course Card";

  // 激活课程
  @override
  String personal_page_activate_course = "Activate Course";

  // 我的卡记录
  @override
  String personal_page_my_card_record = "My Card Record";

  // 护眼提醒
  @override
  String personal_page_eye_protection_reminder = "Eye Protection Reminder";

  // 意见反馈
  @override
  String personal_page_feedback = "Feedback";

  // 帮助
  @override
  String personal_page_help = "Help";

  // 设置
  @override
  String personal_page_setting = "Setting";

  // 湖北爱心助学公益课 免费申请
  @override
  String personal_page_hubei_public_welfare_class = "Hubei Public Welfare Class";
  // ******************** 个人中心 end ********************


  // ******************** 1.2.1 我的下载页面 begin ********************
  // 标题
  @override
  String my_download_page_navigator_title = "My Download";
  // ******************** 我的下载页面 end ********************


  // ******************** 1.2.3 错题本页面 begin ********************
  // 标题
  @override
  String error_book_page_navigator_title = "Error Book";

  // 系统错题
  @override
  String error_book_page_system_error_item = "System Error Item";

  // 上传错题
  @override
  String error_book_page_upload_error_item = "Upload Error Item";

  // 数字化校园错题
  @override
  String error_book_page_digital_campus_error_item = "Digital Campus Error Item";

  // 管理选择
  @override
  String error_book_page_choose = "Choose";

  // 取消
  @override
  String error_book_page_cancel = "Cancel";

  // 拍照上传
  @override
  String error_book_page_take_photo = "Take Photo";
  // ******************** 1.2.3 错题本页面 end ********************


  // ******************** 1.2.4 申请课程卡页面 begin ********************
  // 标题
  @override
  String apply_for_course_card_page_navigator_title = "Apply for Course Card";

  // 内容
  @override
  String apply_for_course_card_page_content = Platform.isIOS ? "如果您有智领卡, 可以在这里申请。" : "如果您有智领卡, 可以在这里激活。";

  // 卡号
  @override
  String apply_for_course_card_page_card_num = "Card Num";

  // 密码
  @override
  String apply_for_course_card_page_camille = "Camile";

  // 提交
  @override
  String apply_for_course_card_page_commit = Platform.isIOS ? "Commit" : "Activate";
  // ******************** 1.2.4 申请课程卡页面 end ********************


  // ******************** 1.2.5 我的卡记录页面 begin ********************
  // 标题
  @override
  String my_card_page_navigator_title = "My Card Record";
  // ******************** 1.2.5 我的卡记录页面 end ********************


  // ******************** 1.2.6 护眼提醒页面 begin ********************
  // 标题
  @override
  String eye_protection_reminder_page_navigator_title = "Eye Protection Reminder";

  // 内容
  @override
  String eye_protection_reminder_page_content = "为了预防学生用眼过度，四中网校为同学们提供了护眼提醒功能。使用四中网校每达到20分钟，就会收到APP的护眼提醒，同学们可以站起身放松一下，避免长时间盯住屏幕对视力造成伤害。保护同学们在舒适、健康的环境下学习，天天向上！";
  // ******************** 1.2.6 护眼提醒页面 end ********************


  // ******************** 1.2.7 意见反馈页面 begin ********************
  // 标题
  @override
  String feedback_page_navigator_title = "Commit Comment";

  // 内容
  @override
  String feedback_page_content = "少年，给应用打个分吧";

  // 输入框提示
  @override
  String feedback_page_input_hint = "欢迎吐槽（5-500个字）";

  // 发布
  @override
  String feedback_page_send = "Send";
  // ******************** 1.2.7 意见反馈页面 end ********************


  // ******************** 1.2.8 帮助页面 begin ********************
  // 标题
  @override
  String help_page_navigator_title = "Help";
  // ******************** 1.2.8 帮助页面 end ********************


  // ******************** 1.2.9 设置页面 begin ********************
  // 标题
  @override
  String setting_page_navigator_title = "Setting";

  // 个人信息
  @override
  String setting_page_personal_info = "Person Info";

  // 修改密码
  @override
  String setting_page_change_password = "Change Password";

  // 修改手机号
  @override
  String setting_page_change_mobile_num = "Change Mobile Num";

  // 关于我们
  @override
  String setting_page_about = "About";

  // 故障排查
  @override
  String setting_page_trouble_shoot = "Trouble Shoot";

  // 仅WiFi下载
  @override
  String setting_page_wifi_download_only = "WiFi Download Only";

  // 检查新版本
  @override
  String setting_page_check_version = "Check Version";

  // 切换语言
  @override
  String setting_page_change_language = "Change Language";

  // 切换主题
  @override
  String setting_page_change_theme = "Change Theme";

  // 退出登录
  @override
  String setting_page_sign_out = "Sign Out";
  // ******************** 1.2.9 设置页面 end ********************


  // ******************** 1.2.9.1 个人信息页面 begin ********************

  // 标题
  @override
  String personal_info_page_navigator_title = "Personal Info";

  // 用户ID
  @override
  String personal_info_page_user_id = "User ID";

  // 用户名
  @override
  String personal_info_page_user_name = "User Name";

  // 真实姓名
  @override
  String personal_info_page_real_name = "Real Name";

  // 性别
  @override
  String personal_info_page_gender = "Gender";

  // 生日
  @override
  String personal_info_page_birthday = "Birthday";

  // 家庭住址
  @override
  String personal_info_page_address = "Address";

  // 邮箱
  @override
  String personal_info_page_email = "Email";

  // 点击修改头像
  @override
  String personal_info_page_edit_avatar = "Edit Avatar";

  // 编辑
  @override
  String personal_info_page_edit = "Edit";

  // 保存
  @override
  String personal_info_page_save = "Save";

  // 男
  @override
  String personal_info_page_male = "Male";

  // 女
  @override
  String personal_info_page_female = "Female";
  // ******************** 1.2.9.1 个人信息页面 end ********************


  // ******************** 切换语言页面 begin ********************
  // 切换语言页面导航栏标题
  @override
  String change_language_navigator_title = "Change Language";

  // 切换语言中文标题
  @override
  String change_language_chinese_title = "Simplified Chinese";

  // 切换语言英文标题
  @override
  String change_language_english_title = "English";
// ******************** 切换语言页面 end ********************

}
