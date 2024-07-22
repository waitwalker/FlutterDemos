

import 'package:card_swiper/card_swiper.dart';
import 'package:data_async/ciphertext_image.dart';
import 'package:data_async/home_binding.dart';
import 'package:data_async/home_page.dart';
import 'package:data_async/single.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final List<String> images = [
  //   "https://static-mh-demo.sistalk.cn/mhd/assets/1727329149649d433c3c207.png",
  //   "https://static-mh-demo.sistalk.cn/mhd/assets/1329536528649d46a531373.png",
  //   "https://monsterhub.oss-cn-beijing.aliyuncs.com/mhd/assets/2059943601649d43315775b.png",
  //   "https://monsterhub.oss-cn-beijing.aliyuncs.com/mhd/assets/185161520649d4326dac52.png",
  //   "https://monsterhub.oss-cn-beijing.aliyuncs.com/mhd/assets/1727329149649d433c3c207.png",
  //   "https://static-mh-demo.sistalk.cn/mhd/assets/1509935555649d43e2d3bf4.png"
  // ];

  final List<String> images = [
    "https://monsterhub-editor.oss-cn-beijing.aliyuncs.com/stream/1/avatar_1690865944315000.webp",
    "https://monsterhub-editor.oss-cn-beijing.aliyuncs.com/stream/1/avatar_1690870345910000.webp",
    "https://monsterhub-editor.oss-cn-beijing.aliyuncs.com/stream/1/avatar_1690870338434000.webp",
    "https://monsterhub-editor.oss-cn-beijing.aliyuncs.com/stream/1/avatar_1690870345910000.webp",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          InkWell(
            child: Container(
              width: 300,
              height: 200,
              color: Colors.lightBlue,
              child: const Text("跳转到类似首页", style: TextStyle(fontSize: 30, color: Colors.white),),
            ),
            onTap: (){
              SingletonManager.sharedInstance.tag = "profile";
              Get.to(()=>const HomePage(),binding: HomeBinding(SingletonManager.sharedInstance.tag));
            },
          ),
          const SizedBox(height: 50,),
          Expanded(child: Swiper(
            loop: true,
            autoplay: true,
            duration: 1000,
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
              return CiphertextImage.network(
                url: images[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                cache: true,
                isAntiAlias: true,
              );
            },
          )),

        ],
      ),
    );
  }
}
