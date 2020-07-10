// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_protocol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProtocol _$GetProtocolFromJson(Map<String, dynamic> json) {
  return GetProtocol(
      result: json['result'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataModel.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$GetProtocolToJson(GetProtocol instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

DataModel _$DataModelFromJson(Map<String, dynamic> json) {
  return DataModel(
      isUsedSecurity: json['isUsedSecurity'] as num,
      domainConfig: json['domainConfig'] == null
          ? null
          : DomainConfigModel.fromJson(
              json['domainConfig'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataModelToJson(DataModel instance) => <String, dynamic>{
      'isUsedSecurity': instance.isUsedSecurity,
      'domainConfig': instance.domainConfig
    };

DomainConfigModel _$DomainConfigModelFromJson(Map<String, dynamic> json) {
  return DomainConfigModel(
      imServiceDomain: json['imServiceDomain'] as String,
      commonServiceDomain: json['commonServiceDomain'] as String,
      xmppDomain: json['xmppDomain'] as String,
      aixueDomain: json['aixueDomain'] as String,
      chatUploadDomain: json['chatUploadDomain'] as String,
      webDomain: json['webDomain'] as String,
      itemDomain: json['itemDomain'] as String,
      answerSheetDomain: json['answerSheetDomain'] as String,
      playPointList: (json['playPointList'] as List)
          ?.map((e) => e == null
              ? null
              : PlayPointListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DomainConfigModelToJson(DomainConfigModel instance) =>
    <String, dynamic>{
      'imServiceDomain': instance.imServiceDomain,
      'commonServiceDomain': instance.commonServiceDomain,
      'xmppDomain': instance.xmppDomain,
      'aixueDomain': instance.aixueDomain,
      'chatUploadDomain': instance.chatUploadDomain,
      'webDomain': instance.webDomain,
      'itemDomain': instance.itemDomain,
      'answerSheetDomain': instance.answerSheetDomain,
      'playPointList': instance.playPointList
    };

PlayPointListEntity _$PlayPointListEntityFromJson(Map<String, dynamic> json) {
  return PlayPointListEntity(
      pointName: json['pointName'] as String,
      isChoice: json['isChoice'] as num,
      pointId: json['pointId'] as String);
}

Map<String, dynamic> _$PlayPointListEntityToJson(
        PlayPointListEntity instance) =>
    <String, dynamic>{
      'pointName': instance.pointName,
      'isChoice': instance.isChoice,
      'pointId': instance.pointId
    };
