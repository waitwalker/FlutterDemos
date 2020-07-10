// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ab_test_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbTestModel _$AbTestModelFromJson(Map<String, dynamic> json) {
  return AbTestModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AbTestModelToJson(AbTestModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      paperId: json['paperId'] as num,
      paperName: json['paperName'] as String,
      resourceId: json['resourceId'] as num,
      srcABPaperId: json['srcABPaperId'] as num,
      srcABPaperName: json['srcABPaperName'] as String,
      srcABPaperQuesIds: json['srcABPaperQuesIds'] as String,
      ctime: json['ctime'] as String);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'paperId': instance.paperId,
      'paperName': instance.paperName,
      'resourceId': instance.resourceId,
      'srcABPaperId': instance.srcABPaperId,
      'srcABPaperName': instance.srcABPaperName,
      'srcABPaperQuesIds': instance.srcABPaperQuesIds,
      'ctime': instance.ctime
    };
