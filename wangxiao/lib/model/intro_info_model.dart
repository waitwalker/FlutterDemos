import 'package:json_annotation/json_annotation.dart';

part 'intro_info_model.g.dart';

@JsonSerializable()
class IntroInfoModel {
  num subjectId;
  String subject;
  String teacher;
  String avatar;
  String teacherDesc;
  String subjectDesc;
  List<ZxEntity> ai;
  List<ZxEntity> zx;
  String video;

  IntroInfoModel(
      {this.subjectId,
      this.subject,
      this.teacher,
      this.avatar,
      this.teacherDesc,
      this.subjectDesc,
      this.ai,
      this.zx,
      this.video});

  factory IntroInfoModel.fromJson(Map<String, dynamic> json) =>
      _$IntroInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$IntroInfoModelToJson(this);
}

@JsonSerializable()
class ZxEntity {
  String title;
  num type;
  num resId;
  String url;
  List<ZxEntity> list;

  ZxEntity({this.title, this.type, this.resId, this.url, this.list});

  factory ZxEntity.fromJson(Map<String, dynamic> json) =>
      _$ZxEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ZxEntityToJson(this);
}
