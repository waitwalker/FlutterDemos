import 'package:data_async/home_controller.dart';
import 'package:data_async/profile_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {

  HomeBinding(this.tag);
  final String tag;

  @override
  void dependencies() {

    Get.lazyPut(() => HomeController(), tag: tag);
  }

}

class ProfileBinding extends Bindings {

  ProfileBinding(this.tag);
  final String tag;

  @override
  void dependencies() {

    Get.lazyPut(() => ProfileController(), tag: tag);
  }

}