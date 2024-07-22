import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileUtils {


  /// 在Document下创建文件夹
  static Future<String> generateDocumentPath(String pathName) async {
    final dir = await getApplicationDocumentsDirectory();
    final Directory targetDir = Directory('${dir.path}/$pathName');
    if (!targetDir.existsSync()) {
      targetDir.createSync();
    }
    return "${dir.path}/$pathName";
  }

}