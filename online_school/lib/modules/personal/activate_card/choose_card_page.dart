import 'dart:collection';
import 'package:online_school/model/card_list_model.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/modules/widgets/text_tag.dart';
import 'package:flutter/material.dart';


///
/// @name ChooseCardPage
/// @description 选择卡片
/// @author liuca
/// @date 2020-01-11
///
class ChooseCardPage extends StatefulWidget {
  List<CourseInfoResultDTOSEntity> lists;
  int limit;

  var cardNumber;

  var cardPassword;

  ChooseCardPage(this.lists, this.cardNumber, this.cardPassword, {this.limit});

  @override
  _ChooseCardPageState createState() => _ChooseCardPageState();
}

class _ChooseCardPageState extends State<ChooseCardPage> {
  var _scrollController;

  var agree = false;

  int _checkedIndex = 0;

  var subjects = {
    0:'全科',
    1: '语文',
    2: '数学',
    3: '英语',
    4: '物理',
    5: '化学',
    6: '历史',
    7: '生物',
    8: '地理',
    9: '政治',
    10: '科学',
  };
  var grades = {
    1: '高中三年级',
    2: '高中二年级',
    3: '高中一年级',
    4: '初中三年级',
    5: '初中二年级',
    6: '初中一年级',
    7: '小学六年级',
    8: '五四制初四',
    9: '小学四年级',
    10: '小学三年级',
    11: '小学二年级',
    12: '小学一年级'
  };

  var _grade;
  var _subject;

  bool get ready => _grade != null && _subject != null;

  List get subject => widget.lists
      .map((i) => i.subjectId)
      .toSet()
      .map((i) => {i: subjects[i]})
      .toList();

  List get grade => widget.lists
      .where((i) => i.subjectId == _subject)
      .map((i) => i.gradeId)
      .toSet()
      .map((i) => {i: grades[i]})
      .toList();

  List<CourseInfoResultDTOSEntity> get lists => widget.lists
      .where((c) => c.subjectId == _subject && c.gradeId == _grade)
      .toList();

  bool get hasChoice => (lists?.length ?? 0) > 0;

  int get limit => widget.limit ?? double.infinity.toInt();
  int checkedNum = 0;
  HashMap<int, bool> checked = HashMap<int, bool>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.white,
        title: Text('选课'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Text('选择学科和年级，为您推荐更适合的课程'),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: DropdownButton(
                  items: subject.map((i) => DropdownMenuItem(
                          child: Text(i.entries.first.value ?? '未知'),
                          value: i.entries.first.key))
                      .toList(),
                  value: _subject,
                  hint: Text('选择学科', style: textStyleNormal),
                  isExpanded: true,
                  onChanged: (subjectId) {
                    _subject = subjectId;
                    _grade = null;
                    setState(() {});
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                child: DropdownButton(
                  items: grade
                          .map((i) => DropdownMenuItem(
                              child: Text(i.entries.first.value ?? '未知'),
                              value: i.entries.first.key))
                          .toList() ??
                      [],
                  value: _grade,
                  hint: Text('选择年级', style: textStyleNormal),
                  isExpanded: true,
                  onChanged: (gradeId) {
                    _grade = gradeId;
                    setState(() {});
                  },
                ),
              ),
              if (hasChoice)
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('请在下列课程中选择 一门激活'),
                ),
              if (hasChoice)
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: buildItem,
                    itemCount: lists.length,
                    // physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.only(top: 10, bottom: 100),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          disabledColor: Color(MyColors.ccc),
          disabledElevation: 0,
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Text(
            "确定激活",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          color: Color(MyColors.primaryValue),
          onPressed: hasChoice ? _onPressed : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget buildItem(BuildContext context, int index) {
    var course = lists.elementAt(index);
    return InkWell(
      child: Card(
        // margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextTag(
                  text: subjects.entries
                      .where((s) => s.key == course.subjectId)
                      .first
                      .value),
              Padding(
                padding: EdgeInsets.only(left: 10),
              ),
              Expanded(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    course.courseName,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: textStyleLarge,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(),
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: _checkedIndex == index
                            ? Icon(
                                MyIcons.CHECKED,
                                size: 15.0,
                                color: Color(MyColors.primaryValue),
                              )
                            : Icon(
                                MyIcons.UNCHECKED,
                                size: 15.0,
                                color: Color(MyColors.ccc),
                              ),
                      ),
                    ],
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
      onTap: () => _onTap(index),
    );
  }

  _onTap(int index) {
    _checkedIndex = index;
    setState(() {});
  }

  Future _onPressed() async {
    Navigator.pop(context, lists.sublist(_checkedIndex, _checkedIndex + 1));
  }

  List<DropdownMenuItem> getListData() {
    List<DropdownMenuItem> items = List();
    DropdownMenuItem dropdownMenuItem1 = DropdownMenuItem(
      child: Text('小学一年级'),
      value: 12,
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2 = DropdownMenuItem(
      child: Text('小学二年级'),
      value: 11,
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3 = DropdownMenuItem(
      child: Text('小学三年级'),
      value: 10,
    );
    items.add(dropdownMenuItem3);
    DropdownMenuItem dropdownMenuItem4 = DropdownMenuItem(
      child: Text('小学四年级'),
      value: 9,
    );
    items.add(dropdownMenuItem4);
    DropdownMenuItem dropdownMenuItem5 = DropdownMenuItem(
      child: Text('小学五年级'),
      value: 8,
    );
    items.add(dropdownMenuItem5);
    DropdownMenuItem dropdownMenuItem6 = DropdownMenuItem(
      child: Text('小学六年级'),
      value: 7,
    );
    items.add(dropdownMenuItem6);
    DropdownMenuItem dropdownMenuItem7 = DropdownMenuItem(
      child: Text('初中一年级'),
      value: 6,
    );
    items.add(dropdownMenuItem7);
    DropdownMenuItem dropdownMenuItem8 = DropdownMenuItem(
      child: Text('初中二年级'),
      value: 5,
    );
    items.add(dropdownMenuItem8);
    DropdownMenuItem dropdownMenuItem9 = DropdownMenuItem(
      child: Text('初中三年级'),
      value: 4,
    );
    items.add(dropdownMenuItem9);
    DropdownMenuItem dropdownMenuItem10 = DropdownMenuItem(
      child: Text('高中一年级'),
      value: 3,
    );
    items.add(dropdownMenuItem10);
    DropdownMenuItem dropdownMenuItem11 = DropdownMenuItem(
      child: Text('高中二年级'),
      value: 2,
    );
    items.add(dropdownMenuItem11);
    DropdownMenuItem dropdownMenuItem12 = DropdownMenuItem(
      child: Text('高中三年级'),
      value: 1,
    );
    items.add(dropdownMenuItem12);
    return items;
  }
}
