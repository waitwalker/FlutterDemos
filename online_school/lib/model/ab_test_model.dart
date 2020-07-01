import 'package:json_annotation/json_annotation.dart';

part 'ab_test_model.g.dart';

@JsonSerializable()
class AbTestModel {
  num code;
  String msg;
  List<DataEntity> data;

  AbTestModel({this.code, this.msg, this.data});

  factory AbTestModel.fromJson(Map<String, dynamic> json) =>
      _$AbTestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbTestModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num paperId;
  String paperName;
  num resourceId;
  num srcABPaperId;
  String srcABPaperName;
  String srcABPaperQuesIds;
  String ctime;

  DataEntity(
      {this.paperId,
      this.paperName,
      this.resourceId,
      this.srcABPaperId,
      this.srcABPaperName,
      this.srcABPaperQuesIds,
      this.ctime});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
