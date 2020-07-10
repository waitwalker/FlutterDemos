// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfModel _$SelfModelFromJson(Map<String, dynamic> json) {
  return SelfModel(
      code: json['code'] as num,
      data: (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      msg: json['msg'] as String);
}

Map<String, dynamic> _$SelfModelToJson(SelfModel instance) => <String, dynamic>{
      'code': instance.code,
      'data': instance.data,
      'msg': instance.msg
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      nodeId: json['nodeId'] as num,
      nodeName: json['nodeName'] as String,
      resourceIdList: (json['resourceIdList'] as List)
          ?.map((e) => e == null
              ? null
              : ResourceIdListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      level: json['level'] as num,
      nodeList: (json['nodeList'] as List)
          ?.map((e) =>
              e == null ? null : DataEntity.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..expanded = json['expanded'] as bool;
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'nodeId': instance.nodeId,
      'nodeName': instance.nodeName,
      'resourceIdList': instance.resourceIdList,
      'level': instance.level,
      'nodeList': instance.nodeList,
      'expanded': instance.expanded
    };

ResourceIdListEntity _$ResourceIdListEntityFromJson(Map<String, dynamic> json) {
  return ResourceIdListEntity(
      resId: json['resId'] as num,
      resName: json['resName'] as String,
      resType: json['resType'] as num,
      srcABPaperQuesIds: json['srcABPaperQuesIds'] as String,
      studyStatus: json['studyStatus'] as num);
}

Map<String, dynamic> _$ResourceIdListEntityToJson(
        ResourceIdListEntity instance) =>
    <String, dynamic>{
      'resId': instance.resId,
      'resName': instance.resName,
      'resType': instance.resType,
      'srcABPaperQuesIds': instance.srcABPaperQuesIds,
      'studyStatus': instance.studyStatus
    };
