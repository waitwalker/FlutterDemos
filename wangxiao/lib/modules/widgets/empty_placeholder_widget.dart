import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';

///
/// @name EmptyPlaceholderPage
/// @description 没有数据站位
/// @author liuca
/// @date 2020-01-11
///
class EmptyPlaceholderPage extends StatelessWidget {
  String assetsPath;
  String message;
  OnPressedHolder onPress;

  EmptyPlaceholderPage(
      {this.assetsPath = 'static/images/empty.png',
      this.message = '没有数据',
      this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          padding: EdgeInsets.all(81.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  assetsPath,
                  fit: BoxFit.cover,
                ),
                Padding(padding: EdgeInsets.only(top: 50)),
                Text(message, style: textStyleLargeNormal),
              ],
            ),
          ),
        ),
        onTap: onPress);
  }
}

typedef void OnPressedHolder();
