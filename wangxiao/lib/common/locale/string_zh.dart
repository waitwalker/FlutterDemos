import 'dart:io';

import 'package:online_school/common/locale/string_base.dart';

class MTTStringZh extends MTTStringBase {

  @override
  String bottom_tabbar_item_home_title = "我的课程";


  // ******************** 通用 begin ********************
  // 语文
  @override
  String common_chinese = "语文";

  // 数学
  @override
  String common_mathematics = "数学";

  // 英语
  @override
  String common_english = "英语";

  // 物理
  @override
  String common_physical = "物理";

  // 化学
  @override
  String common_chemistry = "化学";

  // 历史
  @override
  String common_history = "历史";

  // 生物
  @override
  String common_biology = "生物";

  // 地理
  @override
  String common_geography = "地理";

  // 政治
  @override
  String common_politics = "政治";
  
  // 没有数据
  @override
  String common_no_data = "没有数据";
  // ******************** 通用 end ********************


  // ******************** 1.2 个人中心 begin ********************
  // 标题
  @override
  String personal_page_navigator_title = "";

  // 用户名label
  @override
  String personal_page_user_name_label = "用户名: ";

  // 我的下载
  @override
  String personal_page_my_download = "我的下载";

  // 学习报告
  @override
  String personal_page_study_report = "学习报告";

  // 报告详情
  @override
  String personal_page_report_detail = "报告详情";

  // 错题本
  @override
  String personal_page_error_book = "错题本";

  // 申请课程卡
  @override
  String personal_page_apply_for_course_card = "申请课程卡";

  // 激活课程
  @override
  String personal_page_activate_course = "激活课程";

  // 我的卡记录
  @override
  String personal_page_my_card_record = "我的卡记录";

  // 护眼提醒
  @override
  String personal_page_eye_protection_reminder = "护眼提醒";

  // 意见反馈
  @override
  String personal_page_feedback = "意见反馈";

  // 帮助
  @override
  String personal_page_help = "帮助";

  // 设置
  @override
  String personal_page_setting = "设置";

  // 湖北爱心助学公益课 免费申请
  @override
  String personal_page_hubei_public_welfare_class = "湖北爱心助学公益课 免费申请";
  // ******************** 个人中心 end ********************


  // ******************** 1.2.1 我的下载页面 begin ********************
  // 标题
  @override
  String my_download_page_navigator_title = "我的下载";
  // ******************** 我的下载页面 end ********************


  // ******************** 1.2.3 错题本页面 begin ********************
  // 标题
  @override
  String error_book_page_navigator_title = "错题本";

  // 系统错题
  @override
  String error_book_page_system_error_item = "系统错题";

  // 上传错题
  @override
  String error_book_page_upload_error_item = "上传错题";

  // 数字化校园错题
  @override
  String error_book_page_digital_campus_error_item = "数字化校园错题";

  // 管理选择
  @override
  String error_book_page_choose = "管理";

  // 取消
  @override
  String error_book_page_cancel = "取消";

  // 拍照上传
  @override
  String error_book_page_take_photo = "拍照上传";
  // ******************** 1.2.3 错题本页面 end ********************


  // ******************** 1.2.4 申请课程卡页面 begin ********************
  // 标题
  @override
  String apply_for_course_card_page_navigator_title = "课程申请";

  // 内容
  @override
  String apply_for_course_card_page_content = Platform.isIOS ? "如果您有智领卡, 可以在这里申请。" : "如果您有智领卡, 可以在这里激活。";

  // 卡号
  @override
  String apply_for_course_card_page_card_num = "卡号";

  // 密码
  @override
  String apply_for_course_card_page_camille = "密码";

  // 提交
  @override
  String apply_for_course_card_page_commit = Platform.isIOS ? "提交" : "激活";
  // ******************** 1.2.4 申请课程卡页面 end ********************


  // ******************** 1.2.5 我的卡记录页面 begin ********************
  // 标题
  @override
  String my_card_page_navigator_title = "我的卡记录";
  // ******************** 1.2.5 我的卡记录页面 end ********************


  // ******************** 1.2.6 护眼提醒页面 begin ********************
  // 标题
  @override
  String eye_protection_reminder_page_navigator_title = "护眼提醒";

  // 内容
  @override
  String eye_protection_reminder_page_content = "为了预防学生用眼过度，四中网校为同学们提供了护眼提醒功能。使用四中网校每达到20分钟，就会收到APP的护眼提醒，同学们可以站起身放松一下，避免长时间盯住屏幕对视力造成伤害。保护同学们在舒适、健康的环境下学习，天天向上！";
  // ******************** 1.2.6 护眼提醒页面 end ********************


  // ******************** 1.2.7 意见反馈页面 begin ********************
  // 标题
  @override
  String feedback_page_navigator_title = "发表评论";

  // 内容
  @override
  String feedback_page_content = "少年，给应用打个分吧";

  // 输入框提示
  @override
  String feedback_page_input_hint = "欢迎吐槽（5-500个字）";

  // 发布
  @override
  String feedback_page_send = "发布";
  // ******************** 1.2.7 意见反馈页面 end ********************


  // ******************** 1.2.8 帮助页面 begin ********************
  // 标题
  @override
  String help_page_navigator_title = "帮助";
  // ******************** 1.2.8 帮助页面 end ********************


  // ******************** 1.2.9 设置页面 begin ********************
  // 标题
  @override
  String setting_page_navigator_title = "设置";

  // 个人信息
  @override
  String setting_page_personal_info = "个人信息";

  // 修改密码
  @override
  String setting_page_change_password = "修改密码";

  // 修改手机号
  @override
  String setting_page_change_mobile_num = "修改手机号";

  // 关于我们
  @override
  String setting_page_about = "关于我们";

  // 故障排查
  @override
  String setting_page_trouble_shoot = "故障排查";

  // 仅WiFi下载
  @override
  String setting_page_wifi_download_only = "仅WiFi下载";

  // 检查新版本
  @override
  String setting_page_check_version = "检查新版本";

  // 切换语言
  @override
  String setting_page_change_language = "切换语言";

  // 切换主题
  @override
  String setting_page_change_theme = "切换主题";

  // 退出登录
  @override
  String setting_page_sign_out = "退出登录";
  // ******************** 1.2.9 设置页面 end ********************


  // ******************** 1.2.9.1 个人信息页面 begin ********************

  // 标题
  @override
  String personal_info_page_navigator_title = "个人信息";

  // 用户ID
  @override
  String personal_info_page_user_id = "用户ID";

  // 用户名
  @override
  String personal_info_page_user_name = "用户名";

  // 真实姓名
  @override
  String personal_info_page_real_name = "真实姓名";

  // 性别
  @override
  String personal_info_page_gender = "性别";

  // 生日
  @override
  String personal_info_page_birthday = "生日";

  // 家庭住址
  @override
  String personal_info_page_address = "家庭住址";

  // 邮箱
  @override
  String personal_info_page_email = "邮箱";

  // 点击修改头像
  @override
  String personal_info_page_edit_avatar = "点击修改头像";

  // 编辑
  @override
  String personal_info_page_edit = "编辑";

  // 保存
  @override
  String personal_info_page_save = "保存";

  // 男
  @override
  String personal_info_page_male = "男";

  // 女
  @override
  String personal_info_page_female = "女";
  // ******************** 1.2.9.1 个人信息页面 end ********************


  // ******************** 切换语言页面 begin ********************
  // 标题
  @override
  String change_language_navigator_title = "切换语言";

  // 切换语言中文标题
  @override
  String change_language_chinese_title = "中文简体";

  // 切换语言英文标题
  @override
  String change_language_english_title = "English";
// ******************** 切换语言页面 end ********************


}
