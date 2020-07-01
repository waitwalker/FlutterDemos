import 'package:json_annotation/json_annotation.dart';

part 'material_list_model.g.dart';

@JsonSerializable()
class MaterialListModel {
  num code;
  String msg;
  List<DataEntity> data;

  MaterialListModel({this.code, this.msg, this.data});

  factory MaterialListModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialListModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialListModelToJson(this);
}

@JsonSerializable()
class DataEntity {
  num versionId;
  String versionName;
  String abbreviation;
  String gradeId;
  num subjectId;
  int currentMaterialIndex;
  bool isSelected;
  List<TeachingMaterialDTOListEntity> teachingMaterialDTOList;

  DataEntity(
      {this.versionId,
      this.versionName,
      this.abbreviation,
      this.gradeId,
      this.subjectId,
      this.teachingMaterialDTOList,
      this.currentMaterialIndex,
      this.isSelected
      });

  factory DataEntity.fromJson(Map<String, dynamic> json) =>
      _$DataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$DataEntityToJson(this);
}

@JsonSerializable()
class TeachingMaterialDTOListEntity {
  String abbreviation;
  num gradeId;
  num subjectId;
  num materialId;
  String materialName;
  num versionId;
  String versionName;
  num ifFiveFour;
  String useCount;
  String orderIndex;
  int currentMaterialIndex;
  bool isSelected;
  TeachingMaterialDTOListEntity(
      {this.abbreviation,
      this.gradeId,
      this.subjectId,
      this.materialId,
      this.materialName,
      this.versionId,
      this.versionName,
      this.ifFiveFour,
      this.useCount,
      this.orderIndex,
      this.currentMaterialIndex,
      this.isSelected
      });

  factory TeachingMaterialDTOListEntity.fromJson(Map<String, dynamic> json) =>
      _$TeachingMaterialDTOListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TeachingMaterialDTOListEntityToJson(this);
}
