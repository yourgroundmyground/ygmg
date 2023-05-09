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
  Set<Polygon> _polygonSets = {};
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  bool isWalking = false;
  final _gyroscopeValues = <double>[0, 0, 0];
  var customMapStyle;
  Polygon? _polygon;
  var area = 0.0;

  // 실시간 나의 위치 보여주는 프로필사진 마커
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
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  // 위치 가져오기
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

    // 위치 변동사항 체크
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

        // isWalking = true일 때
        _updateCurrentPolylines();
        setState(() {
          currentLocation = location;
        });
        setState(() {
          _currentPoints.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
          _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        });
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

  // 폴리곤이 만들어지고 다시 게임을 시작했을 때 나의 실시간 경로를 표시하는 함수
  void _updateCurrentPolylines() {
    _currentPoints.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
    Polyline route = Polyline(
      polylineId: PolylineId('route1'),
      points: _currentPoints,
      width: 5,
      color: Colors.blue,
    );
    setState(() {
      _currentPolylines = {route};
      _markers = {
        Marker(
          markerId: MarkerId('current'),
          icon: currentLocationIcon,
          position: LatLng(
            currentLocation!.latitude!,
            currentLocation!.longitude!,
          ),
        ),
      };
    });
  }

  // 폴리곤 면적 계산
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
        setState(() {
          _polylines.add(polyline);
          _pointsSets.add(_points);
        });
        _polygon = Polygon(
          polygonId: PolygonId('myPolygon'),
          points: _currentPoints,
          fillColor: Colors.red.withOpacity(0.5),
          strokeWidth: 2,
          strokeColor: Colors.red,
        );
        setState(() {
          _polygonSets.add(_polygon!);
        });
        final polygonArea = SphericalUtils.computeArea(points);
        print('점들 : ${points}');
        print('면적 : ${_polygon}');
        area = area + polygonArea;
        print(area);
        LatLng lastLatLng = _polygonSets.last.points.first;
        print(_polygonSets.length);
        print('last polygon, first point - latitude: ${lastLatLng.latitude}, longitude: ${lastLatLng.longitude}');

      }
      _points = [];
      _currentPoints = [];
      _currentPolylines = {};

    } else {
      print('영역이 생성되지 않았습니다.');
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // _polygonSets에 있는 모든 폴리곤을 지도에 추가합니다.
    // for (var polygon in _polygonSets) {
    //   _addPolygonToMap(polygon);
    // }
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
          icon: currentLocationIcon,
        ),
      };
      _currentPolylines = {
        Polyline(
          polylineId: PolylineId('route1'),
          points: _currentPoints,
          width: 5,
          color: Colors.blue,
        ),
      };
    });
  }
  // void _addPolygonToMap(Polygon polygon) {
  //   setState(() {
  //     _polygonSets.add(polygon);
  //   });
  // }
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

  // // Polygon 클리핑 함수
  // List<LatLng> clipPolygon(List<LatLng> polygon1, List<LatLng> polygon2) {
  //   List<LatLng> result = [];
  //   // polygon1의 좌표를 모두 추가
  //   for (int i = 0; i < polygon1.length; i++) {
  //     result.add(polygon1[i]);
  //   }
  //   // polygon1과 polygon2를 클리핑하여 중복된 좌표를 제거
  //   for (int i = 0; i < polygon2.length; i++) {
  //     if (isPointInsidePolygon(polygon1, polygon2[i])) {
  //       result.add(polygon2[i]);
  //     }
  //   }
  //   // 결과 polygon 반환
  //   return result;
  // }

  // Point가 Polygon 내부에 있는지 검사하는 함수
  bool isPointInsidePolygon(List<LatLng> polygon, LatLng point) {
    int intersections = 0;
    for (int i = 0; i < polygon.length; i++) {
      LatLng p1 = polygon[i];
      LatLng p2 = polygon[(i + 1) % polygon.length];
      if (p1.longitude > point.longitude == p2.longitude > point.longitude) {
        continue;
      }
      double x = (point.longitude - p1.longitude) * (p2.latitude - p1.latitude) /
          (p2.longitude - p1.longitude) +
          p1.latitude;
      if (x > point.latitude) {
        intersections++;
      }
    }
    return intersections % 2 == 1;
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
        polylines: _currentPolylines,
        polygons: _polygonSets,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isWalking = !isWalking;
          });
          calculate();
          // if (_polygonSets.isNotEmpty) {
          //   var polygonList = _polygonSets.toList();
          //   // 첫번째 폴리곤과 두번째 폴리곤이 겹치는지 검사
          //   if (isPointInsidePolygon(polygonList[0].points, polygonList[1].points[0])) {
          //     // 겹치는 영역을 클리핑
          //     final clippedPoints = clipPolygon(polygonList[0].points, polygonList[1].points);
          //     // 첫번째 폴리곤 업데이트
          //     polygonList[0] = polygonList[0].copyWith(pointsParam: clippedPoints);
          //   }
          // }
          if (isWalking) {
            // 현재 경로를 다시 그리기
            _currentPoints.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
            _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
            Polyline route = Polyline(
              polylineId: PolylineId('route1'),
              points: _currentPoints,
              width: 5,
              color: Colors.blue,
            );
            _currentPolylines = {
              route,
            };
            }
        },
        child: Icon(isWalking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }}