import 'package:json_annotation/json_annotation.dart';

part 'video_url_model.g.dart';

@JsonSerializable()
class VideoUrlModel {
  num code;
  String msg;
  LiveDataEntity data;

  VideoUrlModel({this.code, this.msg, this.data});

  factory VideoUrlModel.fromJson(Map<String, dynamic> json) =>
      _$VideoUrlModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoUrlModelToJson(this);
}

@JsonSerializable()
class LiveDataEntity {
  num onlineCourseId;
  num resourceId;
  String onlineCourseName;
  String videoUrl;
  String playVideoUrl;
  String imageUrl;

  LiveDataEntity(
      {this.onlineCourseId,
      this.resourceId,
      this.onlineCourseName,
      this.videoUrl,
      this.playVideoUrl,
      this.imageUrl});

  factory LiveDataEntity.fromJson(Map<String, dynamic> json) =>
      _$LiveDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LiveDataEntityToJson(this);
}
