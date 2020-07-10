// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectDetailModel _$SubjectDetailModelFromJson(Map<String, dynamic> json) {
  return SubjectDetailModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SubjectDetailModelToJson(SubjectDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      gradeId: json['gradeId'] as num,
      gradeName: json['gradeName'] as String,
      cardEndTime: json['cardEndTime'] as String,
      onlineLabel: json['onlineLabel'] as num,
      aiLabel: json['aiLabel'] as num,
      zixueLabel: json['zixueLabel'] as num,
      thisCourseId: json['thisCourseId'] as String,
      thisClassQRCode: json['thisClassQRCode'] as String,
      courseId: json['courseId'] as num,
      nextLiveTime: json['nextLiveTime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'gradeId': instance.gradeId,
      'gradeName': instance.gradeName,
      'cardEndTime': instance.cardEndTime,
      'onlineLabel': instance.onlineLabel,
      'aiLabel': instance.aiLabel,
      'zixueLabel': instance.zixueLabel,
      'thisCourseId': instance.thisCourseId,
      'thisClassQRCode': instance.thisClassQRCode,
      'courseId': instance.courseId,
      'nextLiveTime': instance.nextLiveTime
    };
