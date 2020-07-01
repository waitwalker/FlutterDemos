import 'package:json_annotation/json_annotation.dart';

part 'live_model.g.dart';

@JsonSerializable()
class LiveModel {
  num code;
  String msg;
  DataEntity data;

  LiveModel({this.code, this.msg, this.data});

  factory LiveModel.fromJson(Map<String, dynamic> json) =>
      _$LiveModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num currentPage;
  num pageSize;
  num totalCount;
  num totalPage;
  List<ListEntity> list;
  bool firstPage;
  bool lastPage;

  DataEntity(
      {this.currentPage,
      this.pageSize,
      this.totalCount,
      this.totalPage,
      this.list,
      this.firstPage,
      this.lastPage});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class ListEntity {
  num subjectId;
  String subjectName;
  num courseId;
  String courseName;
  String startTime;
  String endTime;
  String speedOfProgress;
  String nextStartTime;

  ListEntity(
      {this.subjectId,
      this.subjectName,
      this.courseId,
      this.courseName,
      this.startTime,
      this.endTime,
      this.speedOfProgress,
      this.nextStartTime});

  factory ListEntity.fromJson(Map<String, dynamic> json) =>
      _$ListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ListEntityToJson(this);
}
