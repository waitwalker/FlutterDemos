import 'package:json_annotation/json_annotation.dart';

part 'check_update_model.g.dart';

@JsonSerializable()
class CheckUpdateModel {
  num result;
  String msg;
  DataEntity data;

  CheckUpdateModel({this.result, this.msg, this.data});

  factory CheckUpdateModel.fromJson(Map<String, dynamic> json) =>
      _$CheckUpdateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CheckUpdateModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  String message;
  String title;
  num appId;
  num deviceType;
  num forceType;
  String url;

  DataEntity(
      {this.message,
      this.title,
      this.appId,
      this.deviceType,
      this.forceType,
      this.url});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
