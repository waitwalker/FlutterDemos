// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_work_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetWorkInfo _$GetWorkInfoFromJson(Map<String, dynamic> json) {
  return GetWorkInfo(
      result: json['result'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataModel.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$GetWorkInfoToJson(GetWorkInfo instance) =>
    <String, dynamic>{
      'result': instance.result,
      'msg': instance.msg,
      'data': instance.data
    };

DataModel _$DataModelFromJson(Map<String, dynamic> json) {
  return DataModel(
      classTypeList: (json['classTypeList'] as List)
          ?.map((e) => e == null
              ? null
              : ClassTypeListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$DataModelToJson(DataModel instance) =>
    <String, dynamic>{'classTypeList': instance.classTypeList};

ClassTypeListEntity _$ClassTypeListEntityFromJson(Map<String, dynamic> json) {
  return ClassTypeListEntity(
      classType: json['classType'] as num,
      joinState: json['joinState'] as num,
      subjectList: (json['subjectList'] as List)
          ?.map((e) => e == null
              ? null
              : SubjectListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ClassTypeListEntityToJson(
        ClassTypeListEntity instance) =>
    <String, dynamic>{
      'classType': instance.classType,
      'joinState': instance.joinState,
      'subjectList': instance.subjectList
    };

SubjectListEntity _$SubjectListEntityFromJson(Map<String, dynamic> json) {
  return SubjectListEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      subjectIcon: json['subjectIcon'] as String,
      allTask: json['allTask'] as num,
      unfinishedNum: json['unfinishedNum'] as num,
      classHint: json['classHint'] as String,
      dateHint: json['dateHint'] as String,
      asAllCount: json['asAllCount'] as num,
      asUnfinishedCount: json['asUnfinishedCount'] as num,
      asUncorrectionCount: json['asUncorrectionCount'] as num);
}

Map<String, dynamic> _$SubjectListEntityToJson(SubjectListEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'subjectIcon': instance.subjectIcon,
      'allTask': instance.allTask,
      'unfinishedNum': instance.unfinishedNum,
      'classHint': instance.classHint,
      'dateHint': instance.dateHint,
      'asAllCount': instance.asAllCount,
      'asUnfinishedCount': instance.asUnfinishedCount,
      'asUncorrectionCount': instance.asUncorrectionCount
    };
