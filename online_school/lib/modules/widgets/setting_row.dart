import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingRow extends StatelessWidget {
  final icon;
  final text;
  final color;
  final textStyle;

  final onPress;
  final subText;
  final subTextStyle;

  final rightCustomWidget;

  final subWidget;

  final showRightArrow;

  SettingRow(this.text,
      {this.textStyle,
      this.icon,
      this.color,
      this.onPress,
      this.subText,
      this.subTextStyle,
      this.subWidget,
      this.showRightArrow = true,
      this.rightCustomWidget});

  @override
  Widget build(BuildContext context) {
    if ((subText != null && subWidget != null)) {
      throw FormatException('subText 和 subWidget不能同时存在');
    }

    return InkWell(
      child: Container(
        // padding: EdgeInsets.all(10),
        height: 50,
        child: Row(
          children: <Widget>[
            icon != null
                ? Padding(
                    padding: EdgeInsets.all(14),
                    child: Icon(icon,
                        color: Color(MyColors.primaryLightValue),
                        size: icon != null ? 24 : 0),
                  )
                : const SizedBox(),
            Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  children: <Widget>[
                    Text(text, style: textStyle ?? textStyleNormal),
                    subWidget != null
                        ? subWidget
                        : subText == null
                            ? const SizedBox()
                            : Padding(padding: EdgeInsets.only(left: 18)),
                    subText == null
                        ? const SizedBox()
                        : Container(
                            width: 220,
                            child: Text(subText,
                                overflow: TextOverflow.ellipsis,
                                style: subTextStyle ?? textStyleTabUnselected))
                  ],
                )),
            Expanded(
                child: Container(
                    alignment: FractionalOffset.centerRight,
                    padding: EdgeInsets.only(right: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (rightCustomWidget != null) rightCustomWidget,
                        if (showRightArrow)
                          Icon(
                            MyIcons.ARROW_R,
                            color: Color(MyColors.black999),
                            size: 14,
                          )
                      ],
                    )))
          ],
        ),
      ),
      onTap: onPress ?? null, // null，没有水波纹效果
    );
  }
}
