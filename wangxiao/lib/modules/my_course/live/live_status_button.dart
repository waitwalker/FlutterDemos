import 'package:online_school/modules/widgets/style.dart';
import 'package:flutter/material.dart';


class LiveStatusButton extends StatelessWidget {
  LiveStatusButton({Key key, this.status, this.onPress}) : super(key: key);
  LiveStatus status;
  Function onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 80,
        height: 45,
        child: Container(
          alignment: Alignment.center,
          height: 25,
          width: 60,
          child: Text(
            status == LiveStatus.live_over
                ? '回放'
                : status == LiveStatus.in_progress ? '进行中' : '未开始',
            style: TextStyle(color: Colors.white),
          ),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              color: Color(MyColors.primaryValue)),
        ),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.transparent, width: 10))),
      ),
      onTap: onPress ?? () => {},
    );
  }
}

enum LiveStatus { not_started, in_progress, live_over }