import 'package:json_annotation/json_annotation.dart';

part 'resource_info_model.g.dart';

@JsonSerializable()
class ResourceInfoModel {
  num code;
  String msg;
  DataEntity data;

  ResourceInfoModel({this.code, this.msg, this.data});

  factory ResourceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$ResourceInfoModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num resouceId;
  String resourceName;
  String imageUrl;
  String introduction;
  String videoUrl;
  String downPlanUrl;
  String authorName;
  String authorIntro;
  List<PointsEntity> points;
  String path;
  String fileName;
  String literatureDownUrl;
  String literaturePreviewUrl;
  String downloadVideoUrl;

  DataEntity(
      {this.resouceId,
      this.resourceName,
      this.imageUrl,
      this.introduction,
      this.videoUrl,
      this.downPlanUrl,
      this.authorName,
      this.authorIntro,
      this.points,
      this.path,
      this.fileName,
      this.literatureDownUrl,
      this.literaturePreviewUrl,
      this.downloadVideoUrl});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class PointsEntity {
  num point;
  String title;

  PointsEntity({this.point, this.title});

  factory PointsEntity.fromJson(Map<String, dynamic> json) =>
      _$PointsEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PointsEntityToJson(this);
}
