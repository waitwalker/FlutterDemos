// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUpdateCheck _$AppUpdateCheckFromJson(Map<String, dynamic> json) {
  return AppUpdateCheck(
      result: json['result'],
      data: json['data'] == null
          ? null
          : UpdateData.fromJson(json['data'] as Map<String, dynamic>))
    ..msg = json['msg'] as String;
}

Map<String, dynamic> _$AppUpdateCheckToJson(AppUpdateCheck instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

UpdateData _$UpdateDataFromJson(Map<String, dynamic> json) {
  return UpdateData(
      forceType: json['forceType'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$UpdateDataToJson(UpdateData instance) =>
    <String, dynamic>{
      'forceType': instance.forceType,
      'title': instance.title,
      'message': instance.message,
      'url': instance.url
    };
