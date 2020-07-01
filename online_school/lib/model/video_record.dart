import 'package:json_annotation/json_annotation.dart';

part 'video_record.g.dart';

@JsonSerializable()
class VideoRecord {
  num code;
  String msg;
  DataEntity data;

  VideoRecord({this.code, this.msg, this.data});

  factory VideoRecord.fromJson(Map<String, dynamic> json) =>
      _$VideoRecordFromJson(json);

  Map<String, dynamic> toJson() => _$VideoRecordToJson(this);
}

@JsonSerializable()
class DataEntity {
  num logId;

  DataEntity({this.logId});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}
