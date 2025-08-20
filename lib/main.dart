import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/app.dart';
import 'package:kkr_intermediate_2025/app/controller/blog.controller.dart';
import 'package:kkr_intermediate_2025/app/service/sharedpreference.service.dart';

void main() async {
  Get.put(BlogController());
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreferences.init();

  runApp(const MyApp());
}
