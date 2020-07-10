import 'dart:io';
import 'dart:typed_data';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:online_school/common/dao/manager/dao_manager.dart';
import 'package:online_school/common/network/response.dart';
import 'package:online_school/common/singleton/singleton_manager.dart';
import 'package:path_provider/path_provider.dart';

///
/// @name CommonToolManager
/// @description 通用工具管理类,比如获取某个权限之类
/// @author liuca
/// @date 2020/5/25
///
class CommonToolManager {
  static fetchLiveAuthority() async {
    ResponseData responseData = await DaoManager.fetchLiveAuthority({});
    if (responseData.code == 200) {
      var originalData = responseData.data;
      if (originalData != null) {
        Map data = originalData["data"];
        int isHaveLiveAuthority = data["zllivePermits"];
        if (isHaveLiveAuthority != null && isHaveLiveAuthority == 1) {
          SingletonManager.sharedInstance.isHaveLiveAuthority = true;
        } else {
          SingletonManager.sharedInstance.isHaveLiveAuthority = false;
        }
      }
    } else {
      SingletonManager.sharedInstance.isHaveLiveAuthority = false;
    }
    print("response:$responseData");
  }

  ///
  /// @name downloadFile
  /// @description 下载学案
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020/6/24
  ///
  static downloadXueAnFile(String url) async {
    final dir = await _localPath();
    String fileName = _getFileName(url);
    String filePath = '$dir/$fileName';
    File file = File(filePath);
    bool isExist = await file.exists();

    Fluttertoast.showToast(msg: '已下载，可以在我的下载查看');
    // 文件不存在, 再去下载
    if (!isExist) {
      _writeCounter(await _fetchPost(url), url);
    }
  }

  //https://cdn1.school.etiantian.net/wxpdf/security/d5addd7ba490395fd03d6bbd315f8b03/5ed857c7/ett20/resource/50b699e5ab3480baab8583b5765ed5f8/b.doc
  static Future<String> _localPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    var pdfDir = Directory(directory.path + '/pdf');
    if (!pdfDir.existsSync()) {
      pdfDir.createSync();
    }
    return pdfDir.path;
  }

  static Future<File> _localFile(String url) async {
    final dir = await _localPath();
    String fileName = _getFileName(url);
    return File('$dir/$fileName');
  }

  static Future<File> _writeCounter(Uint8List stream, String url) async {
    final file = await _localFile(url);
    // Write the file
    return file.writeAsBytes(stream);
  }

  static Future<Uint8List> _fetchPost(String url) async {
    final response = await http.get(url);
    final responseJson = response.bodyBytes;
    return responseJson;
  }

  static _getFileName(String url) {
    print("${url.split('/').last}");

    List strList = url.split("/");
    if (strList.length > 3) {
      return "学案+" + strList[strList.length - 2] + "+" + strList.last;
    } else {
      return strList.last;
    }
  }
  
}