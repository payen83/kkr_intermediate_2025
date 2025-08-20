import 'package:flutter/material.dart';

class AddBulletin extends StatefulWidget {
  const AddBulletin({super.key});

  @override
  State<AddBulletin> createState() => _AddBulletinState();
}

class _AddBulletinState extends State<AddBulletin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Add New Bulletin'),
      ),
      body: Container(),
    );
  }
}