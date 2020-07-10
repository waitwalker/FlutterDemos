import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// @name 播放按钮
/// @description 
/// @author liuca
/// @date 2020-01-11
///
class PlayerOutlineButton extends StatefulWidget {
  /// words in button
  String text;

  /// button width
  double width;

  /// button height
  double height;

  EdgeInsetsGeometry padding;

  /// color of [text]
  Color textColor;

  /// font size of [text]
  double fontSize;
  double borderWidth;
  BorderStyle borderStyle;

  /// If not null, all corner is cornered
  double borderRadiusAllSize;

  /// custom border radius, if not null, [borderRadiusAllSize] is useless
  BorderRadius borderRadius;
  GestureTapCallback onPress;
  bool selected;

  PlayerOutlineButton(
      {Key key,
      @required this.text,
      this.width = 60,
      this.height,
      this.padding,
      this.textColor = Colors.white,
      this.fontSize = 13,
      this.borderWidth = 0.5,
      this.borderStyle = BorderStyle.solid,
      this.borderRadiusAllSize = 4,
      this.borderRadius,
      this.onPress,
      this.selected = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerOutlineButtonState();
  }
}

class _PlayerOutlineButtonState extends State<PlayerOutlineButton> {
  Color get primaryColor => Theme.of(context).primaryColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onPress,
        child: Container(
          alignment: Alignment.center,
          padding: widget.padding,
          child: Text(widget.text,
              style: TextStyle(
                  color: widget.selected ? primaryColor : widget.textColor,
                  fontSize: widget.fontSize)),
          width: widget.width,
          height: widget.height,
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
            side: BorderSide(
                color: widget.selected ? primaryColor : widget.textColor,
                width: widget.borderWidth,
                style: widget.borderStyle),
            borderRadius: widget.borderRadius ??
                BorderRadius.all(Radius.circular(widget.borderRadiusAllSize)),
          )),
        ));
  }
}
