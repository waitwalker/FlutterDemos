// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorBookModel _$ErrorBookModelFromJson(Map<String, dynamic> json) {
  return ErrorBookModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ErrorBookModelToJson(ErrorBookModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      cnt: json['cnt'] as num);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'cnt': instance.cnt
    };
