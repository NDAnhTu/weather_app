// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  int mua_1;
  int mua_2;
  int mua_3;
  MapPage({
    required this.mua_1,
    required this.mua_2,
    required this.mua_3,
  });
  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  // ignore: prefer_final_fields
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(10.816091, 106.7696557),
    zoom: 17.5,
  );

  static final CameraPosition _school = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(10.8507289, 106.7719957),
      tilt: 59.440717697143555,
      zoom: 15);

  static final CameraPosition _home = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(10.816091, 106.7696557),
      tilt: 59.440717697143555,
      zoom: 15);

  static final CameraPosition _cty = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(10.7956443, 106.6746161),
      tilt: 59.440717697143555,
      zoom: 15);

  @override
  void initState() {
    addMarkers();
    _goHome();
    super.initState();
  }

  addMarkers() async {
    BitmapDescriptor markerbitmap_nang = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/m1.png",
    );
    BitmapDescriptor markerbitmap_mua = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/m2.png",
    );

    markers.add(Marker(
      markerId: MarkerId(LatLng(10.816091, 106.7696557).toString()),
      position: LatLng(10.816091, 106.7696557), //position of marker
      infoWindow: InfoWindow(
        title: 'Chung cư TDH Phước Bình',
        snippet: 'Thành phố Thủ Đức',
      ),
      icon: widget.mua_1 == 0
          ? markerbitmap_nang
          : markerbitmap_mua, //Icon for Marker
    ));

    markers.add(Marker(
      markerId: MarkerId(LatLng(10.8507289, 106.7719957).toString()),
      position: LatLng(10.8507289, 106.7719957), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Đại học Sư Phạm Kĩ Thuật',
        snippet: 'Thành phố Thủ Đức',
      ),
      icon: widget.mua_2 == 0
          ? markerbitmap_nang
          : markerbitmap_mua, //Icon for Marker
    ));
    markers.add(Marker(
      markerId: MarkerId(LatLng(10.7956443, 106.6746161).toString()),
      position: LatLng(10.7956443, 106.6746161), //position of marker
      infoWindow: InfoWindow(
        title: 'Cty TNHH SMARTNET',
        snippet: 'Phú Nhuận, Thành phố Hồ Chí Minh',
      ),
      icon: widget.mua_3 == 0
          ? markerbitmap_nang
          : markerbitmap_mua, //Icon for Marker
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _w = MediaQuery.of(context).size.width;
    double _h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: _h / 1.5,
            right: _w / 20,
            child: Container(
              width: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _gotoCty();
                    },
                    child: Text('Company'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _gotoSchool();
                    },
                    child: Text('School'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _goHome();
                    },
                    child: Text('Home'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _gotoSchool() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_school));
  }

  Future<void> _goHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_home));
  }

  Future<void> _gotoCty() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_cty));
  }
}
