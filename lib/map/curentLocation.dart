import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:test_2/map/map.dart';

class CurrentLocationScreen extends StatefulWidget {
  int mua_1;
  int mua_2;
  int mua_3;
  CurrentLocationScreen({
    required this.mua_1,
    required this.mua_2,
    required this.mua_3,
  });

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  late GoogleMapController googleMapController;
  String searchAddr = '';

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(10.8159555, 106.7719956),
    zoom: 14,
  );

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            onMapCreated: onMapCreated,
          ),
          Positioned(
            bottom: _w / 50,
            right: _w / 50,
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(), padding: EdgeInsets.all(16)),
                  onPressed: () {
                    Get.to(MapPage(
                        mua_1: widget.mua_1,
                        mua_2: widget.mua_2,
                        mua_3: widget.mua_3));
                  },
                  child: Icon(Icons.aspect_ratio),
                ),
                SizedBox(
                  height: _h / 100,
                ),
                Positioned(
                  top: _w / 5,
                  right: _w / 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), padding: EdgeInsets.all(16)),
                        onPressed: () async {
                          Position position = await _determinePosition();
                          googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  position.latitude,
                                  position.longitude,
                                ),
                                zoom: 16,
                              ),
                            ),
                          );
                          markers.clear();
                          markers.add(
                            Marker(
                              markerId: const MarkerId('currentLocation'),
                              position:
                                  LatLng(position.latitude, position.longitude),
                            ),
                          );
                          setState(() {});
                        },
                        child: Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onMapCreated(controller) {
    setState(() {
      googleMapController = controller;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }
}
