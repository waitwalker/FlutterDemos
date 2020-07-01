import 'package:json_annotation/json_annotation.dart';

part 'video_source_model.g.dart';

@JsonSerializable()
class VideoSourceModel {
  num code;
  String msg;
  List<VideoSource> data;

  VideoSourceModel({this.code, this.msg, this.data});

  factory VideoSourceModel.fromJson(Map<String, dynamic> json) =>
      _$VideoSourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoSourceModelToJson(this);
}

@JsonSerializable()
class VideoSource {
  num lineId;
  String lineName;
  String lineUrl;

  VideoSource({this.lineId, this.lineName, this.lineUrl});

  factory VideoSource.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);

  // add by hand
  bool selected = false;
}
