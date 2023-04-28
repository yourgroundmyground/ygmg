import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }


class MapSampleState extends State<MapSample> {
  Location location = new Location();

  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  LocationData? _locationData;



  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  var customMapStyle;

  @override
  void initState() {
    super.initState();
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // final cameraPosition = _locationData != null
    //     ? CameraPosition(target: LatLng(_locationData!.latitude!, _locationData!.longitude!), zoom: 14.4746)
    //     : _kGooglePlex;

    void getLocation() async {
      final location = Location();
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
      setState(() {});
      var lat = _locationData?.latitude ?? 0;
      var long = _locationData?.longitude ?? 0;
    }

    void _currentLocation() async {
      final GoogleMapController controller = await _controller.future;
      LocationData? currentLocation;
      var location = new Location();
      try {
        currentLocation = await location.getLocation();
      } on Exception {
        currentLocation = null;
      }
      LatLng target = LatLng(
        currentLocation?.latitude ?? 35.2051965,
        currentLocation?.longitude ?? 126.8117383,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: target,
          zoom: 20.0,
        ),
      ));
    }

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          bearing: 0,
          target: LatLng(35.2051965, 126.8117383),
          zoom: 14.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          controller.setMapStyle(customMapStyle);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _currentLocation();
        },
        label: const Text('내 위치로!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}
