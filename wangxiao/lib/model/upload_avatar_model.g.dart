// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_avatar_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadAvatarModel _$UploadAvatarModelFromJson(Map<String, dynamic> json) {
  return UploadAvatarModel(
      result: json['result'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$UploadAvatarModelToJson(UploadAvatarModel instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(userPhoto: json['userPhoto'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{'userPhoto': instance.userPhoto};
