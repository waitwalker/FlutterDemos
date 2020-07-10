import 'package:json_annotation/json_annotation.dart';

part 'error_book_model.g.dart';

@JsonSerializable()
class ErrorBookModel {
  num code;
  String msg;
  List<DataEntity> data;

  ErrorBookModel({this.code, this.msg, this.data});

  factory ErrorBookModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorBookModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num subjectId;
  String subjectName;
  num cnt;

  DataEntity({this.subjectId, this.subjectName, this.cnt});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
