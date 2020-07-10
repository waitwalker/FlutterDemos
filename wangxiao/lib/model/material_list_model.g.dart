// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MaterialListModel _$MaterialListModelFromJson(Map<String, dynamic> json) {
  return MaterialListModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$MaterialListModelToJson(MaterialListModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      versionId: json['versionId'] as num,
      versionName: json['versionName'] as String,
      abbreviation: json['abbreviation'] as String,
      gradeId: json['gradeId'] as String,
      subjectId: json['subjectId'] as num,
      teachingMaterialDTOList: (json['teachingMaterialDTOList'] as List)
          ?.map((e) => e == null
              ? null
              : TeachingMaterialDTOListEntity.fromJson(
                  e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'versionId': instance.versionId,
      'versionName': instance.versionName,
      'abbreviation': instance.abbreviation,
      'gradeId': instance.gradeId,
      'subjectId': instance.subjectId,
      'teachingMaterialDTOList': instance.teachingMaterialDTOList
    };

TeachingMaterialDTOListEntity _$TeachingMaterialDTOListEntityFromJson(
    Map<String, dynamic> json) {
  return TeachingMaterialDTOListEntity(
      abbreviation: json['abbreviation'] as String,
      gradeId: json['gradeId'] as num,
      subjectId: json['subjectId'] as num,
      materialId: json['materialId'] as num,
      materialName: json['materialName'] as String,
      versionId: json['versionId'] as num,
      versionName: json['versionName'] as String,
      ifFiveFour: json['ifFiveFour'] as num,
      useCount: json['useCount'] as String,
      orderIndex: json['orderIndex'] as String);
}

Map<String, dynamic> _$TeachingMaterialDTOListEntityToJson(
        TeachingMaterialDTOListEntity instance) =>
    <String, dynamic>{
      'abbreviation': instance.abbreviation,
      'gradeId': instance.gradeId,
      'subjectId': instance.subjectId,
      'materialId': instance.materialId,
      'materialName': instance.materialName,
      'versionId': instance.versionId,
      'versionName': instance.versionName,
      'ifFiveFour': instance.ifFiveFour,
      'useCount': instance.useCount,
      'orderIndex': instance.orderIndex
    };
