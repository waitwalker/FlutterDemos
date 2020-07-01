import 'package:json_annotation/json_annotation.dart';
part 'errorbook_detail_model.g.dart';

@JsonSerializable()
class ErrorbookDetailModel {
  num code;
  String msg;
  DataEntity data;
  ErrorbookDetailModel({
    this.code,
    this.msg,
    this.data
  });

  factory ErrorbookDetailModel.fromJson(Map<String, dynamic> json) => _$ErrorbookDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorbookDetailModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num wrongPhotoId;
  num subjectId;
  String subjectName;
  num gradeId;
  String gradeName;
  String photoUrl;
  String wrongReason;
  String uploadTime;
  DataEntity({
    this.wrongPhotoId,
    this.subjectId,
    this.subjectName,
    this.gradeId,
    this.gradeName,
    this.photoUrl,
    this.wrongReason,
    this.uploadTime
  });

  factory DataEntity.fromJson(Map<String, dynamic> json) => _$DataEntityFromJson(json);
  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}