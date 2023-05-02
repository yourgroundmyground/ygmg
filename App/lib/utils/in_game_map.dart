import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter/services.dart' show rootBundle;

class InGameMap extends StatefulWidget {
  @override
  _InGameMap createState() => _InGameMap();
}

Future<String> loadMapStyle() async {
  return await rootBundle.loadString('assets/style/map_style.txt');
}

class _InGameMap extends State<InGameMap> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  var customMapStyle;
  List<LatLng> _route = [];
  Set<Polyline> _polylines = {};
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  bool isWalking = false;

  @override
  void initState() {
    getLocation();
    super.initState();
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
    accelerometerEvents.listen(_onAccelerometerChanged);
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
        LatLng newLocation = LatLng(location.latitude!, location.longitude!);
        Polyline route = Polyline(
          polylineId: PolylineId('route1'),
          points: [..._route, newLocation],
          width: 5,
          color: Colors.blue,
        );
        setState(() {
          _route = [..._route, newLocation];
          _polylines = {..._polylines, route};
          currentLocation = location;
        });
      }
    });
  }

  void getLocation() async {
    Location location = Location();

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
    // // 위치 업데이트 정확도를 최고로 설정합니다.
    // location.changeSettings(
    //   accuracy: LocationAccuracy.high,
    //   interval: 1000, // 1초마다 위치 업데이트
    // );

    // currentLocation = await location.getLocation();
    // _route.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));

    location.getLocation().then(
        (location) {
          currentLocation = location;
        }
    );

    setState(() {});

    // location.onLocationChanged.listen(_onLocationChanged);
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
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
        myLocationEnabled: true,
        markers: {
          Marker(markerId: const MarkerId('current'),
            position: LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
          )
        },
        polylines: _polylines,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    controller.setMapStyle(customMapStyle);
    setState(() {
      _polylines = {
        Polyline(
          polylineId: PolylineId('route1'),
          points: _route,
          width: 5,
          color: Colors.blue,
        ),
      };
    });
  }

  void _onAccelerometerChanged(AccelerometerEvent event) {
    final double x = event.x;
    final double y = event.y;
    final double z = event.z;

    if (isWalking == false && y > 10) {
      setState(() {
        isWalking = true;
      });
    } else if (isWalking == true && y < 8) {
      setState(() {
        isWalking = false;
      });
    }

    if (isWalking == true) {
      if (currentLocation != null && currentLocation!.latitude != null && currentLocation!.longitude != null) {
        LatLng newLocation = LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
        setState(() {
          _route.add(newLocation);
        });

        Polyline route = Polyline(
          polylineId: PolylineId('route1'),
          points: _route,
          width: 5,
          color: Colors.blue,
        );
        setState(() {
          _polylines.add(route);
        });
      }
    }
  }

  // void _onLocationChanged(LocationData currentLocation) {
  //   if (currentLocation.latitude != null && currentLocation.longitude != null) {
  //     if (currentLocation.speed != null && currentLocation.speed! > 0.0) {
  //       // 위치가 이동한 경우
  //       setState(() {
  //         _route.add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
  //       });
  //
  //       Polyline route = Polyline(
  //         polylineId: PolylineId('route1'),
  //         points: _route,
  //         width: 5,
  //         color: Colors.blue,
  //       );
  //       setState(() {
  //         _polylines.add(route);
  //       });
  //
  //       _onAccelerometerChanged(AccelerometerEvent(currentLocation.speed!, currentLocation.speed!, currentLocation.speed!));
  //     }
  //   }
  // }
}
