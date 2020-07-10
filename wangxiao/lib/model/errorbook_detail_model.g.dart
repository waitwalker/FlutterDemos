// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errorbook_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorbookDetailModel _$ErrorbookDetailModelFromJson(Map<String, dynamic> json) {
  return ErrorbookDetailModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ErrorbookDetailModelToJson(
        ErrorbookDetailModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      wrongPhotoId: json['wrongPhotoId'] as num,
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      gradeId: json['gradeId'] as num,
      gradeName: json['gradeName'] as String,
      photoUrl: json['photoUrl'] as String,
      wrongReason: json['wrongReason'] as String,
      uploadTime: json['uploadTime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'wrongPhotoId': instance.wrongPhotoId,
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'gradeId': instance.gradeId,
      'gradeName': instance.gradeName,
      'photoUrl': instance.photoUrl,
      'wrongReason': instance.wrongReason,
      'uploadTime': instance.uploadTime
    };
