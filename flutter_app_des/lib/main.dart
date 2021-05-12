
import 'package:flutter/material.dart' hide Key;
import 'dart:convert' as convert;
import 'package:encrypt/encrypt.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {

    // 加密的内容
    final plainText = '12456申达股份';
    // 加密的秘钥
    final key = Key.fromUtf8('#YXW#COMMON#2016');
    // 初始化的向量官方代码里是这么注释的{Represents an Initialization Vector}
    final iv = IV.fromLength(16);
    //加密容器
    final encrypter = Encrypter(AES(key));
    //加密部分
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    //解密部分
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
    print(encrypted.base64);

    // String desStr = decryptAes("BADF104A9C33AB4941561BE5D44823D515C3CA2997851F9DFC697E47AFC295021E8DA50549E58714001C8F522FD98477F54AFCE4FA1F44AB3E3A049E5DE0945310E9BF07E6B5EB41D40ED43404098F3D51E080E0615C2DA86C162D914CA3BA7F1F643614861B589983E07CFE6FC1FF106D9D99B35AB751F8FFB8150C5D18D039580F5B0C22E6BD04267EF98E10C86A221E5F5D9D84E33B2B8E0B68FFE2102ABFF8CF8E17726EB4883B3AAB4F4105777E85999370D51E46700CE14F7A77DB4B2038230945402ADC49B891F15D2D182737CE8AC80702A5828A6AC8D13D5D86528F5A035B9310388E6105659CE0C592DCB6AFEE92DA424BD55FE85C6CFCC6CCAE0D367C0486FB008D01EEC8B4836F3F7FE4CF8F9E90E5BA197A3BA12745A4A1173112438BA8E8D42C3ABF18487C8052E7256BF4D70ACD8FE43FEBF150B71BEA7E37AC4C4ACC3A4C9B86914C660DE57BA46DE5AB819E19F7163DA7E16B3049B825FEC9C90C81C0EE5DF94A11C954B1579A9960CA7CF6DCA5EC92750493AC4164D35F4968F5C95D683792307F500F41C422F351D6CFC6D655F4FE3D1D93CBD0D4E553193B58187418D641F903B70D7CCC60C34C15EFE2907ADC6ACED5FD332A51552B2A2500E9CFD671A79673BB00D021FACC224B2A85E352E9E9A436A83312DAC634E710C82757AB80529ECF9236B4C72316");
    // print("$desStr");
  }

  Encrypted encryptAes(String content, {AESMode aesMode = AESMode.ecb, IV iv, String aesKey: "#YXW#COMMON#2016"}) {
    final _aesKey = Key.fromUtf8(aesKey);
    final _encrypter = Encrypter(AES(_aesKey, mode: aesMode));
    final _encrypted = _encrypter.encrypt(content,iv: iv);

    return _encrypted;
  }

  String decryptAes(String content, {AESMode aesMode = AESMode.ecb,IV iv, String aesKey: "#YXW#COMMON#2016",}) {

    var _res = convert.base64.decode(content);
    final _aesKey = Key.fromUtf8(aesKey);
    final _encrypter =
    Encrypter(AES(_aesKey, mode: AESMode.ecb));
    final _decrypted = _encrypter.decrypt(Encrypted(_res),iv: iv);

    return _decrypted;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
