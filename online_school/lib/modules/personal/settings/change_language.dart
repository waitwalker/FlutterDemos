import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/locale/locale_mamager.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:online_school/common/tools/share_preference.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:redux/redux.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// @name ChangeLanguagePage
/// @description 切换语言
/// @author liuca
/// @date 2020/5/25
///
class ChangeLanguagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeLanguageState();
  }
}

class _ChangeLanguageState extends State<ChangeLanguagePage> {
  Store currentStore;
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> vm) {
      currentStore = vm;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
          title: Text(MTTLocalization.of(context).currentLocalized.change_language_navigator_title,),),
        backgroundColor: Color(MyColors.background),
        body: ListView.builder(itemBuilder: _itemBuilder, itemCount: 2,),
        );
    });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    String title = index == 0 ?
    MTTLocalization.of(context).currentLocalized.change_language_chinese_title :
    MTTLocalization.of(context).currentLocalized.change_language_english_title;
    return InkWell(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 44,
                child: Padding(padding: EdgeInsets.only(left: 14),child: Text(title),),
              ),
              if (SingletonManager.sharedInstance.currentLocaleIndex == index)
                Padding(padding: EdgeInsets.only(right: 14),child: Icon(Icons.check,size: 16, color: Colors.amberAccent,),),
            ],
          ),
          Divider(height: 1,),
        ],
      ),
      onTap: () async{
        SingletonManager.sharedInstance.currentLocaleIndex = index;
        LocaleManager.changeLocale(currentStore, index);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setInt("locale", index);
        setState(() {

        });
      },
    );
  }
}