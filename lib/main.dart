import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/app.dart';
import 'package:kkr_intermediate_2025/app/controller/blog.controller.dart';

void main() {
  Get.put(BlogController());
  runApp(const MyApp());
}
