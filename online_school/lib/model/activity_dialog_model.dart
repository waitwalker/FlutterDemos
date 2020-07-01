import 'package:json_annotation/json_annotation.dart';

part 'activity_dialog_model.g.dart';

@JsonSerializable()
class ActivityDialogModel {
  num code;
  String msg;
  DataEntity data;

  ActivityDialogModel({this.code, this.msg, this.data});

  factory ActivityDialogModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityDialogModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityDialogModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  String description;
  String picture;
  String url;
  num isOpen;
  int tagType;
  DataEntity({this.description, this.picture, this.url, this.isOpen,this.tagType});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
