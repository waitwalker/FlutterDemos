// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoSourceModel _$VideoSourceModelFromJson(Map<String, dynamic> json) {
  return VideoSourceModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : VideoSource.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$VideoSourceModelToJson(VideoSourceModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

VideoSource _$DataEntityFromJson(Map<String, dynamic> json) {
  return VideoSource(
      lineId: json['lineId'] as num,
      lineName: json['lineName'] as String,
      lineUrl: json['lineUrl'] as String);
}

Map<String, dynamic> _$DataEntityToJson(VideoSource instance) =>
    <String, dynamic>{
      'lineId': instance.lineId,
      'lineName': instance.lineName,
      'lineUrl': instance.lineUrl
    };
