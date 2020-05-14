import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';
import 'package:flutterarchivedemo/file_page.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String path;
  String _uri = "https://attach.etiantian.com/security/3b657eea12f03fedf7f01b52370479d2/5ebb9c53/ett20/resource/0a32b838821a8c99c987aa3d57623dbf/1560586789993.pdf";
  void _incrementCounter() {
    //decoderFile();
    readFile();
  }

  readFile() async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final directory = Directory(root.path + "/file/archive-master");

    print("directory: $directory");

    final files = directory.listSync();
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return FilePage(files,title: "archive-master",);
    }));
    return;
    for (FileSystemEntity file in files) {
      print("file last path:${file.path.split("/").last}");
      print("file:$file");
      bool isDir = file is Directory;
      print("isDir:$isDir");
      final exi = await file.exists();
      print("exi:$exi");
    }


    print("files: $files");

  }

  // 解压缩文件成功
  decoderFile() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    print("directory path:${directory.path}");

    File file = File("${directory.path}/file/archive-master.zip");

    final exist = await file.exists();

    print("exist: $exist");

    final bytes = file.readAsBytesSync();
    final archive = ZipDecoder().decodeBytes(bytes);
    
    print("$archive");
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(directory.path + '/file/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(directory.path + '/file/' + filename)
          ..create(recursive: true);

      }
    }

    
  }


  Future<String> get _localPath async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var pdfDir = Directory(directory.path + '/file');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return pdfDir.path;
  }

  Future<File> get _localFile async {
    final dir = await _localPath;
    return File('$dir/$name');
  }

  Future<File> writeCounter(Uint8List stream) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsBytes(stream);
  }

  Future<Uint8List> fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;

    return responseJson;
  }

  String get name => getName(_uri);

  loadFile(String url) async {
    writeCounter(await fetchPost(url));
    path = (await _localFile).path;
  }

  getName(String url) {
    // check url format
    if (_uri == null || _uri.length == 0) {
      var d = url.lastIndexOf("/");

      if (d != -1) {
        print("${url.split('/').last}");
        return url.split('/').last;
      }
      return 'unknow.pdf';
    } else {
      return '测试.pdf';
    }
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
