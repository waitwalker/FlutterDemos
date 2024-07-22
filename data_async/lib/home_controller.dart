
import 'package:data_async/item_model.dart';
import 'package:data_async/single.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  var models = RxList<ItemModel>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchData();
  }

  void fetchData() {
    if (SingletonManager.sharedInstance.tag == "profile") {
      List.generate(15, (index) {
        models.add(ItemModel()..title="index:$index"..liked=index < 2);
      });
    } else {
      List.generate(15, (index) {
        models.add(ItemModel()..title="index:$index"..liked=false);
      });
    }
  }

}
