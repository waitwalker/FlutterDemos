import 'package:json_annotation/json_annotation.dart';

part 'get_work_info.g.dart';

/**
 * auto generate by json2bean
 * Author zhuoweixian
 */
@JsonSerializable()
class GetWorkInfo {
  GetWorkInfo({
    this.result,
    this.msg,
    this.data,
  });

  num result;
  String msg;
  DataModel data;

  factory GetWorkInfo.fromJson(Map<String, dynamic> json) =>
      _$GetWorkInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GetWorkInfoToJson(this);
}

@JsonSerializable()
class DataModel {
  DataModel({
    this.classTypeList,
  });

  List<ClassTypeListEntity> classTypeList;

  factory DataModel.fromJson(Map<String, dynamic> json) =>
      _$DataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataModelToJson(this);
}

@JsonSerializable()
class ClassTypeListEntity {
  ClassTypeListEntity({
    this.classType,
    this.joinState,
    this.subjectList,
  });

  num classType;
  num joinState;
  List<SubjectListEntity> subjectList;

  factory ClassTypeListEntity.fromJson(Map<String, dynamic> json) =>
      _$ClassTypeListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClassTypeListEntityToJson(this);
}

@JsonSerializable()
class SubjectListEntity {
  SubjectListEntity({
    this.subjectId,
    this.subjectName,
    this.subjectIcon,
    this.allTask,
    this.unfinishedNum,
    this.classHint,
    this.dateHint,
    this.asAllCount,
    this.asUnfinishedCount,
    this.asUncorrectionCount,
  });

  num subjectId;
  String subjectName;
  String subjectIcon;
  num allTask;
  num unfinishedNum;
  String classHint;
  String dateHint;
  num asAllCount;
  num asUnfinishedCount;
  num asUncorrectionCount;

  factory SubjectListEntity.fromJson(Map<String, dynamic> json) =>
      _$SubjectListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectListEntityToJson(this);
}
