import 'package:json_annotation/json_annotation.dart';

part 'ai_score_model.g.dart';

@JsonSerializable()
class AiScoreModel {
  num code;
  String msg;
  DataEntity data;

  AiScoreModel({this.code, this.msg, this.data});

  factory AiScoreModel.fromJson(Map<String, dynamic> json) =>
      _$AiScoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiScoreModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num rightNum;
  dynamic levelScore;
  num jid;
  num taskId;
  CompleteDataEntity completeData;

  DataEntity(
      {this.rightNum,
      this.levelScore,
      this.jid,
      this.taskId,
      this.completeData});

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class CompleteDataEntity {
  num targetCourseId;
  String targetCourseName;
  num strength;
  num courseId;
  String courseName;
  num courseScore;
  String processRate;
  num elementId;
  num elementType;
  dynamic targetCourseScore;
  num targetCourseFinalScore;
  dynamic improveScore;
  dynamic crossCourseNum;
  dynamic currentQuesNum;
  dynamic currentRightRate;
  dynamic totalQuesNum;
  dynamic totalRightQuesNum;
  dynamic totalRightRate;
  dynamic currentRightQuesNum;
  bool right;
  bool done;

  CompleteDataEntity(
      {this.targetCourseId,
      this.targetCourseName,
      this.strength,
      this.courseId,
      this.courseName,
      this.courseScore,
      this.processRate,
      this.elementId,
      this.elementType,
      this.targetCourseScore,
      this.targetCourseFinalScore,
      this.improveScore,
      this.crossCourseNum,
      this.currentQuesNum,
      this.currentRightRate,
      this.totalQuesNum,
      this.totalRightQuesNum,
      this.totalRightRate,
      this.currentRightQuesNum,
      this.right,
      this.done});

  factory CompleteDataEntity.fromJson(Map<String, dynamic> json) =>
      _$CompleteDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CompleteDataEntityToJson(this);
}
