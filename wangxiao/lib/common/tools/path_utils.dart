import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<String> getLocalPath(String subDir) async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
      if(subDir==null){
        return directory.path;
      }

    var pdfDir = Directory(directory.path + '/$subDir');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return pdfDir.path;
}
