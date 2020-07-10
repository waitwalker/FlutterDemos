import 'package:json_annotation/json_annotation.dart';

part 'card_list_model.g.dart';

@JsonSerializable()
class CardListModel {
  num code;
  String msg;
  DataEntity data;

  CardListModel({this.code, this.msg, this.data});

  factory CardListModel.fromJson(Map<String, dynamic> json) =>
      _$CardListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CardListModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num activationNumber;
  List<CourseInfoResultDTOSEntity> courseInfoResultDTOS;

  DataEntity({this.activationNumber, this.courseInfoResultDTOS});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class CourseInfoResultDTOSEntity {
  num courseId;
  String courseName;
  num subjectId;
  num gradeId;
  String subjectName;

  CourseInfoResultDTOSEntity(
      {this.courseId,
      this.courseName,
      this.subjectId,
      this.subjectName,
      this.gradeId});

  factory CourseInfoResultDTOSEntity.fromJson(Map<String, dynamic> json) =>
      _$CourseInfoResultDTOSEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CourseInfoResultDTOSEntityToJson(this);
}
