import 'package:flutter/material.dart';

void main() => runApp(ButtonApp());

class ButtonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "Button Demoe",
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light
      ),
      home: HomePage(title: "Button"),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageStete();
  }
}

class HomePageStete extends State<HomePage> {

  bool isTouchRaisedButton = false;

  // raised button action
  void _raisedButtonAction() {
    setState(() {
      isTouchRaisedButton = !isTouchRaisedButton;
    });
  }

  void _FlatButtonAction(){
    setState(() {
      isTouchRaisedButton = !isTouchRaisedButton;
    });
  }

  void _OutlineButtonAction(){
    setState(() {
      isTouchRaisedButton = !isTouchRaisedButton;
    });
  }

  void _IconButtonAction(){
    setState(() {
      isTouchRaisedButton = !isTouchRaisedButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Button",
          style: TextStyle(color: Colors.indigo),
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Button"),
            RaisedButton(
              child: Text("RaisedButton",
                style: TextStyle(color: isTouchRaisedButton ? Colors.orange : Colors.red),
              ),
              highlightColor: Colors.yellow,
              textTheme: ButtonTextTheme.accent,
              onPressed: _raisedButtonAction,
            ),

          FlatButton(
            child: Text("FlatButton",
              style: TextStyle(color: isTouchRaisedButton ? Colors.orange : Colors.red),
            ),
            onPressed: _FlatButtonAction,
          ),

          OutlineButton(
            child: Text("OutlineButton",
              style: TextStyle(color: isTouchRaisedButton ? Colors.orange : Colors.red),
            ),
            onPressed: _OutlineButtonAction,
            highlightedBorderColor: Colors.red,
          ),

          IconButton(
            icon: Icon(Icons.today),
            onPressed: _IconButtonAction,
            highlightColor: Colors.red,
          ),

          ],
        ),
      ),
    );
  }
}
