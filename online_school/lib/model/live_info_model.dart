import 'package:json_annotation/json_annotation.dart';

part 'live_info_model.g.dart';

@JsonSerializable()
class LiveInfoModel {
  num code;
  String msg;
  LiveInfoDataEntity data;

  LiveInfoModel({this.code, this.msg, this.data});

  factory LiveInfoModel.fromJson(Map<String, dynamic> json) =>
      _$LiveInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$LiveInfoModelToJson(this);
}

@JsonSerializable()
class LiveInfoDataEntity {
  String liveUserId;
  String roomId;
  String liveName;
  String liveDesc;
  String liveStartTime;
  num liveState;
  String userId;
  String username;
  String viewToken;
  ClassInfoEntity classInfo;

  LiveInfoDataEntity(
      {this.liveUserId,
      this.roomId,
      this.liveName,
      this.liveDesc,
      this.liveStartTime,
      this.liveState,
      this.userId,
      this.username,
      this.viewToken,
      this.classInfo});

  factory LiveInfoDataEntity.fromJson(Map<String, dynamic> json) =>
      _$LiveInfoDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LiveInfoDataEntityToJson(this);
}

@JsonSerializable()
class ClassInfoEntity {
  num classId;
  String className;
  String classType;
  String qqGroup;

  ClassInfoEntity({this.classId, this.className, this.classType, this.qqGroup});

  factory ClassInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$ClassInfoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ClassInfoEntityToJson(this);
}
