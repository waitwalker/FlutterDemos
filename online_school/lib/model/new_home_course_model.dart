import 'package:json_annotation/json_annotation.dart';

part 'new_home_course_model.g.dart';

@JsonSerializable()
class NewHomeCourseModel {
  num code;
  String msg;
  List<DataEntity> data;

  NewHomeCourseModel({this.code, this.msg, this.data});

  factory NewHomeCourseModel.fromJson(Map<String, dynamic> json) =>
      _$NewHomeCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$NewHomeCourseModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num subjectId;
  String subjectName;
  List<GradesEntity> grades;

  DataEntity({this.subjectId, this.subjectName, this.grades});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class GradesEntity {
  num gradeId;
  String gradeName;

  GradesEntity({this.gradeId, this.gradeName});

  factory GradesEntity.fromJson(Map<String, dynamic> json) =>
      _$GradesEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GradesEntityToJson(this);
}
