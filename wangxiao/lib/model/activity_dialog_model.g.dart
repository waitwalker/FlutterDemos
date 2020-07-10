// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_dialog_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityDialogModel _$ActivityDialogModelFromJson(Map<String, dynamic> json) {
  return ActivityDialogModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ActivityDialogModelToJson(
        ActivityDialogModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      description: json['description'] as String,
      picture: json['picture'] as String,
      url: json['url'] as String,
      isOpen: json['isOpen'] as num);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'description': instance.description,
      'picture': instance.picture,
      'url': instance.url,
      'isOpen': instance.isOpen,
    };
