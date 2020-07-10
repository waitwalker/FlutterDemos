// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivateModel _$ActivateModelFromJson(Map<String, dynamic> json) {
  return ActivateModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$ActivateModelToJson(ActivateModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      schoolId: json['schoolId'] as num, stateType: json['stateType'] as num)
    ..waitAudit = json['waitAudit'] as num;
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'schoolId': instance.schoolId,
      'stateType': instance.stateType,
      'waitAudit': instance.waitAudit
    };
