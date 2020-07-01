import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'self_model.g.dart';

@JsonSerializable()
class SelfModel {
  num code;
  List<DataEntity> data;
  String msg;

  SelfModel({this.code, this.data, this.msg});

  factory SelfModel.fromJson(Map<String, dynamic> json) =>
      _$SelfModelFromJson(json);

  Map<String, dynamic> toJson() => _$SelfModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num nodeId;///节点id
  String nodeName;///节点名称
  List<ResourceIdListEntity> resourceIdList;///资源id列表
  num level;///层级
  List<DataEntity> nodeList;///节点列表

  DataEntity(
      {this.nodeId,
      this.nodeName,
      this.resourceIdList,
      this.level,
      this.nodeList});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);

  // add by hand
  bool expanded = true;
}

@JsonSerializable()
class ResourceIdListEntity extends Equatable {
  num resId;
  String resName;
  num resType;
  String srcABPaperQuesIds;
  num studyStatus;

  ResourceIdListEntity({
    this.resId,
    this.resName,
    this.resType,
    this.srcABPaperQuesIds,
    this.studyStatus,
  }) : super([resId, resName, resType, srcABPaperQuesIds, studyStatus]);

  factory ResourceIdListEntity.fromJson(Map<String, dynamic> json) =>
      _$ResourceIdListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceIdListEntityToJson(this);
}
