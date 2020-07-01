import 'package:json_annotation/json_annotation.dart';

part 'subject_detail_model.g.dart';

@JsonSerializable()
class SubjectDetailModel {
  num code;
  String msg;
  DataEntity data;

  SubjectDetailModel({this.code, this.msg, this.data});

  factory SubjectDetailModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectDetailModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num subjectId;
  String subjectName;
  num gradeId;
  String gradeName;
  String cardEndTime;
  num onlineLabel;
  num aiLabel;
  num zixueLabel;
  String thisCourseId;
  String thisClassQRCode;
  num courseId;
  String nextLiveTime;

  DataEntity(
      {this.subjectId,
      this.subjectName,
      this.gradeId,
      this.gradeName,
      this.cardEndTime,
      this.onlineLabel,
      this.aiLabel,
      this.zixueLabel,
      this.thisCourseId,
      this.thisClassQRCode,
      this.courseId,
      this.nextLiveTime});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
