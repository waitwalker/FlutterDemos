import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SliderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SliderState();
  }
}

class _SliderState extends State<SliderPage> {
  SlidableController slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  List<String> titles = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
  ];
  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("左划右划"),
      ),
      body: ListView.builder(itemBuilder: _itemBuilder, itemCount: titles.length,),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Padding(padding: EdgeInsets.only(left: 20),
        child: Container(
          height: 44,
          child: Slidable(
            child: Text(titles[index]),
            actionPane: _getActionPane(index),
            actionExtentRatio: 0.3,
            direction: Axis.horizontal,
            actions: <Widget>[
              IconSlideAction(
                caption: "分享",
                color: Colors.lightGreen,
                icon: Icons.share,
                onTap: (){
                  print("分享点击");
                },
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: "更多",
                color: Colors.lightBlue,
                icon: Icons.more,
                onTap: (){
                  print("更多点击");
                },
              ),
              IconSlideAction(
                caption: "删除",
                color: Colors.redAccent,
                icon: Icons.delete,
                onTap: (){
                  setState(() {
                    titles.removeAt(index);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

}