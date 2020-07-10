import 'package:json_annotation/json_annotation.dart';

part 'live_courseware_model.g.dart';

@JsonSerializable()
class LiveCoursewareModel {
  num code;
  String msg;
  List<DataEntity> data;

  LiveCoursewareModel({this.code, this.msg, this.data});

  factory LiveCoursewareModel.fromJson(Map<String, dynamic> json) =>
      _$LiveCoursewareModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCoursewareModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num courseId;
  num resourceId;
  String name;
  num classId;
  String path;
  String fileName;
  num subjectId;
  num schoolId;
  num ownerSchoolId;
  num submitUserId;
  String submitUsername;
  num enable;
  num enableUserId;
  String enableUsername;
  String fileUrl;
  String ctime;

  DataEntity(
      {this.courseId,
      this.resourceId,
      this.name,
      this.classId,
      this.path,
      this.fileName,
      this.subjectId,
      this.schoolId,
      this.ownerSchoolId,
      this.submitUserId,
      this.submitUsername,
      this.enable,
      this.enableUserId,
      this.enableUsername,
      this.fileUrl,
      this.ctime});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
