// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) {
  return CourseModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) => e == null
              ? null
              : CourseEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

CourseEntity _$CourseEntityFromJson(Map<String, dynamic> json) {
  return CourseEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      gradeId: json['gradeId'] as num,
      courseId: json['courseId'] as num,
      courseName: json['courseName'] as String,
      liveState: json['liveState'] as num,
      termOfValidity: json['termOfValidity'] as String,
      onlineLabel: json['onlineLabel'] as num,
      aiLabel: json['aiLabel'] as num,
      zixueLabel: json['zixueLabel'] as num,
      courseCardCourseId: json['courseCardCourseId'] as num);
}

Map<String, dynamic> _$CourseEntityToJson(CourseEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'gradeId': instance.gradeId,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'liveState': instance.liveState,
      'termOfValidity': instance.termOfValidity,
      'onlineLabel': instance.onlineLabel,
      'aiLabel': instance.aiLabel,
      'zixueLabel': instance.zixueLabel,
      'courseCardCourseId': instance.courseCardCourseId
    };
