import 'package:json_annotation/json_annotation.dart';

part 'activity_course_model.g.dart';

@JsonSerializable()
class ActivityCourseModel {
  num code;
  String msg;
  List<DataEntity> data;

  ActivityCourseModel({this.code, this.msg, this.data});

  factory ActivityCourseModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityCourseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityCourseModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num gradeId;
  String gradeName;
  String signUpType;
  List<RegisterCourseListEntity> registerCourseList;

  DataEntity(
      {this.gradeId, this.gradeName, this.signUpType, this.registerCourseList});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class RegisterCourseListEntity {
  num activityCourseSwitchStatus;
  num registerCourseId;
  String registerCourseName;
  num subjectId;
  String subjectName;
  String registerCourseStartTime;
  String registerCourseEndTime;
  String courseContent;
  String classTime;
  num signUp;
  String source;
  ClassesEntity classes;
  num overdueStatus;
  String courseCover;
  List<CourseListEntity> courseList;
  List<TeacherListEntity> teacherList;

  RegisterCourseListEntity(
      {this.registerCourseId,
      this.registerCourseName,
      this.subjectId,
      this.subjectName,
      this.registerCourseStartTime,
      this.registerCourseEndTime,
      this.courseContent,
      this.classTime,
      this.signUp,
      this.source,
      this.classes,
      this.overdueStatus,
      this.courseCover,
      this.courseList,
      this.teacherList
      });

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
  String classQrCode;

  ClassesEntity(
      {this.classId,
      this.className,
      this.classType,
      this.qqGroup,
      this.classQrCode});

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
  num reportState;
  int resourceId;
  int isFree;

  CourseListEntity(
      {this.onlineCourseId,
      this.onlineCourseHour,
      this.onlineCourseTitle,
      this.duration,
      this.roomId,
      this.hasStudy,
      this.liveState,
      this.startTime,
      this.endTime,
      this.resourceId,
      this.isFree,
      this.reportState});

  factory CourseListEntity.fromJson(Map<String, dynamic> json) =>
      _$CourseListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CourseListEntityToJson(this);
}

@JsonSerializable()
class TeacherListEntity {
  num teacherId;
  String teacherName;
  num teacherType;
  String photoUrl;
  String content;

  TeacherListEntity(
      {this.teacherId,
      this.teacherName,
      this.teacherType,
      this.photoUrl,
      this.content});

  factory TeacherListEntity.fromJson(Map<String, dynamic> json) =>
      _$TeacherListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherListEntityToJson(this);
}
