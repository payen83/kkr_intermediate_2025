import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kkr_intermediate_2025/app/controller/blog.controller.dart';
import 'package:kkr_intermediate_2025/app/model/blog.model.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final BlogController controller = Get.find();
  
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void saveBlog(){
    final blog = Blog(
      title: titleController.text,
      description: descriptionController.text
    );
    controller.addBlog(blog);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add New Blog'),
      ),
      body: Column(
        children: [
          TextFieldWidget(textLabel: 'Title', fieldController: titleController),
          TextFieldWidget(textLabel: 'Description', fieldController: descriptionController),          
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: ElevatedButton(onPressed: saveBlog, child: Text('Save Blog')),
          )
        ],
      ),
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.textLabel,
    required this.fieldController,
  });

  final String textLabel;
  final TextEditingController fieldController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          width: MediaQuery.of(context).size.width,
          child: Text(
              textLabel,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: TextField(
            controller: fieldController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text..'
            ),
          ), 
        ),
      ],
    );
  }
}