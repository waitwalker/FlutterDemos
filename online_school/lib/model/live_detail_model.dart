import 'package:json_annotation/json_annotation.dart';

part 'live_detail_model.g.dart';

@JsonSerializable()
class LiveDetailModel {
  num code;
  String msg;
  DataEntity data;

  LiveDetailModel({this.code, this.msg, this.data});

  factory LiveDetailModel.fromJson(Map<String, dynamic> json) =>
      _$LiveDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveDetailModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num classId;
  String className;
  num classType;
  String qqGroup;
  String classQrCode;
  List<LiveCourseResultDTOListEntity> liveCourseResultDTOList;

  DataEntity(
      {this.classId,
      this.className,
      this.classType,
      this.qqGroup,
      this.classQrCode,
      this.liveCourseResultDTOList});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class LiveCourseResultDTOListEntity {
  String courseName;
  num onlineCourseId;
  String onlineCourseTitle;
  String roomId;
  num liveState;
  String startTime;
  String endTime;
  String teacherName;
  String teacherPhoneUrl;
  num downloadStatus;

  LiveCourseResultDTOListEntity(
      {this.courseName,
      this.onlineCourseId,
      this.onlineCourseTitle,
      this.roomId,
      this.liveState,
      this.startTime,
      this.endTime,
      this.teacherName,
      this.teacherPhoneUrl,
      this.downloadStatus});

  factory LiveCourseResultDTOListEntity.fromJson(Map<String, dynamic> json) =>
      _$LiveCourseResultDTOListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LiveCourseResultDTOListEntityToJson(this);
}
