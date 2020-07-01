import 'package:json_annotation/json_annotation.dart';

part 'activity_promt_model.g.dart';

@JsonSerializable()
class ActivityPromtModel {
  num code;
  String msg;
  DataEntity data;

  ActivityPromtModel({this.code, this.msg, this.data});

  factory ActivityPromtModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityPromtModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityPromtModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  String description;
  String picture;
  String url;
  num isOpen;

  DataEntity({this.description, this.picture, this.url, this.isOpen});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
