class CollegeEntranceModel {
  int code;
  String msg;
  List<Data> data;

  CollegeEntranceModel({this.code, this.msg, this.data});

  CollegeEntranceModel.fromJson(Map<String, dynamic> json) {
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
  bool isSelected = false;
  int subjectId;
  String subjectName;
  List<RegisterCourseList> registerCourseList;

  Data({this.subjectId, this.subjectName, this.registerCourseList});

  Data.fromJson(Map<String, dynamic> json) {
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    if (json['registerCourseList'] != null) {
      registerCourseList = new List<RegisterCourseList>();
      json['registerCourseList'].forEach((v) {
        registerCourseList.add(new RegisterCourseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    if (this.registerCourseList != null) {
      data['registerCourseList'] =
          this.registerCourseList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RegisterCourseList {
  bool isSelected = false;
  int registerCourseId;
  String registerCourseName;
  Null subjectId;
  Null subjectName;
  Null registerCourseStartTime;
  Null registerCourseEndTime;
  String courseContent;
  String classTime;
  int signUp;
  Null source;
  Null classes;
  Null overdueStatus;
  String courseCover;
  List<CourseList> courseList;
  List<TeacherList> teacherList;
  Null activityCourseSwitchStatus;
  Null tags;

  RegisterCourseList(
      {this.registerCourseId,
        this.registerCourseName,
        this.subjectId,
        this.subjectName,
        this.registerCourseStartTime,
        this.registerCourseEndTime,
        this.courseContent,
        this.classTime,
        this.signUp,
        this.source,
        this.classes,
        this.overdueStatus,
        this.courseCover,
        this.courseList,
        this.teacherList,
        this.activityCourseSwitchStatus,
        this.tags});

  RegisterCourseList.fromJson(Map<String, dynamic> json) {
    registerCourseId = json['registerCourseId'];
    registerCourseName = json['registerCourseName'];
    subjectId = json['subjectId'];
    subjectName = json['subjectName'];
    registerCourseStartTime = json['registerCourseStartTime'];
    registerCourseEndTime = json['registerCourseEndTime'];
    courseContent = json['courseContent'];
    classTime = json['classTime'];
    signUp = json['signUp'];
    source = json['source'];
    classes = json['classes'];
    overdueStatus = json['overdueStatus'];
    courseCover = json['courseCover'];
    if (json['courseList'] != null) {
      courseList = new List<CourseList>();
      json['courseList'].forEach((v) {
        courseList.add(new CourseList.fromJson(v));
      });
    }
    if (json['teacherList'] != null) {
      teacherList = new List<TeacherList>();
      json['teacherList'].forEach((v) {
        teacherList.add(new TeacherList.fromJson(v));
      });
    }
    activityCourseSwitchStatus = json['activityCourseSwitchStatus'];
    tags = json['tags'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['registerCourseId'] = this.registerCourseId;
    data['registerCourseName'] = this.registerCourseName;
    data['subjectId'] = this.subjectId;
    data['subjectName'] = this.subjectName;
    data['registerCourseStartTime'] = this.registerCourseStartTime;
    data['registerCourseEndTime'] = this.registerCourseEndTime;
    data['courseContent'] = this.courseContent;
    data['classTime'] = this.classTime;
    data['signUp'] = this.signUp;
    data['source'] = this.source;
    data['classes'] = this.classes;
    data['overdueStatus'] = this.overdueStatus;
    data['courseCover'] = this.courseCover;
    if (this.courseList != null) {
      data['courseList'] = this.courseList.map((v) => v.toJson()).toList();
    }
    if (this.teacherList != null) {
      data['teacherList'] = this.teacherList.map((v) => v.toJson()).toList();
    }
    data['activityCourseSwitchStatus'] = this.activityCourseSwitchStatus;
    data['tags'] = this.tags;
    return data;
  }
}

class CourseList {
  int onlineCourseId;
  String onlineCourseTitle;
  int resourceId;
  int isFree;
  int hasStudy;

  CourseList(
      {this.onlineCourseId,
        this.onlineCourseTitle,
        this.resourceId,
        this.isFree,
        this.hasStudy});

  CourseList.fromJson(Map<String, dynamic> json) {
    onlineCourseId = json['onlineCourseId'];
    onlineCourseTitle = json['onlineCourseTitle'];
    resourceId = json['resourceId'];
    isFree = json['isFree'];
    hasStudy = json['hasStudy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['onlineCourseId'] = this.onlineCourseId;
    data['onlineCourseTitle'] = this.onlineCourseTitle;
    data['resourceId'] = this.resourceId;
    data['isFree'] = this.isFree;
    data['hasStudy'] = this.hasStudy;
    return data;
  }
}

class TeacherList {
  int teacherId;
  String teacherName;
  int teacherType;
  String photoUrl;
  String content;
  Null adPic;

  TeacherList(
      {this.teacherId,
        this.teacherName,
        this.teacherType,
        this.photoUrl,
        this.content,
        this.adPic});

  TeacherList.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacherId'];
    teacherName = json['teacherName'];
    teacherType = json['teacherType'];
    photoUrl = json['photoUrl'];
    content = json['content'];
    adPic = json['adPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teacherId'] = this.teacherId;
    data['teacherName'] = this.teacherName;
    data['teacherType'] = this.teacherType;
    data['photoUrl'] = this.photoUrl;
    data['content'] = this.content;
    data['adPic'] = this.adPic;
    return data;
  }
}