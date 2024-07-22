import 'package:data_async/home_binding.dart';
import 'package:data_async/home_page.dart';
import 'package:data_async/profile_page.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding("home"),
      preventDuplicates: true,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding("profile"),
      preventDuplicates: true,
      transition: Transition.topLevel,
    ),
  ];
}
