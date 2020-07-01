import 'dart:convert';

import 'package:meta/meta.dart';

class SelfStudyRecord extends Record {
  num firstId;
  num secondId;
  num thirdId;

  SelfStudyRecord(
      {@required type,
      id,
      courseId,
      subjectId,
      gradeId,
      title,
      time,
      this.firstId,
      this.secondId,
      this.thirdId})
      : super(
          type: type ?? 2,
          id: id,
          courseId: courseId,
          subjectId: subjectId,
          gradeId: gradeId,
          title: title,
        );

  factory SelfStudyRecord.fromJson(Map<String, dynamic> json) =>
      SelfStudyRecord(
          type: json['type'],
          id: json['id'],
          time: json['time'],
          courseId: json['courseId'],
          subjectId: json['subjectId'],
          gradeId: json['gradeId'],
          title: json['title'],
          firstId: json['firstId'],
          secondId: json['secondId'],
          thirdId: json['thirdId']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'id': id,
        'time': time,
        'title': title,
        'courseId': courseId,
        'subjectId': subjectId,
        'gradeId': gradeId,
        'firstId': firstId,
        'secondId': secondId,
        'thirdId': thirdId
      };

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  void reset() {
    firstId = -1;
    secondId = -1;
    thirdId = -1;
    super.reset();
  }
}

class LiveListRecord extends Record {
  num tabIndex;

  LiveListRecord(
      {@required type,
      id,
      courseId,
      subjectId,
      gradeId,
      title,
      time,
      this.tabIndex})
      : super(
          type: type ?? 2,
          id: id,
          courseId: courseId,
          subjectId: subjectId,
          gradeId: gradeId,
          title: title,
        );

  factory LiveListRecord.fromJson(Map<String, dynamic> json) => LiveListRecord(
      type: json['type'],
      id: json['id'],
      time: json['time'],
      courseId: json['courseId'],
      subjectId: json['subjectId'],
      gradeId: json['gradeId'],
      title: json['title'],
      tabIndex: json['thirdId']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'type': type,
        'id': id,
        'time': time,
        'title': title,
        'courseId': courseId,
        'subjectId': subjectId,
        'gradeId': gradeId,
        'thirdId': tabIndex
      };

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  void reset() {
    tabIndex = -1;
    super.reset();
  }
}

class Record {
  /// 1,直播
  /// 2,自学
  num type;
  num subjectId;
  num gradeId;
  num id;
  int time;
  num courseId;
  String title;

  Record(
      {@required this.type,
      this.id = 1,
      this.title,
      this.courseId,
      this.subjectId,
      this.gradeId})
      : time = DateTime.now().millisecondsSinceEpoch;

  Record.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        title = json['title'],
        id = json['id'],
        time = json['time'],
        subjectId = json['subjectId'],
        gradeId = json['gradeId'],
        courseId = json['courseId'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'title': title,
        'courseId': courseId,
        'subjectId': subjectId,
        'gradeId': gradeId,
        'time': time
      };

  @override
  String toString() {
    return jsonEncode(this.toJson());
  }

  void reset() {
    id = -1;
  }
}
