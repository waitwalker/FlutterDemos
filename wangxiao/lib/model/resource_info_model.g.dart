// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resource_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResourceInfoModel _$ResourceInfoModelFromJson(Map<String, dynamic> json) {
  return ResourceInfoModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ResourceInfoModelToJson(ResourceInfoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      resouceId: json['resouceId'] as num,
      resourceName: json['resourceName'] as String,
      imageUrl: json['imageUrl'] as String,
      introduction: json['introduction'] as String,
      videoUrl: json['videoUrl'] as String,
      downPlanUrl: json['downPlanUrl'] as String,
      authorName: json['authorName'] as String,
      authorIntro: json['authorIntro'] as String,
      points: (json['points'] as List)
          ?.map((e) => e == null
              ? null
              : PointsEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      path: json['path'] as String,
      fileName: json['fileName'] as String,
      literatureDownUrl: json['literatureDownUrl'] as String,
      literaturePreviewUrl: json['literaturePreviewUrl'] as String,
      downloadVideoUrl: json['downloadVideoUrl'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'resouceId': instance.resouceId,
      'resourceName': instance.resourceName,
      'imageUrl': instance.imageUrl,
      'introduction': instance.introduction,
      'videoUrl': instance.videoUrl,
      'downPlanUrl': instance.downPlanUrl,
      'authorName': instance.authorName,
      'authorIntro': instance.authorIntro,
      'points': instance.points,
      'path': instance.path,
      'fileName': instance.fileName,
      'literatureDownUrl': instance.literatureDownUrl,
      'literaturePreviewUrl': instance.literaturePreviewUrl,
      'downloadVideoUrl': instance.downloadVideoUrl
    };

PointsEntity _$PointsEntityFromJson(Map<String, dynamic> json) {
  return PointsEntity(
      point: json['point'] as num, title: json['title'] as String);
}

Map<String, dynamic> _$PointsEntityToJson(PointsEntity instance) =>
    <String, dynamic>{'point': instance.point, 'title': instance.title};
