import 'package:json_annotation/json_annotation.dart';

part 'course_model.g.dart';

@JsonSerializable()
class CourseModel {
  num code;
  String msg;
  List<CourseEntity> data;

  CourseModel({this.code, this.msg, this.data});

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}

@JsonSerializable()
class CourseEntity {
  num subjectId;
  String subjectName;
  num gradeId;
  num courseId;
  String courseName;
  num liveState;
  String termOfValidity;
  num onlineLabel;
  num aiLabel;
  num zixueLabel;
  num courseCardCourseId;

  CourseEntity(
      {this.subjectId,
      this.subjectName,
      this.gradeId,
      this.courseId,
      this.courseName,
      this.liveState,
      this.termOfValidity,
      this.onlineLabel,
      this.aiLabel,
      this.zixueLabel,
      this.courseCardCourseId});

  factory CourseEntity.fromJson(Map<String, dynamic> json) =>
      _$CourseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CourseEntityToJson(this);
}
