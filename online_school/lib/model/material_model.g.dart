// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialModel _$MaterialModelFromJson(Map<String, dynamic> json) {
  return MaterialModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : MaterialDataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$MaterialModelToJson(MaterialModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

MaterialDataEntity _$MaterialDataEntityFromJson(Map<String, dynamic> json) {
  return MaterialDataEntity(
      defVersionId: json['defVersionId'] as num,
      defVersionName: json['defVersionName'] as String,
      defAbbreviation: json['defAbbreviation'] as String,
      defMaterialId: json['defMaterialId'] as num,
      defMaterialName: json['defMaterialName'] as String,
      gradeId: json['gradeId'] as num,
      subjectId: json['subjectId'] as num);
}

Map<String, dynamic> _$MaterialDataEntityToJson(MaterialDataEntity instance) =>
    <String, dynamic>{
      'defVersionId': instance.defVersionId,
      'defVersionName': instance.defVersionName,
      'defAbbreviation': instance.defAbbreviation,
      'defMaterialId': instance.defMaterialId,
      'defMaterialName': instance.defMaterialName,
      'gradeId': instance.gradeId,
      'subjectId': instance.subjectId
    };
