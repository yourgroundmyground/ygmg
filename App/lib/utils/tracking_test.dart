import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';

class TrackingTest extends StatefulWidget {
  const TrackingTest({Key? key}) : super(key: key);

  @override
  State<TrackingTest> createState() => _TrackingTestState();
}

class _TrackingTestState extends State<TrackingTest> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _points = [];
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  bool isWalking = false;
  final _accelerometerValues = <double>[0, 0, 0];
  final _userAccelerometerValues = <double>[0, 0, 0];
  final _gyroscopeValues = <double>[0, 0, 0];

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(100, 100)), "assets/images/testProfile.png")
      .then(
        (icon) {
          setState(() {
            currentLocationIcon = icon;
            }
          );
        },
      );
  }

  @override
  void initState() {
    getLocation();
    setCustomMarkerIcon();
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerValues[0] = event.x;
        _accelerometerValues[1] = event.y;
        _accelerometerValues[2] = event.z;
      });
    });
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _userAccelerometerValues[0] = event.x;
        _userAccelerometerValues[1] = event.y;
        _userAccelerometerValues[2] = event.z;
      });
    });
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscopeValues[0] = event.x;
        _gyroscopeValues[1] = event.y;
        _gyroscopeValues[2] = event.z;
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  void getLocation() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = location.onLocationChanged.listen((location) {
      if (currentLocation == null) {
        setState(() {
          currentLocation = location;
        });
        _onMapCreated(mapController);
      } else {
        if (isWalking == false) {
          setState(() {
            currentLocation = location;
          });
          return;
        }
        _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        LatLng newLocation = LatLng(location.latitude!, location.longitude!);
        Polyline route = Polyline(
          polylineId: PolylineId('route1'),
          points: [..._polylines.first.points, newLocation],
          width: 5,
          color: Colors.blue,
        );
        setState(() {
          _polylines = {_polylines.first, route};
          currentLocation = location;
          _markers = {
            Marker(
              markerId: MarkerId('current'),
              icon: currentLocationIcon,
              position: newLocation,

            ),
          };
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId('current'),
          position: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
          rotation: _gyroscopeValues[2], // 기울기 각도
          anchor: Offset(0.5, 0.5), // 마커 중심점 설정
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //   // BitmapDescriptor.hueBlue,
          //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/images/testProfile.png")
          // ),
          icon: currentLocationIcon
        ),
      };
      _polylines = {
        Polyline(
          polylineId: PolylineId('route1'),
          points: _points,
          width: 5,
          color: Colors.blue,
        ),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tracking Test'),
        ),
        body: currentLocation == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            zoom: 17.0,
          ),
          // myLocationEnabled: true,
          markers: _markers,
          polylines: _polylines,
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isWalking = !isWalking;
          });
        },
        child: Icon(isWalking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }}