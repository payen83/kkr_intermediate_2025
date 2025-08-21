import 'package:flutter/material.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Map and Geolocation'),
      ),
      body: Container(),
      drawer: DrawerWidget(),
    );
  }
}