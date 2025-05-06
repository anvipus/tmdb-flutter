import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app_flutter/data/provider/movie_provider.dart';
import 'package:movie_app_flutter/modules/home/home_controller.dart';
import 'package:movie_app_flutter/modules/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Movie App Flutter',
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => MovieProvider());
        Get.lazyPut(() => HomeController(movieProvider: Get.find()));
      }),
      home: const HomeView(),
    );
  }
}
