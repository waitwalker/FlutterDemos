import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

typedef GestureTapCallback = void Function();

class MyRadio<T> extends StatelessWidget {
  final bool checked;
  final GestureTapCallback onTap;
  final String label;
  final TextStyle labelStyle;

  MyRadio(
      {@required this.checked,
      @required this.label,
      this.labelStyle,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 5),
            child: checked
                ? Icon(
                    MyIcons.CHECKED,
                    size: 15.0,
                    color: Color(MyColors.primaryLightValue),
                  )
                : Icon(
                    MyIcons.UNCHECKED,
                    size: 15.0,
                    color: Color(MyColors.ccc),
                  ),
          ),
          Text(label, style: labelStyle ?? textStyleSub),
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
