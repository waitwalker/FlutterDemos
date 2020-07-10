import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IndicatorTab extends StatefulWidget {
  IndicatorTab({this.key, this.text, this.onPress, this.selected})
      : super(key: key);

  final Key key;
  final String text;
  final Function onPress;
  bool selected = true;

  @override
  IndicatorTabState createState() {
    return new IndicatorTabState();
  }
}

class IndicatorTabState extends State<IndicatorTab> {
  @override
  Widget build(BuildContext context) {
    var indicator = Padding(
        padding: EdgeInsets.all(14),
        child: Container(
          height: 3,
          width: 20,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(2)),
        ));

    var unselectedIndicator = Container(
      height: 31,
      width: 20,
    );

    return FlatButton(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(widget.text,
              style: widget.selected ? textStyleTab : textStyleTabUnselected),
          widget.selected ? indicator : unselectedIndicator,
        ],
      ),
      onPressed: widget.onPress,
    );
  }
}
