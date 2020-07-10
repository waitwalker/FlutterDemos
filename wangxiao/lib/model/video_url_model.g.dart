// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoUrlModel _$VideoUrlModelFromJson(Map<String, dynamic> json) {
  return VideoUrlModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : LiveDataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$VideoUrlModelToJson(VideoUrlModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

LiveDataEntity _$LiveDataEntityFromJson(Map<String, dynamic> json) {
  return LiveDataEntity(
      onlineCourseId: json['onlineCourseId'] as num,
      resourceId: json['resourceId'] as num,
      onlineCourseName: json['onlineCourseName'] as String,
      videoUrl: json['videoUrl'] as String,
      playVideoUrl: json['playVideoUrl'] as String,
      imageUrl: json['imageUrl'] as String);
}

Map<String, dynamic> _$LiveDataEntityToJson(LiveDataEntity instance) =>
    <String, dynamic>{
      'onlineCourseId': instance.onlineCourseId,
      'resourceId': instance.resourceId,
      'onlineCourseName': instance.onlineCourseName,
      'videoUrl': instance.videoUrl,
      'playVideoUrl': instance.playVideoUrl,
      'imageUrl': instance.imageUrl
    };
