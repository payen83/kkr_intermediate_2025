import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/controller/blog.controller.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final BlogController controller = Get.find();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add New Blog'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                width: MediaQuery.of(context).size.width,
                child: Text(
                    'Title',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter text..'
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}