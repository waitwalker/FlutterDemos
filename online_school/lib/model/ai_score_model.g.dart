// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_score_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiScoreModel _$AiScoreModelFromJson(Map<String, dynamic> json) {
  return AiScoreModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AiScoreModelToJson(AiScoreModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      rightNum: json['rightNum'] as num,
      levelScore: json['levelScore'],
      jid: json['jid'] as num,
      taskId: json['taskId'] as num,
      completeData: json['completeData'] == null
          ? null
          : CompleteDataEntity.fromJson(
              json['completeData'] as Map<String, dynamic>));
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'rightNum': instance.rightNum,
      'levelScore': instance.levelScore,
      'jid': instance.jid,
      'taskId': instance.taskId,
      'completeData': instance.completeData
    };

CompleteDataEntity _$CompleteDataEntityFromJson(Map<String, dynamic> json) {
  return CompleteDataEntity(
      targetCourseId: json['targetCourseId'] as num,
      targetCourseName: json['targetCourseName'] as String,
      strength: json['strength'] as num,
      courseId: json['courseId'] as num,
      courseName: json['courseName'] as String,
      courseScore: json['courseScore'] as num,
      processRate: json['processRate'] as String,
      elementId: json['elementId'] as num,
      elementType: json['elementType'] as num,
      targetCourseScore: json['targetCourseScore'],
      targetCourseFinalScore: json['targetCourseFinalScore'] as num,
      improveScore: json['improveScore'],
      crossCourseNum: json['crossCourseNum'],
      currentQuesNum: json['currentQuesNum'],
      currentRightRate: json['currentRightRate'],
      totalQuesNum: json['totalQuesNum'],
      totalRightQuesNum: json['totalRightQuesNum'],
      totalRightRate: json['totalRightRate'],
      currentRightQuesNum: json['currentRightQuesNum'],
      right: json['right'] as bool,
      done: json['done'] as bool);
}

Map<String, dynamic> _$CompleteDataEntityToJson(CompleteDataEntity instance) =>
    <String, dynamic>{
      'targetCourseId': instance.targetCourseId,
      'targetCourseName': instance.targetCourseName,
      'strength': instance.strength,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'courseScore': instance.courseScore,
      'processRate': instance.processRate,
      'elementId': instance.elementId,
      'elementType': instance.elementType,
      'targetCourseScore': instance.targetCourseScore,
      'targetCourseFinalScore': instance.targetCourseFinalScore,
      'improveScore': instance.improveScore,
      'crossCourseNum': instance.crossCourseNum,
      'currentQuesNum': instance.currentQuesNum,
      'currentRightRate': instance.currentRightRate,
      'totalQuesNum': instance.totalQuesNum,
      'totalRightQuesNum': instance.totalRightQuesNum,
      'totalRightRate': instance.totalRightRate,
      'currentRightQuesNum': instance.currentRightQuesNum,
      'right': instance.right,
      'done': instance.done
    };
