import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';

class TextTag extends StatelessWidget {
  const TextTag({
    Key key,
    @required this.text,
    this.textStyle,
  }) : super(key: key);

  final String text;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
      child: Text(
        text,
        style: textStyle ??
            TextStyle(fontSize: 13, color: Color(MyColors.primaryValue)),
      ),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Color(MyColors.primaryValue),
            width: 0.5,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(4)),
      )),
    );
  }
}
