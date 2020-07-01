
///
/// @name LiveMaterialModel
/// @description 资料包列表
/// @author liuca
/// @date 2020-01-11
///
class LiveMaterialModel {
  int code;
  String msg;
  List<Data> data;

  LiveMaterialModel({this.code, this.msg, this.data});

  LiveMaterialModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int courseId;
  int resourceId;
  String name;
  int classId;
  String path;
  String fileName;
  int subjectId;
  int schoolId;
  int ownerSchoolId;
  int submitUserId;
  String submitUsername;
  int enable;
  int enableUserId;
  String enableUsername;
  String fileUrl;
  String ctime;

  Data(
      {this.courseId,
        this.resourceId,
        this.name,
        this.classId,
        this.path,
        this.fileName,
        this.subjectId,
        this.schoolId,
        this.ownerSchoolId,
        this.submitUserId,
        this.submitUsername,
        this.enable,
        this.enableUserId,
        this.enableUsername,
        this.fileUrl,
        this.ctime});

  Data.fromJson(Map<String, dynamic> json) {
    courseId = json['courseId'];
    resourceId = json['resourceId'];
    name = json['name'];
    classId = json['classId'];
    path = json['path'];
    fileName = json['fileName'];
    subjectId = json['subjectId'];
    schoolId = json['schoolId'];
    ownerSchoolId = json['ownerSchoolId'];
    submitUserId = json['submitUserId'];
    submitUsername = json['submitUsername'];
    enable = json['enable'];
    enableUserId = json['enableUserId'];
    enableUsername = json['enableUsername'];
    fileUrl = json['fileUrl'];
    ctime = json['ctime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    data['resourceId'] = this.resourceId;
    data['name'] = this.name;
    data['classId'] = this.classId;
    data['path'] = this.path;
    data['fileName'] = this.fileName;
    data['subjectId'] = this.subjectId;
    data['schoolId'] = this.schoolId;
    data['ownerSchoolId'] = this.ownerSchoolId;
    data['submitUserId'] = this.submitUserId;
    data['submitUsername'] = this.submitUsername;
    data['enable'] = this.enable;
    data['enableUserId'] = this.enableUserId;
    data['enableUsername'] = this.enableUsername;
    data['fileUrl'] = this.fileUrl;
    data['ctime'] = this.ctime;
    return data;
  }
}