import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

import 'package:pull_to_refresh/pull_to_refresh.dart';
class ListRefresh extends StatefulWidget {
  @override
  RefreshIndicatorDemoState createState() => RefreshIndicatorDemoState();
}

class RefreshIndicatorDemoState extends State<ListRefresh> {

  String _ipAddress = "Unknown";
  var _list = ["1", "2", "3", "4", "5"];
  var _refreshController = RefreshController(initialRefresh: true);
  var enablePullDown = true;
  var enablePullUp = true;
  List<TaskList> taskList = [];
  List<TaskList> cuTaskList = [];
  var index = 1;
  int state = 1;//1下拉刷新2，加载更多

  _getIPAddress() async {
    var i = index.toString();
    var url = 'https://school-cloud.etiantian.com/aixue33/im3.1.2?m=getTeacherTaskList.do&pageNum=' + i + '&jid=1005283672&sign=ZWY5OGY2NmQ3NThhNDJkNTk5OGU1YTliZjEwOTQyZTc&schoolId=50043&time=1615440704219&topicId=-196182294720';
    var httpClient = new HttpClient();
    String result;
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var json = await response.transform(utf8.decoder).join();
        // TaskBean data = jsonDecode(json);
        // result = data.data.taskList.first.taskName;
        Map userMap = jsonDecode(json);
        TaskBean taskBean = new TaskBean.fromJson(userMap);
        cuTaskList = taskBean.data.taskList;
        if(taskBean.result == 2){
          enablePullUp = false;
        }else{
          index+=1;
        }

        if(state == 1){
          taskList = cuTaskList;
        }else{

        }

      } else {
        result = 'Error getting task:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Err: ' + exception.toString();
    }
    if (!mounted) return;
    setState(() {

      if(state == 1){
        taskList = cuTaskList;
        _refreshController.refreshCompleted();
      }else{
        List<TaskList> cuTaskList1 = taskList;
        cuTaskList1.addAll(cuTaskList);
        cuTaskList = cuTaskList1;
        taskList = cuTaskList;
        _refreshController.loadComplete();
      }

    });
  }


  /**
   * 下拉刷新
   */
  void _onRefresh() {
    state = 1;
    return _getIPAddress();
  }

  /**
   * 上拉加载更多
   */
  void _onLoading() async{
    // monitor network fetch
    state = 2;
    return _getIPAddress();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: SmartRefresher(
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("上拉加载更多");
            } else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            } else if(mode == LoadStatus.failed){
              body = Text("加载失败");
            } else{
              body = Text("暂无更多");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (c, i) => Card(child: Center(child: Text(taskList[i].taskName))),
          itemExtent: 100.0,
          itemCount: taskList.length,
        ),
      ),
    );
  }
}

/// result : 2
/// data : {"classList":[{"classId":100146597,"className":"初二郭郭dl1班","groupList":[{"groupName":"组1","groupId":-7155637878138},{"groupName":"组2","groupId":-6871300122581},{"groupName":"组3","groupId":-5733621014034},{"groupName":"组5","groupId":-3932268418309},{"groupName":"组4","groupId":-1309240461615}]},{"classId":100146599,"className":"初二郭郭dl2班","groupList":[]},{"classId":100198956,"className":"初二guoguo班","groupList":[]}],"taskList":[{"dateHint":"剩余6天","inProcessNum":0,"topicId":-823901419281,"taskType":8,"jspUrl":"","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/9.png","topicName":"5 秋天的怀念","taskName":"Fugijg","scaleHint":"0/51","taskSubType":9,"isDone":"0","taskId":-8710892221553},{"dateHint":"剩余6天","inProcessNum":0,"topicId":-823901419281,"taskType":8,"jspUrl":"","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/9.png","topicName":"5 秋天的怀念","taskName":"Fufu","scaleHint":"0/51","taskSubType":9,"isDone":"0","taskId":-8619612186732},{"dateHint":"已结束","inProcessNum":0,"topicId":-823901419281,"taskType":2,"jspUrl":"https://school-cloud.etiantian.com/aixue33//im2.0?m=viewTopic&topicId=-2034650007822&classId=100198956&jid=1005283672&schoolId=50043&userType=2&taskId=-5425484468478","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/2.png","topicName":"5 秋天的怀念","taskName":"讨论 hggfhgh","scaleHint":"0/0","taskSubType":2,"isDone":"0","taskId":-5425484468478}]}
/// msg : "\"成功!\""

class TaskBean {
  int _result;
  Data _data;
  String _msg;

  int get result => _result;
  Data get data => _data;
  String get msg => _msg;

  TaskBean({
    int result,
    Data data,
    String msg}){
    _result = result;
    _data = data;
    _msg = msg;
  }

  TaskBean.fromJson(dynamic json) {
    _result = json["result"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
    _msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["result"] = _result;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    map["msg"] = _msg;
    return map;
  }

}

/// classList : [{"classId":100146597,"className":"初二郭郭dl1班","groupList":[{"groupName":"组1","groupId":-7155637878138},{"groupName":"组2","groupId":-6871300122581},{"groupName":"组3","groupId":-5733621014034},{"groupName":"组5","groupId":-3932268418309},{"groupName":"组4","groupId":-1309240461615}]},{"classId":100146599,"className":"初二郭郭dl2班","groupList":[]},{"classId":100198956,"className":"初二guoguo班","groupList":[]}]
/// taskList : [{"dateHint":"剩余6天","inProcessNum":0,"topicId":-823901419281,"taskType":8,"jspUrl":"","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/9.png","topicName":"5 秋天的怀念","taskName":"Fugijg","scaleHint":"0/51","taskSubType":9,"isDone":"0","taskId":-8710892221553},{"dateHint":"剩余6天","inProcessNum":0,"topicId":-823901419281,"taskType":8,"jspUrl":"","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/9.png","topicName":"5 秋天的怀念","taskName":"Fufu","scaleHint":"0/51","taskSubType":9,"isDone":"0","taskId":-8619612186732},{"dateHint":"已结束","inProcessNum":0,"topicId":-823901419281,"taskType":2,"jspUrl":"https://school-cloud.etiantian.com/aixue33//im2.0?m=viewTopic&topicId=-2034650007822&classId=100198956&jid=1005283672&schoolId=50043&userType=2&taskId=-5425484468478","taskIcon":"https://school-cloud.etiantian.com/aixue33//images/im/task/30/2.png","topicName":"5 秋天的怀念","taskName":"讨论 hggfhgh","scaleHint":"0/0","taskSubType":2,"isDone":"0","taskId":-5425484468478}]

class Data {
  List<ClassList> _classList;
  List<TaskList> _taskList;

  List<ClassList> get classList => _classList;
  List<TaskList> get taskList => _taskList;

  Data({
    List<ClassList> classList,
    List<TaskList> taskList}){
    _classList = classList;
    _taskList = taskList;
  }

  Data.fromJson(dynamic json) {
    if (json["classList"] != null) {
      _classList = [];
      json["classList"].forEach((v) {
        _classList.add(ClassList.fromJson(v));
      });
    }
    if (json["taskList"] != null) {
      _taskList = [];
      json["taskList"].forEach((v) {
        _taskList.add(TaskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_classList != null) {
      map["classList"] = _classList.map((v) => v.toJson()).toList();
    }
    if (_taskList != null) {
      map["taskList"] = _taskList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// dateHint : "剩余6天"
/// inProcessNum : 0
/// topicId : -823901419281
/// taskType : 8
/// jspUrl : ""
/// taskIcon : "https://school-cloud.etiantian.com/aixue33//images/im/task/30/9.png"
/// topicName : "5 秋天的怀念"
/// taskName : "Fugijg"
/// scaleHint : "0/51"
/// taskSubType : 9
/// isDone : "0"
/// taskId : -8710892221553

class TaskList {
  String _dateHint;
  int _inProcessNum;
  int _topicId;
  int _taskType;
  String _jspUrl;
  String _taskIcon;
  String _topicName;
  String _taskName;
  String _scaleHint;
  int _taskSubType;
  String _isDone;
  int _taskId;

  String get dateHint => _dateHint;
  int get inProcessNum => _inProcessNum;
  int get topicId => _topicId;
  int get taskType => _taskType;
  String get jspUrl => _jspUrl;
  String get taskIcon => _taskIcon;
  String get topicName => _topicName;
  String get taskName => _taskName;
  String get scaleHint => _scaleHint;
  int get taskSubType => _taskSubType;
  String get isDone => _isDone;
  int get taskId => _taskId;

  TaskList({
    String dateHint,
    int inProcessNum,
    int topicId,
    int taskType,
    String jspUrl,
    String taskIcon,
    String topicName,
    String taskName,
    String scaleHint,
    int taskSubType,
    String isDone,
    int taskId}){
    _dateHint = dateHint;
    _inProcessNum = inProcessNum;
    _topicId = topicId;
    _taskType = taskType;
    _jspUrl = jspUrl;
    _taskIcon = taskIcon;
    _topicName = topicName;
    _taskName = taskName;
    _scaleHint = scaleHint;
    _taskSubType = taskSubType;
    _isDone = isDone;
    _taskId = taskId;
  }

  TaskList.fromJson(dynamic json) {
    _dateHint = json["dateHint"];
    _inProcessNum = json["inProcessNum"];
    _topicId = json["topicId"];
    _taskType = json["taskType"];
    _jspUrl = json["jspUrl"];
    _taskIcon = json["taskIcon"];
    _topicName = json["topicName"];
    _taskName = json["taskName"];
    _scaleHint = json["scaleHint"];
    _taskSubType = json["taskSubType"];
    _isDone = json["isDone"];
    _taskId = json["taskId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["dateHint"] = _dateHint;
    map["inProcessNum"] = _inProcessNum;
    map["topicId"] = _topicId;
    map["taskType"] = _taskType;
    map["jspUrl"] = _jspUrl;
    map["taskIcon"] = _taskIcon;
    map["topicName"] = _topicName;
    map["taskName"] = _taskName;
    map["scaleHint"] = _scaleHint;
    map["taskSubType"] = _taskSubType;
    map["isDone"] = _isDone;
    map["taskId"] = _taskId;
    return map;
  }

}

/// classId : 100146597
/// className : "初二郭郭dl1班"
/// groupList : [{"groupName":"组1","groupId":-7155637878138},{"groupName":"组2","groupId":-6871300122581},{"groupName":"组3","groupId":-5733621014034},{"groupName":"组5","groupId":-3932268418309},{"groupName":"组4","groupId":-1309240461615}]

class ClassList {
  int _classId;
  String _className;
  List<GroupList> _groupList;

  int get classId => _classId;
  String get className => _className;
  List<GroupList> get groupList => _groupList;

  ClassList({
    int classId,
    String className,
    List<GroupList> groupList}){
    _classId = classId;
    _className = className;
    _groupList = groupList;
  }

  ClassList.fromJson(dynamic json) {
    _classId = json["classId"];
    _className = json["className"];
    if (json["groupList"] != null) {
      _groupList = [];
      json["groupList"].forEach((v) {
        _groupList.add(GroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["classId"] = _classId;
    map["className"] = _className;
    if (_groupList != null) {
      map["groupList"] = _groupList.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// groupName : "组1"
/// groupId : -7155637878138

class GroupList {
  String _groupName;
  int _groupId;

  String get groupName => _groupName;
  int get groupId => _groupId;

  GroupList({
    String groupName,
    int groupId}){
    _groupName = groupName;
    _groupId = groupId;
  }

  GroupList.fromJson(dynamic json) {
    _groupName = json["groupName"];
    _groupId = json["groupId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["groupName"] = _groupName;
    map["groupId"] = _groupId;
    return map;
  }

}