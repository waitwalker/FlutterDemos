// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_home_course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewHomeCourseModel _$NewHomeCourseModelFromJson(Map<String, dynamic> json) {
  return NewHomeCourseModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$NewHomeCourseModelToJson(NewHomeCourseModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      grades: (json['grades'] as List)
          ?.map((e) => e == null
              ? null
              : GradesEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'grades': instance.grades
    };

GradesEntity _$GradesEntityFromJson(Map<String, dynamic> json) {
  return GradesEntity(
      gradeId: json['gradeId'] as num, gradeName: json['gradeName'] as String);
}

Map<String, dynamic> _$GradesEntityToJson(GradesEntity instance) =>
    <String, dynamic>{
      'gradeId': instance.gradeId,
      'gradeName': instance.gradeName
    };
