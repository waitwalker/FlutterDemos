// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_count_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountModel _$UnreadCountModelFromJson(Map<String, dynamic> json) {
  return UnreadCountModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] as num);
}

Map<String, dynamic> _$UnreadCountModelToJson(UnreadCountModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };
