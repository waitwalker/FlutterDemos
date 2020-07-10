import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name EyeProtectDialogWidget
/// @description 护眼提醒弹框
/// @author liuca
/// @date 2020-01-11
///
class EyeProtectDialogWidget extends StatelessWidget {
  final void Function() tapCallBack;

  EyeProtectDialogWidget({this.tapCallBack}) {
    DateTime dateTime = DateTime.now();
    print("当前时间:${dateTime.hour}");
    if (dateTime.hour > 6 && dateTime.hour < 18) {
      isDay = true;
    } else {
      isDay = false;
    }
  }

  /// 是否白天
  bool isDay = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          height: 352,
          width: MediaQuery.of(context).size.width - 76,
          decoration: _boxDecoration(isDay),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 39, left: 34, right: 34),
                child: Image.asset("static/images/eye_protect_img_day.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Text(
                  "看看窗外休息一下吧!",
                  style: TextStyle(
                      fontSize: 15,
                      color: isDay
                          ? Color(MyColors.eyeProtectGrey)
                          : Color(MyColors.white)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 37,
                ),
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    height: 44,
                    width: MediaQuery.of(context).size.width - (59 * 2),
                    decoration: isDay
                        ? BoxDecoration(
                      color: Color(MyColors.white),
                      gradient: LinearGradient(
                        colors: [
                          Color(MyColors.courseScheduleCardLight),
                          Color(MyColors.courseScheduleCardMain)
                        ],
                      ),
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)), //设置圆角
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Color(0x466A99FF),
                            offset: Offset(0, 1),
                            blurRadius: 11.0,
                            spreadRadius: 2.0)
                      ],
                    )
                        : BoxDecoration(
                      color: Color(MyColors.white),
                      borderRadius:
                      BorderRadius.all(Radius.circular(5.0)), //设置圆角
                    ),
                    child: Text("好的,我知道了",
                      style: TextStyle(fontSize: 16, color: isDay ? Color(MyColors.white) : Color(MyColors.eyeProtectGrey),),
                    ),
                  ),
                  onTap: tapCallBack,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration(bool isDay) {
    return BoxDecoration(
      color:
          isDay ? Color(MyColors.white) : Color(MyColors.eyeProtectBackground),
      borderRadius: BorderRadius.all(
        Radius.circular(6),
      ),
      boxShadow: [
        BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.26),
            offset: Offset(0, 1),
            blurRadius: 11.0,
            spreadRadius: 2.0)
      ],
    );
  }
}
