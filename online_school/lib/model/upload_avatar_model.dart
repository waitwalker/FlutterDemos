import 'package:json_annotation/json_annotation.dart';

part 'upload_avatar_model.g.dart';

@JsonSerializable()
class UploadAvatarModel {
  num result;
  String msg;
  DataEntity data;

  UploadAvatarModel({this.result, this.msg, this.data});

  factory UploadAvatarModel.fromJson(Map<String, dynamic> json) =>
      _$UploadAvatarModelFromJson(json);

  Map<String, dynamic> toJson() => _$UploadAvatarModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  String userPhoto;

  DataEntity({this.userPhoto});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
