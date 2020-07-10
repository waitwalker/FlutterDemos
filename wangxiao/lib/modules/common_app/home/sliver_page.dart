import 'package:flutter/material.dart';
import 'package:online_school/modules/common_app/home/sliver_appbar_page.dart';

// https://juejin.im/post/5c909cd3f265da610d0cbd4d
class CommonSliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CommonSliverState();
  }
}

class _CommonSliverState extends State<CommonSliverPage> {
  
  List<String> titles = List<String>();
  
  @override
  void initState() {
    titles..add("SliverAppBar");
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("滚动渐变"),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.15,
          ),
          itemBuilder: _itemBuilder,
          itemCount: titles.length,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text("$index"),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text(titles[index]),
        ],
      ),
      onTap: (){
        if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
            return CommonSliverAppBarPage();
          }));
        }
      },
    );
  }
}