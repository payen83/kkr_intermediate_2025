import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kkr_intermediate_2025/app/service/api.service.dart';

class AddBulletin extends StatefulWidget {
  const AddBulletin({super.key});

  @override
  State<AddBulletin> createState() => _AddBulletinState();
}

class _AddBulletinState extends State<AddBulletin> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  MultipartFile? imageFile;

  String imagePath = '';
  String title = '';
  int lines = 1;
  
  Future<void> onClickButton() async{
    if (imageFile != null){
      await uploadImage(imageFile);
    } else {
      await submitBulletin(null);
    }
  }

    Future<void> uploadImage(MultipartFile? imageFile) async{
      FormData formData = FormData.fromMap({'upload': imageFile});
      try {
        var response = await api.postDio('/upload', formData);
        final uploadImagePath = response?.data['data']['image_path'] ?? '';
        submitBulletin(uploadImagePath);
      } catch (e){
        log(e.toString());
      }
    }

    Future<void> submitBulletin(String? path) async{
      final Map<String, dynamic> data = {
        "title": titleController.text,
        "date": dateController.text,
        "location": locationController.text,
        "description": descriptionController.text,
        "image_path": ''
      };
      if(path != null){
        data['image_url'] = path;
        
      }

      FormData formData = FormData.fromMap(data);
      
      try {
        
        var res = await api.postDio('/news', formData);
        log((jsonEncode(res?.data)));
        // log(res?.data);
        if(res?.data['status'] == true){
          var message = res?.data['message'];
          log('Succcesss $message');
          if(!mounted) return;
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              content: Text(message),
              actions: [
                TextButton(onPressed: (){
                    Navigator.pop(context);// to close alert doialogue
                    Navigator.pop(context, true); //navigate to bulletin screen
                  }, child: Text('OK')
                )
              ],

            );
          });
        } else {
          log("Error Occurred in sending API");
        }
      } catch (e){
        log(e.toString());
      }
    }



  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String extension = image.path.split('.').last.toLowerCase();
      String subtype = switch (extension) {
        'jpg' || 'jpeg' => 'jpeg',
        'png' => 'png',
        'gif' => 'gif',
        _ => '*',
      };

      imagePath = image.path;
      imageFile = await MultipartFile.fromFile(
        image.path,
        filename: image.name,
        contentType: DioMediaType('image', subtype),
      );
      setState(() {

      });
    }
  }

  Future<void> selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add New Bulletin'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextfieldWidget(
              fieldController: titleController,
              lines: 1,
              textLabel: 'Title',
            ),
            TextfieldWidget(
              fieldController: descriptionController,
              lines: 5,
              textLabel: 'Description',
            ),
            TextfieldWidget(
              fieldController: locationController,
              lines: 1,
              textLabel: ':Location',
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: dateController,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => selectDate(),
              ),
            ),
            //Image picker
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.green, width: 1),
                    image: imagePath == ''
                        ? null
                        : DecorationImage(image: FileImage(File(imagePath))),
                  ),
                  child: imagePath == ''
                      ? Icon(Icons.add_a_photo, color: Colors.black, size: 32)
                      : null,
                ),
                onTap: () => pickImage(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => onClickButton(),
                child: Text('Submit', style: TextStyle(fontSize: 20)),
              ),
            ),
            // TextfieldWidget(fieldController: dateController, lines: 1, textLabel: 'Date'),
          ],
        ),
      ),
    );
  }
}

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    required this.fieldController,
    required this.lines,
    required this.textLabel,
  });

  final TextEditingController fieldController;
  final int lines;
  final String textLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextField(
        controller: fieldController,
        maxLines: lines,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: textLabel,
        ),
      ),
    );
  }
}
