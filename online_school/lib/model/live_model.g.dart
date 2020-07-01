// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveModel _$LiveModelFromJson(Map<String, dynamic> json) {
  return LiveModel(
      code: json['code'] as num,
      msg: json['msg'] as String,
      data: json['data'] == null
          ? null
          : DataEntity.fromJson(json['data'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LiveModelToJson(LiveModel instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

DataEntity _$DataEntityFromJson(Map<String, dynamic> json) {
  return DataEntity(
      currentPage: json['currentPage'] as num,
      pageSize: json['pageSize'] as num,
      totalCount: json['totalCount'] as num,
      totalPage: json['totalPage'] as num,
      list: (json['list'] as List)
          ?.map((e) =>
              e == null ? null : ListEntity.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      firstPage: json['firstPage'] as bool,
      lastPage: json['lastPage'] as bool);
}

Map<String, dynamic> _$DataEntityToJson(DataEntity instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'totalPage': instance.totalPage,
      'list': instance.list,
      'firstPage': instance.firstPage,
      'lastPage': instance.lastPage
    };

ListEntity _$ListEntityFromJson(Map<String, dynamic> json) {
  return ListEntity(
      subjectId: json['subjectId'] as num,
      subjectName: json['subjectName'] as String,
      courseId: json['courseId'] as num,
      courseName: json['courseName'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      speedOfProgress: json['speedOfProgress'] as String,
      nextStartTime: json['nextStartTime'] as String);
}

Map<String, dynamic> _$ListEntityToJson(ListEntity instance) =>
    <String, dynamic>{
      'subjectId': instance.subjectId,
      'subjectName': instance.subjectName,
      'courseId': instance.courseId,
      'courseName': instance.courseName,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'speedOfProgress': instance.speedOfProgress,
      'nextStartTime': instance.nextStartTime
    };
