import 'package:json_annotation/json_annotation.dart';
part 'errorbook_list_model.g.dart';

@JsonSerializable()
class ErrorbookListModel {
  num code;
  String msg;
  DataEntity data;
  ErrorbookListModel({this.code, this.msg, this.data});

  factory ErrorbookListModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorbookListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ErrorbookListModelToJson(this);
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
  @JsonKey(ignore: true)
  bool selected = false;
  num wrongPhotoId;
  num subjectId;
  String subjectName;
  num gradeId;
  String gradeName;
  String photoUrl;
  String wrongReason;
  String uploadTime;
  ListEntity(
      {this.wrongPhotoId,
      this.subjectId,
      this.subjectName,
      this.gradeId,
      this.gradeName,
      this.photoUrl,
      this.wrongReason,
      this.uploadTime});

  factory ListEntity.fromJson(Map<String, dynamic> json) =>
      _$ListEntityFromJson(json);
  Map<String, dynamic> toJson() => _$ListEntityToJson(this);
}
