import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DrawLines extends StatefulWidget {
  const DrawLines({Key? key}) : super(key: key);

  @override
  _DrawLinesState createState() => _DrawLinesState();
}

class _DrawLinesState extends State<DrawLines> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  List<LatLng> _points = [];

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

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

    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _currentPosition = currentLocation;
        _points.add(LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.5665, 126.9780),
      zoom: 14,
    );

    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        polylines: {
          Polyline(
            polylineId: PolylineId("polyline"),
            color: Colors.blue,
            width: 5,
            points: _points,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
