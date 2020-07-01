import 'package:json_annotation/json_annotation.dart';

part 'material_model.g.dart';

@JsonSerializable()
class MaterialModel {
  num code;
  String msg;
  MaterialDataEntity data;

  MaterialModel({this.code, this.msg, this.data});

  factory MaterialModel.fromJson(Map<String, dynamic> json) =>
      _$MaterialModelFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialModelToJson(this);
}

@JsonSerializable()
class MaterialDataEntity {
  num defVersionId;
  String defVersionName;
  String defAbbreviation;
  num defMaterialId;
  String defMaterialName;
  num gradeId;
  num subjectId;

  MaterialDataEntity(
      {this.defVersionId,
      this.defVersionName,
      this.defAbbreviation,
      this.defMaterialId,
      this.defMaterialName,
      this.gradeId,
      this.subjectId});

  factory MaterialDataEntity.fromJson(Map<String, dynamic> json) =>
      _$MaterialDataEntityFromJson(json);

  Map<String, dynamic> toJson() => _$MaterialDataEntityToJson(this);
}
