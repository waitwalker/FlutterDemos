import 'package:json_annotation/json_annotation.dart';

part 'course_list.g.dart';

@JsonSerializable()
class CourseList {
  num code;
  String msg;
  List<DataEntity> data;

  CourseList({this.code, this.msg, this.data});

  factory CourseList.fromJson(Map<String, dynamic> json) =>
      _$CourseListFromJson(json);

  Map<String, dynamic> toJson() => _$CourseListToJson(this);

// added by hand
  get courseNum => this.data == null
      ? 0
      : this.data.expand((l) => l.registerCourseList).toList().length;

  get courses => this.data?.expand((d) => d.registerCourseList)?.toList();
}

@JsonSerializable()
class DataEntity {
  num gradeId;
  String gradeName;
  num signUpType;
  List<RegisterCourseListEntity> registerCourseList;

  DataEntity(
      {this.gradeId, this.gradeName, this.signUpType, this.registerCourseList});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class RegisterCourseListEntity {
  num registerCourseId;
  String registerCourseName;
  num subjectId;
  String registerCourseStartTime;
  String registerCourseEndTime;
  String classTime;
  num signUp;
  num source;
  ClassesEntity classes;
  List<CourseListEntity> courseList;

  RegisterCourseListEntity(
      {this.registerCourseId,
      this.registerCourseName,
      this.subjectId,
      this.registerCourseStartTime,
      this.registerCourseEndTime,
      this.classTime,
      this.signUp,
      this.source,
      this.classes,
      this.courseList});

  factory RegisterCourseListEntity.fromJson(Map<String, dynamic> json) =>
      _$RegisterCourseListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterCourseListEntityToJson(this);
}

@JsonSerializable()
class ClassesEntity {
  num classId;
  String className;
  num classType;
  String qqGroup;

  ClassesEntity({this.classId, this.className, this.classType, this.qqGroup});

  factory ClassesEntity.fromJson(Map<String, dynamic> json) =>
      _$ClassesEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClassesEntityToJson(this);
}

@JsonSerializable()
class CourseListEntity {
  num onlineCourseId;
  String onlineCourseHour;
  String onlineCourseTitle;
  String duration;
  String roomId;
  num hasStudy;
  num liveState;
  String startTime;
  String endTime;

  // added by hand
  RegisterCourseListEntity parent;

  CourseListEntity(
      {this.onlineCourseId,
      this.onlineCourseHour,
      this.onlineCourseTitle,
      this.duration,
      this.roomId,
      this.hasStudy,
      this.liveState,
      this.startTime,
      this.endTime});

  factory CourseListEntity.fromJson(Map<String, dynamic> json) =>
      _$CourseListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CourseListEntityToJson(this);
}
