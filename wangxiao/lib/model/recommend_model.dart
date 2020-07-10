import 'package:json_annotation/json_annotation.dart';

part 'recommend_model.g.dart';

@JsonSerializable()
class RecommendModel {
  num code;
  String msg;
  RecommendData data;

  RecommendModel({this.code, this.msg, this.data});

  factory RecommendModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendModelToJson(this);
}

@JsonSerializable()
class RecommendData {
  num aiActivationStatus;
  num aiRecommendId;
  num aiCourseId;
  num versionId;
  num aiSubjectId;
  String aiName;
  String aiTitle;
  String aiSubtitle;
  num zxActivationStatus;
  num zxRecommendId;
  String zxFrom;
  String resName;
  num resType;
  num courseCardId;
  String zxName;
  String zxTitle;
  String zxSubtitle;
  num liveStatus;
  num gradeId;
  num subjectId;
  String liveUrl;
  String nextLiveTime;
  String liveName;
  String liveTitle;
  String liveSubtitle;

  RecommendData(
      {this.aiActivationStatus,
      this.aiRecommendId,
      this.aiCourseId,
      this.versionId,
      this.aiSubjectId,
      this.aiName,
      this.aiTitle,
      this.aiSubtitle,
      this.zxActivationStatus,
      this.zxRecommendId,
      this.zxFrom,
      this.resName,
      this.resType,
      this.courseCardId,
      this.zxName,
      this.zxTitle,
      this.zxSubtitle,
      this.liveStatus,
      this.gradeId,
      this.subjectId,
      this.liveUrl,
      this.nextLiveTime,
      this.liveName,
      this.liveTitle,
      this.liveSubtitle});

  factory RecommendData.fromJson(Map<String, dynamic> json) =>
      _$RecommendDataFromJson(json);

  Map<String, dynamic> toJson() => _$RecommendDataToJson(this);
}
