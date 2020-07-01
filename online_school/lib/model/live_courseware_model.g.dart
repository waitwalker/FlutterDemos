// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_courseware_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveCoursewareModel _$LiveCoursewareModelFromJson(Map<String, dynamic> json) {
  return LiveCoursewareModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$LiveCoursewareModelToJson(
        LiveCoursewareModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      courseId: json['courseId'] as num,
      resourceId: json['resourceId'] as num,
      name: json['name'] as String,
      classId: json['classId'] as num,
      path: json['path'] as String,
      fileName: json['fileName'] as String,
      subjectId: json['subjectId'] as num,
      schoolId: json['schoolId'] as num,
      ownerSchoolId: json['ownerSchoolId'] as num,
      submitUserId: json['submitUserId'] as num,
      submitUsername: json['submitUsername'] as String,
      enable: json['enable'] as num,
      enableUserId: json['enableUserId'] as num,
      enableUsername: json['enableUsername'] as String,
      fileUrl: json['fileUrl'] as String,
      ctime: json['ctime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'resourceId': instance.resourceId,
      'name': instance.name,
      'classId': instance.classId,
      'path': instance.path,
      'fileName': instance.fileName,
      'subjectId': instance.subjectId,
      'schoolId': instance.schoolId,
      'ownerSchoolId': instance.ownerSchoolId,
      'submitUserId': instance.submitUserId,
      'submitUsername': instance.submitUsername,
      'enable': instance.enable,
      'enableUserId': instance.enableUserId,
      'enableUsername': instance.enableUsername,
      'fileUrl': instance.fileUrl,
      'ctime': instance.ctime
    };
