// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardListModel _$CardListModelFromJson(Map<String, dynamic> json) {
  return CardListModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$CardListModelToJson(CardListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      activationNumber: json['activationNumber'] as num,
      courseInfoResultDTOS: (json['courseInfoResultDTOS'] as List)
          ?.map((e) => e == null
              ? null
              : CourseInfoResultDTOSEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'activationNumber': instance.activationNumber,
      'courseInfoResultDTOS': instance.courseInfoResultDTOS
    };

CourseInfoResultDTOSEntity _$CourseInfoResultDTOSEntityFromJson(
    Map<String, dynamic> json) {
  return CourseInfoResultDTOSEntity(
      courseId: json['courseId'] as num,
      courseName: json['courseName'] as String,
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      gradeId: json['gradeId'] as num);
}

Map<String, dynamic> _$CourseInfoResultDTOSEntityToJson(
        CourseInfoResultDTOSEntity instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'subjectId': instance.subjectId,
      'gradeId': instance.gradeId,
      'subjectName': instance.subjectName
    };
