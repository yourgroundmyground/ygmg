import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

class DrawPolygon extends StatefulWidget {
  const DrawPolygon({Key? key}) : super(key: key);

  @override
  State<DrawPolygon> createState() => _DrawPolygonState();
}
Future<String> loadMapStyle() async {
  return await rootBundle.loadString('assets/style/map_style.txt');
}

class _DrawPolygonState extends State<DrawPolygon> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  // 실시간 위치를 표시할 좌표 리스트와 폴리라인
  List<LatLng> _currentPoints = [];
  Set<Polyline> _currentPolylines = {};
  // 영역이 형성되면 해당 좌표의 리스트 저장할 리스트
  List<LatLng> _points = [];
  List<List> _pointsSets = [];
  List<Set> _polygonSets = [];
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  bool isWalking = false;
  final _accelerometerValues = <double>[0, 0, 0];
  final _userAccelerometerValues = <double>[0, 0, 0];
  final _gyroscopeValues = <double>[0, 0, 0];
  var customMapStyle;
  Polygon? _polygon;
  var area = 0.0;

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
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
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
        _currentPoints.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        LatLng newLocation = LatLng(location.latitude!, location.longitude!);
        Polyline route = Polyline(
          polylineId: PolylineId('route1'),
          points: [..._currentPolylines.first.points, newLocation],
          width: 5,
          color: Colors.blue,
        );
        setState(() {
          _currentPolylines = {_currentPolylines.first, route};
          currentLocation = location;
          _markers = {
            Marker(
              markerId: MarkerId('current'),
              icon: currentLocationIcon,
              position: newLocation,
            ),
          };
          }
        );
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
          points: _currentPoints,
          width: 5,
          color: Colors.blue,
        ),
      };
    });
  }

  void calculate() {
    final points = _points.map((latLng) => Point(latLng.latitude, latLng.longitude)).toList();
    if (points.isNotEmpty) {
      final distance = _distanceBetweenFirstAndLastPoint();
      if (distance <= 50) {
        final polyline = Polyline(
          polylineId: PolylineId('myPolyline${_polylines.length}'),
          points: _points,
          width: 2,
          color: Colors.red,
        );
        _polylines.add(polyline);
        _pointsSets.add(_points);
        _polygon = Polygon(
          polygonId: PolygonId('myPolygon'),
          points: _points,
          fillColor: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
          strokeColor: Colors.red,
        );
        final polygonArea = SphericalUtils.computeArea(points);
        print('점들 : ${points}');
        print('면적 : ${_polygon}');
        area = area + polygonArea;
        print(area);
      }
      _points = [];
      _currentPoints = [];
      _currentPolylines = {};

    } else {
      print('영역이 생성되지 않았습니다.');
    }
  }

  double _distanceBetweenFirstAndLastPoint() {
    if (_points.length < 2) {
      return double.infinity;
    }

    final first = _points.first;
    final last = _points.last;
    final firstPoint = Point(first.latitude, first.longitude);
    final lastPoint = Point(last.latitude, last.longitude);
    return SphericalUtils.computeDistanceBetween(firstPoint, lastPoint);
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${area}'),
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
        polygons:  _polygon != null ? {_polygon!} : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isWalking = !isWalking;
          });
          calculate();
        },
        child: Icon(isWalking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }}