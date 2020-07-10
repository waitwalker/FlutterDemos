// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_update_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckUpdateModel _$CheckUpdateModelFromJson(Map<String, dynamic> json) {
  return CheckUpdateModel(
      result: json['result'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CheckUpdateModelToJson(CheckUpdateModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      message: json['message'] as String,
      title: json['title'] as String,
      appId: json['appId'] as num,
      deviceType: json['deviceType'] as num,
      forceType: json['forceType'] as num,
      url: json['url'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'message': instance.message,
      'title': instance.title,
      'appId': instance.appId,
      'deviceType': instance.deviceType,
      'forceType': instance.forceType,
      'url': instance.url
    };
