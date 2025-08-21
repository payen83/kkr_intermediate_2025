import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  double lat = 0.0;
  double lng = 0.0;

  Future<void> getLatLng() async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    if(!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return Future.error('Location please enable your location');
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      log(position.toString());
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
      });
    } catch(e){
      log('Error in getting current location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Map and Geolocation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Latitude: $lat', style: TextStyle(fontSize: 20),),
            SizedBox(height: 10,),
            Text('Longitude: $lng', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () => getLatLng(), 
              child: Text('Get Geolocation')
            )
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}