import 'dart:io';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/dao/original_dao/card_dao.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/model/activate_model.dart';
import 'package:online_school/model/card_list_model.dart';
import 'package:online_school/modules/personal/activate_card/choose_card_page.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import 'activate_success_page.dart';
import 'package:redux/redux.dart';

///
/// @name ActivateCardPage
/// @description 激活卡
/// @author liuca
/// @date 2020-01-11
///
class ActivateCardPage extends StatefulWidget {
  @override
  _ActivateCardPageState createState() => _ActivateCardPageState();
}

class _ActivateCardPageState extends State<ActivateCardPage> {
  TextEditingController _cardPasswordController;

  TextEditingController _cardNumberController;

  final subject = new PublishSubject();

  @override
  void initState() {
    _cardNumberController = TextEditingController(text: '');
    _cardPasswordController = TextEditingController(text: '');
    super.initState();

    // 防止激活重复点击
    subject.stream.throttle(Duration(seconds: 1)).listen((_) => _onPressed());
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: AppBar(
          elevation: 1.0,
          backgroundColor: Colors.white,
          title: Text(MTTLocalization.of(context).currentLocalized.apply_for_course_card_page_navigator_title),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(MTTLocalization.of(context).currentLocalized.apply_for_course_card_page_content),
                TextField(
                  cursorWidth: 1,
                  cursorColor: Color(MyColors.primaryLightValue),
                  style: textStyleNormal,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.line),
                            width: 1,
                            style: BorderStyle.solid)),
                    labelText: MTTLocalization.of(context).currentLocalized.apply_for_course_card_page_card_num,
                  ),
                  controller: _cardNumberController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 18),
                ),
                TextField(
                  cursorWidth: 1,
                  cursorColor: Color(MyColors.primaryLightValue),
                  style: textStyleNormal,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(MyColors.line),
                            width: 1,
                            style: BorderStyle.solid)),
                    labelText: MTTLocalization.of(context).currentLocalized.apply_for_course_card_page_commit,
                  ),
                  controller: _cardPasswordController,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 34),
                ),
                RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))),
                  disabledColor: Color(MyColors.ccc),
                  disabledElevation: 0,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    MTTLocalization.of(context).currentLocalized.apply_for_course_card_page_commit,
                    style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal,),
                  ),
                  color: Color(MyColors.primaryValue),
                  onPressed: () => subject.add(1),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _onPressed() async {
    // Observable.just(1).throttle(Duration(seconds: 1));
    var result = await CardDao.getCards(
        _cardNumberController.text.trim(), _cardPasswordController.text);
    var model = result.model as CardListModel;
    if (result.result &&
        model != null &&
        model.code == 1 &&
        model.data != null &&
        model.data.courseInfoResultDTOS != null &&
        model.data.courseInfoResultDTOS.length > 0) {
      var data = model.data;
      if (data.courseInfoResultDTOS.length == data.activationNumber) {
        // 全部激活，无须选择
        _onActivate(data.courseInfoResultDTOS);
      } else {
        Navigator.of(context)
            .push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (BuildContext context) => ChooseCardPage(
                    model.data.courseInfoResultDTOS,
                    _cardNumberController.text.trim(),
                    _cardPasswordController.text,
                    limit: model.data.activationNumber)))
            .then((list) => _onActivate(list));
      }
    } else {
      Fluttertoast.showToast(msg: model.msg);
      // Navigator.pop(context, false);
    }
  }

  Future _onActivate(List<CourseInfoResultDTOSEntity> list) async {
    var courseIds = list.map((c) => c.courseId).toList();
    var activate = await CardDao.activate(
        _cardNumberController.text.trim(), _cardPasswordController.text, courseIds);
    var model = activate.model as ActivateModel;
    if (activate.result && model != null && model.code == 1) {
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: true,
          builder: (BuildContext context) => ActivateSuccessPage()));
    } else if (!activate.result) {
      Fluttertoast.showToast(msg: Platform.isIOS ? '申请失败' : "激活失败");
    } else {
      Fluttertoast.showToast(msg: model.msg);
      Navigator.pop(context, false);
    }
  }
}
