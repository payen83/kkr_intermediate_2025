import 'package:flutter/material.dart';

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

  String imagePath = '';
  String title = '';
  int lines = 1;
  
  Future<void> selectDate() async{
    DateTime? picked = await showDatePicker(
      context: context, firstDate: DateTime.now(), lastDate: DateTime(2100));
    if(picked != null){
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
            TextfieldWidget(fieldController: titleController, lines: 1, textLabel: 'Title'),
            TextfieldWidget(fieldController: descriptionController, lines: 5, textLabel: 'Description'),
            TextfieldWidget(fieldController: locationController, lines: 1, textLabel: ':Location'),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: TextField(
                controller: dateController,
                maxLines: 1,
                decoration: InputDecoration(
                  border:OutlineInputBorder(),
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today)
                ),
                readOnly: true,
                onTap: () => selectDate(),
              ),
            )
            // TextfieldWidget(fieldController: dateController, lines: 1, textLabel: 'Date'),
          ],
        ),
      )
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
          border:OutlineInputBorder(),
          labelText: textLabel,
        ),
      ),
    );
  }
}