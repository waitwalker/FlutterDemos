import 'dart:math';

import 'package:data_async/app_routes.dart';
import 'package:data_async/home_controller.dart';
import 'package:data_async/item_model.dart';
import 'package:data_async/profile_page.dart';
import 'package:data_async/single.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.find<HomeController>(tag: SingletonManager.sharedInstance.tag);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.models.isEmpty
          ? const SizedBox()
          : PageView.builder(
              itemBuilder: (BuildContext context, int index) {
                ItemModel itemModel = controller.models[index];
                return InkWell(
                  child: Container(
                    height: 80,
                    color: itemModel.liked ? Colors.orange : randomColor(),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "当前$index的title：${itemModel.title}",
                            style: const TextStyle(fontSize: 25, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Container(
                              height: 60,
                              color: Colors.green,
                              child: const Text(
                                "Button",
                                style: TextStyle(fontSize: 25, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              // Get.to(()=>ProfilePage());
                              Get.toNamed(AppRoutes.profile,);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    itemModel.liked = !itemModel.liked;
                    print("当前的controller：$controller}");
                    controller.models.refresh();

                    HomeController homeController = Get.find<HomeController>(tag: "home");
                    for(int i = 0; i < homeController.models.length;i++) {
                      if (homeController.models[i].title == itemModel.title) {
                        print("首页的item是否选中：${itemModel.liked}");
                        homeController.models[i].liked = itemModel.liked;
                        homeController.models.refresh();
                        print("首页刷新完结果：${homeController.models}");
                        break;
                      }
                    }
                  },
                );
              },
              itemCount: controller.models.length,
        scrollDirection: Axis.vertical,
            )),
    );
  }

  Color randomColor() {
    final rand = Random();
    final r = rand.nextInt(255);
    final g = rand.nextInt(255);
    final b = rand.nextInt(255);
    final a = rand.nextInt(100) + 155;
    return Color.fromARGB(a, r, g, b);
  }
}


