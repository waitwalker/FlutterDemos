import 'package:json_annotation/json_annotation.dart';

part 'self_study_model.g.dart';

@JsonSerializable()
class SelfStudyModel {
  num code;
  List<DataEntity> data;
  String msg;

  SelfStudyModel({this.code, this.data, this.msg});

  factory SelfStudyModel.fromJson(Map<String, dynamic> json) =>
      _$SelfStudyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SelfStudyModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num nodeId;
  String nodeName;
  List<ResourceIdListEntity> resourceIdList;

  DataEntity({this.nodeId, this.nodeName, this.resourceIdList});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);

  // added by hand
  List<DataEntity> children;

  /// 章1 default
  /// 节2
  /// 知识点3
  int type = 1;
}

@JsonSerializable()
class ResourceIdListEntity {
  String cTime;
  num clicks;
  num diffType;
  num downloadnum;
  num fileSize;
  String fileSuffixname;
  num fileType;
  num grade;
  String mTime;
  num netShareStatus;
  num reportnum;
  num resDegree;
  num resId;
  String resIntroduce;
  String resName;
  num resScore;
  num resSource;
  num resStatus;
  num resType;
  num shareStatus;
  num storenum;
  num subject;
  num totalShareStatus;
  num userId;

  ResourceIdListEntity(
      {this.cTime,
      this.clicks,
      this.diffType,
      this.downloadnum,
      this.fileSize,
      this.fileSuffixname,
      this.fileType,
      this.grade,
      this.mTime,
      this.netShareStatus,
      this.reportnum,
      this.resDegree,
      this.resId,
      this.resIntroduce,
      this.resName,
      this.resScore,
      this.resSource,
      this.resStatus,
      this.resType,
      this.shareStatus,
      this.storenum,
      this.subject,
      this.totalShareStatus,
      this.userId});

  factory ResourceIdListEntity.fromJson(Map<String, dynamic> json) =>
      _$ResourceIdListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceIdListEntityToJson(this);
}
