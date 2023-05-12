import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:math';


class PolygonMap extends StatefulWidget {
  const PolygonMap({Key? key}) : super(key: key);

  @override
  State<PolygonMap> createState() => PolygonMapState();
}
Future<String> loadMapStyle() async {
  return await rootBundle.loadString('assets/style/map_style.txt');
}


class PolygonMapState extends State<PolygonMap> {
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

  static final Marker _kGooglePlexMarker01 = Marker(
      markerId: MarkerId('_kGooglePlex'),
      infoWindow: InfoWindow(title: 'hs'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(35.217200,126.812903)
  );

  static final Marker _kGooglePlexMarker02 = Marker(
      markerId: MarkerId('_kGooglePlex2'),
      infoWindow: InfoWindow(title: 'hs2'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(35.218635,126.813250)
  );

  static final Marker _kGooglePlexMarker03 = Marker(
      markerId: MarkerId('_kGooglePlex3'),
      infoWindow: InfoWindow(title: 'hs3'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(35.218217,126.812091)
  );

  static final Polyline _kPolyline = Polyline(
    polylineId: PolylineId('_kPolyline'),
    points: [
      LatLng(35.217200,126.812903),
      LatLng(35.218635,126.813250)
    ],
  );

  static final Polygon _kPolygon = Polygon(
      polygonId: PolygonId('_kPolygon'),
      points: [LatLng(35.218635,126.813250),LatLng(35.217200,126.812903),LatLng(35.218217,126.812091)],
      strokeWidth: 5,
      fillColor: Colors.amber.withOpacity(0.5)
  );

  static final Polygon _kPolygon2 = Polygon(
      polygonId: PolygonId('_kPolygon2'),
      points: [LatLng(35.218024,126.812971),LatLng(35.219321,126.812198),LatLng(35.218410,126.810868)],
      strokeWidth: 5,
      fillColor: Colors.redAccent.withOpacity(0.5)
  );

  static final Polygon _kPolygon3 = Polygon(
      polygonId: PolygonId('_kPolygon3'),
      points: [LatLng(35.217428,126.810632),LatLng(35.215783,126.810876),LatLng(35.218596,126.815315)],
      strokeWidth: 5,
      fillColor: Colors.blue.withOpacity(0.5)
  );




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
    final points = _kPolygon.points.map((latLng) => Point(latLng.latitude, latLng.longitude)).toList();
    final polygonArea = SphericalUtils.computeArea(points);
    // final polygonArea = SphericalUtils.computeArea(_kPolygon.points);
    print(' 폴리곤 에어리어1 : ${polygonArea}');

    final points2 = _kPolygon2.points.map((latLng) => Point(latLng.latitude, latLng.longitude)).toList();
    final polygonArea2 = SphericalUtils.computeArea(points2);
    print(' 폴리곤 에어리어2 : ${polygonArea2}');

    final points3 = _kPolygon3.points.map((latLng) => Point(latLng.latitude, latLng.longitude)).toList();
    final polygonArea3 = SphericalUtils.computeArea(points3);
    print(' 폴리곤 에어리어2 : ${polygonArea3}');






    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: { _kGooglePlexMarker01,_kGooglePlexMarker02, _kGooglePlexMarker03},
        // polylines: {
        //   _kPolyline
        // },
        polygons: {
          _kPolygon,
          _kPolygon2,
          _kPolygon3
        },
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
