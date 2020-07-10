import 'package:json_annotation/json_annotation.dart';

part 'get_config.g.dart';

/**
 * auto generate by json2bean
 * Author zhuoweixian
 */
@JsonSerializable()
class GetConfig {
  GetConfig({
    this.result,
    this.msg,
    this.data,
  });

  num result;
  String msg;
  DataModel data;

  factory GetConfig.fromJson(Map<String, dynamic> json) =>
      _$GetConfigFromJson(json);

  Map<String, dynamic> toJson() => _$GetConfigToJson(this);
}

@JsonSerializable()
class DataModel {
  DataModel({
    this.isUsedSecurity,
    this.domainConfig,
  });

  num isUsedSecurity;
  DomainConfigModel domainConfig;

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}

@JsonSerializable()
class DomainConfigModel {
  DomainConfigModel({
    this.imServiceDomain,
    this.commonServiceDomain,
    this.xmppDomain,
    this.aixueDomain,
    this.chatUploadDomain,
    this.webDomain,
    this.itemDomain,
    this.answerSheetDomain,
    this.playPointList,
  });

  String imServiceDomain;
  String commonServiceDomain;
  String xmppDomain;
  String aixueDomain;
  String chatUploadDomain;
  String webDomain;
  String itemDomain;
  String answerSheetDomain;
  List<PlayPointListEntity> playPointList;

  factory DomainConfigModel.fromJson(Map<String, dynamic> json) =>
      _$DomainConfigModelFromJson(json);

  Map<String, dynamic> toJson() => _$DomainConfigModelToJson(this);
}

@JsonSerializable()
class PlayPointListEntity {
  PlayPointListEntity({
    this.pointName,
    this.isChoice,
    this.pointId,
  });

  String pointName;
  num isChoice;
  String pointId;

  factory PlayPointListEntity.fromJson(Map<String, dynamic> json) =>
      _$PlayPointListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PlayPointListEntityToJson(this);
}
