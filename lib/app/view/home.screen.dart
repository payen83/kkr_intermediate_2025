import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/controller/blog.controller.dart';
import 'package:kkr_intermediate_2025/app/view/addblog.screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String title = 'Title';
  final String description = 'Description';
  final BlogController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('State Management'),
      ),
      body: Obx(() => ListView.builder(
          itemCount: controller.blogList.length,
          itemBuilder: (context, index){
            final blog = controller.blogList[index];
            return ItemContainer(title: blog.title, description: blog.description);
          })
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(()=> AddBlogScreen()),
        child: const Icon(Icons.add),
      ), 
    );
  }
}


class ItemContainer extends StatelessWidget {
  const ItemContainer({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        children: [
          //Title
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
            width: MediaQuery.of(context).size.width,
            child: Text(title, 
              style: TextStyle(
                  fontSize: 16, 
                  fontWeight: 
                  FontWeight.w600, 
                  color: Colors.black
                ),
              ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 3),
            width: MediaQuery.of(context).size.width,
            child: Text(description, 
              style: TextStyle(
                  fontSize: 16, 
                  fontWeight: 
                  FontWeight.w600, 
                  color: Colors.black
                ),
              ),
          ),
        ],
      ),
    );
  }
}
