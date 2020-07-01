import 'dart:io';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:online_school/common/dao/original_dao/course_dao_manager.dart';
import 'package:online_school/common/locale/localizations.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/redux/app_state.dart';
import 'package:online_school/modules/widgets/style.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';

///
/// @name FeedBackPage
/// @description 意见反馈页面
/// @author liuca
/// @date 2020-01-11
///
class FeedBackPage extends StatefulWidget {
  var courseId;

  FeedBackPage(this.courseId);

  @override
  _FeedBackPageState createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  var rating = 0.0;

  TextEditingController _controller;

  static Map<int, String> ratingMap = {
    1: '很差',
    2: '差',
    3: '一般',
    4: '很好',
    5: '非常好'
  };

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(builder: (BuildContext context, Store<AppState> store){
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text(MTTLocalization.of(context).currentLocalized.feedback_page_navigator_title),
          backgroundColor: Colors.white,
          centerTitle: Platform.isIOS ? true : false,
        ),
        resizeToAvoidBottomPadding: true,
        body: Container(
          padding: EdgeInsets.only(left: 24, right: 24, top: 15),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(MTTLocalization.of(context).currentLocalized.feedback_page_content, style: textStyle14999),
                Padding(padding: EdgeInsets.only(top: 15)),
                SizedBox(width: 100, child: Divider(height: 0.5)),
                Padding(padding: EdgeInsets.only(top: 28)),
                new StarRating(
                  size: 25.0,
                  rating: rating,
                  color: Colors.redAccent,
                  borderColor: Colors.grey,
                  starCount: 5,
                  onRatingChanged: (rating) => setState(
                        () {
                      this.rating = rating;
                      CourseDaoManager.rating(
                          courseId: widget.courseId.toString(),
                          score: rating.toInt().toString());
                    },
                  ),
                ),
                Text(ratingMap[rating] ?? '', style: textStyle14999),
                Padding(padding: EdgeInsets.only(top: 24)),
                Container(
                  height: 248,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: ShapeDecoration(
                      shape: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(MyColors.line)))),
                  child: TextField(
                    maxLines: 100,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: MTTLocalization.of(context).currentLocalized.feedback_page_input_hint,
                      hintStyle: textStyleHint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 90)),
                Container(
                  width: 285,
                  child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    disabledColor: Color(MyColors.ccc),
                    disabledElevation: 0,
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Text(
                      MTTLocalization.of(context).currentLocalized.feedback_page_send,
                      style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.normal,),
                    ),
                    color: Color(MyColors.primaryValue),
                    onPressed: () async {
                      var content = _controller.text ?? '';
                      if (content.isEmpty) {
                        Fluttertoast.showToast(msg: '反馈内容不能为空');
                        return;
                      }
                      PackageInfo packageInfo = await PackageInfo.fromPlatform();
                      var versionName = packageInfo.version;
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      AndroidDeviceInfo androidInfo;
                      IosDeviceInfo iosInfo;
                      if (Platform.isAndroid) {
                        androidInfo = await deviceInfo.androidInfo;
                      } else {
                        iosInfo = await deviceInfo.iosInfo;
                      }
                      ResponseData response = await CourseDaoManager.feedback(
                          courseId: widget.courseId.toString(),
                          content: _controller.text,
                          appVersion: versionName,
                          deviceType: Platform.isAndroid
                              ? androidInfo.model
                              : iosInfo.name,
                          systemVersion: Platform.isAndroid
                              ? androidInfo.version.release
                              : iosInfo.systemVersion);

                      if (response.result &&
                          response.model != null &&
                          response.model.code == 1) {
                        Fluttertoast.showToast(msg: '反馈成功');
                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(msg: response.model.msg ?? '提交失败');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
