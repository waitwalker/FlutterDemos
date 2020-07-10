import 'package:json_annotation/json_annotation.dart';

part 'activate_model.g.dart';

@JsonSerializable()
class ActivateModel {
  num code;
  String msg;
  DataEntity data;

  ActivateModel({this.code, this.msg, this.data});

  factory ActivateModel.fromJson(Map<String, dynamic> json) =>
      _$ActivateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivateModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num schoolId;
  num stateType;
  num waitAudit;

  DataEntity({this.schoolId, this.stateType});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
