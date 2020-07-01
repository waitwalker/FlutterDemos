import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

///
/// @name AdvertisementManager
/// @description 广告页管理者
/// @author liuca
/// @date 2020-02-17
///
class AdvertisementManager {

  ///
  /// @name fetchImage
  /// @description 下载图片
  /// @parameters
  /// @return
  /// @author liuca
  /// @date 2020-02-17
  ///
  static fetchImage() async{
    final url = "http://abc.waitwalker.cn/dog.png";
    final res = await http.get(url);
    final image = img.decodeImage(res.bodyBytes);
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path; // 临时文件夹
    String appDocPath = appDocDir.path; // 应用文件夹

    final imageFile = File(path.join(appDocPath, 'ad.png')); // 保存在应用文件夹内
    await imageFile.writeAsBytes(img.encodePng(image)); // 需要使用与图片格式对应的encode方法

    /// 打印
    print(imageFile.path);
    print(imageFile.statSync());

  }

}