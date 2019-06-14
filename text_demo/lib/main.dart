import 'package:flutter/material.dart';

void main() => runApp(TextApp());

class TextApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Hello World",
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(title: "Hello World"),
    );
  }
}

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
  // @override
  // _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("这个是导航栏标题"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Hello World"),
          ],
        ),
      ),
    );
  }
}
