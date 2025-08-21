import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with
TickerProviderStateMixin {
  final PopupController popupLayerController = PopupController();
  late final AnimatedMapController animatedMapController;
  double lat = 0.0;
  double lng = 0.0;
  LatLng currentLatLng = LatLng(3.1467845, 101.6882443);

  bool isMarkerCenter = true;
  List<Marker> markers = [];
  LatLng? centerMarker;
  // LatLng? pinLocation;

  @override
  void initState(){
    super.initState();
    animatedMapController = AnimatedMapController(vsync: this);
    getLatLng();
  }

  void setMarker(LatLng markerPoint){
    setState(() {
      isMarkerCenter = true;
    });
    markers.clear();
    markers.add(Marker(
      point: markerPoint, 
      width: 40,
      height: 40,
      child: Icon(Icons.location_pin, color: Colors.red, size: 40,),
    )
    );
    animatedMapController.animateTo(
      dest: markerPoint,
      zoom: 13,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 1000)
    );
  }

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
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        currentLatLng = LatLng(lat, lng);
        centerMarker = currentLatLng;
        setMarker(currentLatLng);
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
        title: Text('Map and Geolocation2'),
      ),
      // body: GeolcationScreen(lat: lat, lng: lng),
      body: Stack(
        children: [
          FlutterMap(
            mapController: animatedMapController.mapController,
            options: MapOptions(
              initialCenter: currentLatLng,
              initialZoom: 16,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,

              ),
              onPositionChanged: (position, hasGesture){
                final previousCenter = centerMarker;
                final newCenter = position.center;
                setState(() {
                  if(hasGesture && newCenter != previousCenter){
                    centerMarker = newCenter;
                    isMarkerCenter = true;
                    markers.clear();
                    popupLayerController.hideAllPopups();
                  }
                });
              },
              onTap: (tapPosition, point){
                setState(() {
                  popupLayerController.hideAllPopups();
                  markers.clear();
                  isMarkerCenter = false;
                  centerMarker = point;
                  setMarker(point);
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.kkr_intermediate_2025',
              ),
              PopupMarkerLayer(
                options: PopupMarkerLayerOptions(
                  markers: markers,
                  popupController: popupLayerController,
                  markerTapBehavior: MarkerTapBehavior.togglePopup(),
                  popupDisplayOptions: PopupDisplayOptions(
                    builder: (BuildContext context, Marker marker){
                      return PopupCard(pointMarker: centerMarker);
                    }
                  ),
                  onPopupEvent: (event, selectedMarkers) {
                    markers.clear();
                    if(selectedMarkers.isNotEmpty){
                      final marker = selectedMarkers.first;
                      animatedMapController.animateTo(
                        dest: marker.point,
                        zoom: 13,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 1000)
                      );
                    }
                  }
                ),
                
              ),
              if(isMarkerCenter)...[
                //Add marker info
                Align(
                  alignment: Alignment.center,
                  child: Transform.translate(
                      offset: Offset(0, -80),
                      child: PopupCard(pointMarker: centerMarker),
                    ),
                ),
                //Add Marker pin
                Align(
                  alignment: Alignment.center,
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40,),
                ),
              ]
            ]
          )
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

class PopupCard extends StatelessWidget {
  const PopupCard({
    super.key,
    required this.pointMarker,
  });

  final LatLng? pointMarker;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lat: ${ pointMarker?.latitude.toStringAsFixed(5) ?? 'Loading..' }',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              'Lng: ${ pointMarker?.longitude.toStringAsFixed(5) ?? 'Loading'}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class GeolcationScreen extends StatelessWidget {
  const GeolcationScreen({
    super.key,
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Latitude: $lat', style: TextStyle(fontSize: 20),),
          SizedBox(height: 10,),
          Text('Longitude: $lng', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () => (){}, 
            child: Text('Get Geolocation')
          )
        ],
      ),
    );
  }
}