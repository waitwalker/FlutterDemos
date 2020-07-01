// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'micro_course_resource_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MicroCourseResourceModel _$MicroCourseResourceModelFromJson(
    Map<String, dynamic> json) {
  return MicroCourseResourceModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : MicroCourseResourceDataEntity.fromJson(
              json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MicroCourseResourceModelToJson(
        MicroCourseResourceModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

MicroCourseResourceDataEntity _$MicroCourseResourceDataEntityFromJson(
    Map<String, dynamic> json) {
  return MicroCourseResourceDataEntity(
      resouceId: json['resouceId'] as num,
      resourceName: json['resourceName'] as String,
      imageUrl: json['imageUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      planUrlList: (json['planUrlList'] as List)
          ?.map((e) => e == null
              ? null
              : PlanUrlListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      path: json['path'] as String);
}

Map<String, dynamic> _$MicroCourseResourceDataEntityToJson(
        MicroCourseResourceDataEntity instance) =>
    <String, dynamic>{
      'resouceId': instance.resouceId,
      'resourceName': instance.resourceName,
      'imageUrl': instance.imageUrl,
      'videoUrl': instance.videoUrl,
      'planUrlList': instance.planUrlList,
      'path': instance.path
    };

PlanUrlListEntity _$PlanUrlListEntityFromJson(Map<String, dynamic> json) {
  return PlanUrlListEntity(
      previewPlanUrl: json['previewPlanUrl'] as String,
      dowPlanUrl: json['dowPlanUrl'] as String);
}

Map<String, dynamic> _$PlanUrlListEntityToJson(PlanUrlListEntity instance) =>
    <String, dynamic>{
      'previewPlanUrl': instance.previewPlanUrl,
      'dowPlanUrl': instance.dowPlanUrl
    };
