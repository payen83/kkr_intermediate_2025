import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/model/blog.model.dart';

class BlogController extends GetxController {
  var blogList = <Blog>[].obs;

  void addBlog(Blog blog){
    blogList.add(blog);
  }

}
