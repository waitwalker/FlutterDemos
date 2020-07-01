import 'package:json_annotation/json_annotation.dart';
part 'upload_file_model.g.dart';

@JsonSerializable()
class UploadFileModel {
  num result;
  String msg;
  DataEntity data;
  UploadFileModel({
    this.result,
    this.msg,
    this.data
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) => _$UploadFileModelFromJson(json);
  Map<String, dynamic> toJson() => _$UploadFileModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  String filePath;
  DataEntity({
    this.filePath
  });

  factory DataEntity.fromJson(Map<String, dynamic> json) => _$DataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}