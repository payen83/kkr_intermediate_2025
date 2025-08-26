import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kkr_intermediate_2025/app/service/api.service.dart';
import 'package:kkr_intermediate_2025/app/widget/drawer.widget.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:kkr_intermediate_2025/app/service/key.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  final PopupController popupLayerController = PopupController();
  late final AnimatedMapController animatedMapController;
  double lat = 0.0;
  double lng = 0.0;
  LatLng currentLatLng = LatLng(3.1467845, 101.6882443);

  bool isMarkerCenter = true;
  List<Marker> markers = [];
  LatLng? centerMarker;
  TextEditingController searchController = TextEditingController();
  
  List<dynamic> predictions = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    animatedMapController = AnimatedMapController(vsync: this);
    getLatLng();
  }

  void setMarker(LatLng markerPoint) {
    setState(() {
      isMarkerCenter = true;
    });
    markers.clear();
    markers.add(
      Marker(
        point: markerPoint,
        width: 40,
        height: 40,
        child: Icon(Icons.location_pin, color: Colors.red, size: 40),
      ),
    );
    animatedMapController.animateTo(
      dest: markerPoint,
      zoom: 13,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 1000),
    );
  }

  Future<void> getLatLng() async {
    LocationPermission permission;
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
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
    } catch (e) {
      log('Error in getting current location');
    }
  }

  void locationDetails(String placeID) async {
    Uri uri = Uri.https('maps.googleapis.com', 'maps/api/place/details/json', {
      'place_id': placeID,
      'key': apiKey,
      'fields': 'geometry',
      'components': 'country:MY'
    });

    var res = await api.fetchUri(uri);
    if(res != null && res.isNotEmpty){
      var jsonResponse = json.decode(res);
      if(jsonResponse['status']=='OK'){
        var location = jsonResponse?['result']?['geometry']?['location'];
        if(location['lat'] != null && location['lng'] != null){
          LatLng marker = LatLng(location['lat'], location['lng']);
          
          setState(() {
            // isMarkerCenter = false;
            // predictions = [];
            // markers.clear();
            // popupLayerController.hideAllPopups();
            // markers.add(
            //   Marker(point: marker, width: 40, height: 40, child: Icon(Icons.location_pin))
            // );

            popupLayerController.hideAllPopups();
            markers.clear();
            isMarkerCenter = false;
            centerMarker = marker;
            setMarker(marker);
          });

          // animatedMapController.animateTo(
          //   dest: marker,
          //   zoom: 13,
          //   curve: Curves.easeOut,
          //   duration: Duration(milliseconds: 1000)
          // );
        } else {
          log("Error in getting location");
        }
      }
    }
  }

  void onInputChanged(String value, MenuController menuController){
    if(timer?.isActive ?? false) timer!.cancel();
    timer = Timer(const Duration(milliseconds: 2000), (){
      if(value.isNotEmpty){
        menuController.open();
        locationAutocomplete(value);
      } else {
        setState(() {
          predictions = [];
        });
      }
    });
  }

  void locationAutocomplete(String location) async{
     Uri uri = Uri.https('maps.googleapis.com', 'maps/api/place/autocomplete/json', {
      'input': location,
      'key': apiKey,
      'components': 'country:MY'
    });

    String? res = await api.fetchUri(uri);
    if(res != null && res.isNotEmpty){
      Map<String, dynamic> jsonResponse = json.decode(res);
      if(jsonResponse['status'] == 'OK'){
        setState(() {
          predictions = jsonResponse['predictions'];
        });
      } else {
        log('ERROR: ${jsonResponse['error_message']}');
      }
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
              onPositionChanged: (position, hasGesture) {
                final previousCenter = centerMarker;
                final newCenter = position.center;
                setState(() {
                  if (hasGesture && newCenter != previousCenter) {
                    centerMarker = newCenter;
                    isMarkerCenter = true;
                    markers.clear();
                    popupLayerController.hideAllPopups();
                  }
                });
              },
              onTap: (tapPosition, point) {
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
                    builder: (BuildContext context, Marker marker) {
                      return PopupCard(pointMarker: centerMarker);
                    },
                  ),
                  onPopupEvent: (event, selectedMarkers) {
                    markers.clear();
                    if (selectedMarkers.isNotEmpty) {
                      final marker = selectedMarkers.first;
                      animatedMapController.animateTo(
                        dest: marker.point,
                        zoom: 13,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 1000),
                      );
                    }
                  },
                ),
              ),
              if (isMarkerCenter) ...[
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
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                ),
              ],
              //Menu Anchor for search and result location
              Padding(
                padding: EdgeInsetsGeometry.fromLTRB(16, 4, 16, 16),
                child: MenuAnchor(
                  style: MenuStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  menuChildren: [
                    ...predictions.asMap().entries.map((entry){
                      int index = entry.key;
                      var prediction = entry.value;
                      return Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width-32,
                            child: MenuItemButton(
                              onPressed: (){
                                setState(() {
                                  searchController.text = prediction['description'];
                                  searchController.selection = TextSelection.fromPosition(const TextPosition(offset: 0));
                                });
                                locationDetails(prediction['place_id']);
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.pin_drop,color: Colors.blue, size: 20),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width-92,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            prediction['description'].split(',')[0],
                                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                          ),
                                          Text(
                                            prediction['description'],
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            
                          ),
                          if(index != predictions.length)
                          const Divider(
                            height: 0,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }),
                    
                  ],
                  builder: (_, MenuController menuController, Widget? child){
                    return Card(
                      margin: EdgeInsets.only(top: 10),
                      color: Colors.white,
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search location..',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                searchController.text = '';
                                predictions = [];
                              });
                            },
                            icon: Icon(
                              Icons.close_rounded, 
                              color: searchController.text.isNotEmpty 
                              ? Colors.black
                              :Colors.transparent
                            )
                          )
                        ),
                        onChanged: (value) {
                          onInputChanged(value, menuController);
                        },
                      ),

                    );
                  }
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: DrawerWidget(),
    );
  }
}

class PopupCard extends StatelessWidget {
  const PopupCard({super.key, required this.pointMarker});

  final LatLng? pointMarker;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lat: ${pointMarker?.latitude.toStringAsFixed(5) ?? 'Loading..'}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Text(
              'Lng: ${pointMarker?.longitude.toStringAsFixed(5) ?? 'Loading'}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class GeolcationScreen extends StatelessWidget {
  const GeolcationScreen({super.key, required this.lat, required this.lng});

  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Latitude: $lat', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('Longitude: $lng', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => () {},
            child: Text('Get Geolocation'),
          ),
        ],
      ),
    );
  }
}
