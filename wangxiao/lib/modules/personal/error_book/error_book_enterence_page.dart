import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';
import 'error_book_subject_list_page.dart';
import 'package:redux/redux.dart';


///
/// @name ErrorBookEnterencePage
/// @description 错题本入口  里面包括:1)系统错题;2)数校错题;3)上传错题
/// @author liuca
/// @date 2020-01-11
///
class ErrorBookEnterencePage extends StatefulWidget {
  bool fromShuXiao = false;
  ErrorBookEnterencePage({this.fromShuXiao = false});

  @override
  State<StatefulWidget> createState() {
    return _ErrorBookEnterencePageState();
  }
}

class _ErrorBookEnterencePageState extends State<ErrorBookEnterencePage> {
  var _modules;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    _modules = [
      {
        'title': MTTLocalization.of(context).currentLocalized.error_book_page_system_error_item,
        'pic': 'static/images/errorbook_xitongcuoti.png',
        'color': 0xFF8C8FF6,
      },
      if (widget.fromShuXiao)
        {
          'title': MTTLocalization.of(context).currentLocalized.error_book_page_digital_campus_error_item,
          'pic': 'static/images/errorbook_xiaoyuancuoti.png',
          'color': 0xFF64D2FD
        }, // 数校专属
      {
        'title': MTTLocalization.of(context).currentLocalized.error_book_page_upload_error_item,
        'pic': 'static/images/errorbook_shangchuancuoti.png',
        'color': 0xFF5A7CED,
      }
    ];
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: AppBar(
          title: Text(MTTLocalization.of(context).currentLocalized.error_book_page_navigator_title),
          elevation: 1.0,
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
        ),
        backgroundColor: Color(MyColors.background),
        body: Center(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
              child: _buildList()),
        ),
      );
    });
  }

  _buildList() {
    return GridView.builder(
      itemBuilder: _itemBuilder,
      itemCount: _modules?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.91),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var item = _modules[index];
    return InkWell(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              image: DecorationImage(image: AssetImage(item['pic']))),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ErrorBookSubjectListPage(
                  fromShuXiao: index == 1, // 数校错题本地址不一样，
                  showCamera: item['title'] == MTTLocalization.of(context).currentLocalized.error_book_page_upload_error_item)));
        });
  }
}
