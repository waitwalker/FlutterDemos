import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/dao/original_dao/common_api.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/model/upload_file_model.dart';
import 'package:online_school/modules/widgets/loading_dialog.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:online_school/common/tools/grade_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:redux/redux.dart';


///
/// @name EditErrorItemPage
/// @description 编译错题,上传错题的时候
/// @author liuca
/// @date 2020-01-11
///
class EditErrorItemPage extends StatefulWidget {
  var image;

  EditErrorItemPage({Key key, @required this.image}) : super(key: key);

  _EditErrorItemPageState createState() => _EditErrorItemPageState();
}

class _EditErrorItemPageState extends State<EditErrorItemPage> {
  bool _isExpanded = false;

  String _selectedGrade = '高中三年级';
  int get _selectedGradeId =>
      grades.entries.where((kv) => kv.value == _selectedGrade).single.key;

  String _selectedSubject = '语文';
  int get _selectedSubjectId => subjectSample.entries
      .where((kv) => kv.value == _selectedSubject)
      .single
      .key;
  static List<String> reasons = [
    '运算错误',
    '思路错误',
    '概念模糊',
    '审题不清',
    '马虎粗心',
    '不会做',
    '没学过'
  ];
  String _selectedReason = '运算错误';

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: AppBar(
          title: Text(MTTLocalization.of(context).currentLocalized.error_book_page_navigator_title),
          backgroundColor: Color(MyColors.white),
          elevation: 1,
        ),
        backgroundColor: Colors.white,
        body: Container(
            height: MediaQuery.of(context).size.height * 2,
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.all(15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _topImage(),
                        _gradeArea(),
                        _subjectArea(),
                        _reasonArea(),
                        const SizedBox(height: 50),
                      ]),
                ),
                Positioned.fill(bottom: 0, child: _bottomBtn()),
              ],
            )),
      );
    });
  }

  _topImage() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 144,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          image: DecorationImage(
              image: FileImage(widget.image), fit: BoxFit.cover)),
    );
  }

  _gradeArea() {
    /// 嵌套SingleChildScrollView是为了样式，默认有阴影，嵌套之后消失
    return SingleChildScrollView(
        child: ExpansionPanelList(
      children: <ExpansionPanel>[
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(title: Text(_selectedGrade ?? '选择年级', style: TextStyle(fontSize: 15, color: Color(MyColors.title_black),)));
          },
          body: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: ListBody(
              children: <Widget>[
                ...grades.entries
                    .where((kv) => kv.key <= 6)
                    .map((kv) => _buildGradeItem(kv.value))
                    .toList(),
              ],
            ),
          ),
          isExpanded: _isExpanded,
          canTapOnHeader: true,
        ),
      ],
      expansionCallback: (panelIndex, isExpanded) {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      animationDuration: kThemeAnimationDuration,
    ));
  }

  Widget _buildGradeItem(String value) => InkWell(
      child: Container(
        height: 40,
        alignment: Alignment.center,
        child: Text(value, style: textStyleSub333),
      ),
      onTap: () {
        setState(() {
          _selectedGrade = value;
          _isExpanded = !_isExpanded;
        });
      });

  _subjectArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('学科'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: <Widget>[
            ...subjectSample.entries
                .where((kv) => kv.key > 0 && kv.key < 10)
                .map((kv) => _buildSubjectItem(kv.value,
                    selected: _selectedSubject == kv.value))
                .toList()
          ],
        ),
        const SizedBox(height: 15)
      ],
    );
  }

  _reasonArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('错误原因'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: <Widget>[
            ...reasons
                .map((kv) => _buildSubjectItem(kv,
                    selected: _selectedReason == kv, fromReason: true))
                .toList()
          ],
        )
      ],
    );
  }

  _bottomBtn() {
    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
      Expanded(
          child: InkWell(
              child: Container(
                  height: 49,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(MyColors.shadow),
                          offset: Offset(0, 2),
                          blurRadius: 10.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: Text('取消', style: textStyle13TitleBlackMid)),
              onTap: () {
                Navigator.of(context).pop();
              }),
          flex: 1),
      Expanded(
          child: InkWell(
              child: Container(
                  height: 49,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: [
                      BoxShadow(
                          color: Color(MyColors.shadow),
                          offset: Offset(0, 2),
                          blurRadius: 10.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: Text('确定', style: textStyle13WhiteMid)),
              onTap: () {
                _selectedGrade == null
                    ? toast('请选择年级')
                    : _selectedSubject == null
                        ? toast('请选择学科')
                        : _selectedReason == null ? toast('请选择原因') : submit();
              }),
          flex: 1),
    ]);
  }

  submit() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: LoadingDialog(text: '正在上传'),
    );
    ResponseData uploadImage =
        await CommonServiceDao.uploadImage(image: widget.image.path);
    UploadFileModel model = uploadImage.model;
    if (model != null &&
        model.result == 1 &&
        model.data != null &&
        model.data.filePath != null) {
      var filePath = model.data.filePath;
      ResponseData saveErrorBook = await CourseDaoManager.saveErrorBook(
          gradeId: _selectedGradeId,
          subjectId: _selectedSubjectId,
          wrongReason: _selectedReason,
          photoUrl: filePath);
      /// 取消加载圈
      Navigator.of(context).pop();
      if (saveErrorBook.result) {
        showDialog(
          context: context,
          barrierDismissible: false,
          child: UploadCompleteDialog(
              text: '上传成功！',
              onCancel: () {
                SingletonManager.sharedInstance.errorBookCameraState = 1;
                Navigator.of(context).pop(); /// dismiss dialog
                Navigator.of(context).pop(true); /// pop current page
              },
              onContinue: () {
                SingletonManager.sharedInstance.errorBookCameraState = 2;
                Navigator.of(context).pop();
                Navigator.of(context).pop(false);
              }),
        );
        // Navigator.of(context).pop(true);
      }
    }
  }

  toast(msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER);
  }

  _buildSubjectItem(String value, {bool selected = false, fromReason = false}) {
    return InkWell(
        child: Container(
          child: Text(value,
              style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : Color(MyColors.title_black),
              )),
          width: 100,
          height: 31,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(19.0),
            border: Border.all(color: selected ? Colors.transparent : Color(0xFFC9C9C9)),
          ),
        ),
        onTap: () {
          setState(() {
            if (fromReason) {
              _selectedReason = value;
            } else {
              _selectedSubject = value;
            }
          });
        });
  }
}
