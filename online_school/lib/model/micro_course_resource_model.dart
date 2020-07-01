import 'package:json_annotation/json_annotation.dart';

part 'micro_course_resource_model.g.dart';

@JsonSerializable()
class MicroCourseResourceModel {
  num code;
  String msg;
  MicroCourseResourceDataEntity data;

  MicroCourseResourceModel({this.code, this.msg, this.data});

  factory MicroCourseResourceModel.fromJson(Map<String, dynamic> json) =>
      _$MicroCourseResourceModelFromJson(json);

  Map<String, dynamic> toJson() => _$MicroCourseResourceModelToJson(this);
}

@JsonSerializable()
class MicroCourseResourceDataEntity {
  num resouceId;
  String resourceName;
  String imageUrl;
  String videoUrl;
  List<PlanUrlListEntity> planUrlList;
  String path;

  MicroCourseResourceDataEntity(
      {this.resouceId,
      this.resourceName,
      this.imageUrl,
      this.videoUrl,
      this.planUrlList,
      this.path});

  factory MicroCourseResourceDataEntity.fromJson(Map<String, dynamic> json) =>
      _$MicroCourseResourceDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MicroCourseResourceDataEntityToJson(this);
}

@JsonSerializable()
class PlanUrlListEntity {
  String previewPlanUrl;
  String dowPlanUrl;

  PlanUrlListEntity({this.previewPlanUrl, this.dowPlanUrl});

  factory PlanUrlListEntity.fromJson(Map<String, dynamic> json) =>
      _$PlanUrlListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PlanUrlListEntityToJson(this);
}
