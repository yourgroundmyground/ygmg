import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';

class DrawPolygon extends StatefulWidget {
  final bool isWalking;
  final bool drawGround;

  const DrawPolygon(
      {required this.isWalking,
        required this.drawGround,
        Key? key})
      : super(key: key);

  @override
  State<DrawPolygon> createState() => DrawPolygonState();
}
Future<String> loadMapStyle() async {
  return await rootBundle.loadString('assets/style/map_style.txt');
}

class DrawPolygonState extends State<DrawPolygon> {
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
  StreamSubscription<bool>? _calculate;
  Stream<bool> drawGroundStream = StreamController<bool>().stream;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  final _gyroscopeValues = <double>[0, 0, 0];
  var customMapStyle;
  Polygon? _polygon;
  var area = 0.0;

  // 달리기 기록
  List<Map<String, dynamic>> runninglocationList = [];

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

  Future<void> _loadRunningData(double runningDist) async {
    SharedPreferences runningResult = await SharedPreferences.getInstance();
    SharedPreferences myTodayGoal = await SharedPreferences.getInstance();
    await myTodayGoal.setDouble('now', runningDist);  // 달린 거리 로컬에 저장
    final locationListJson = runningResult.getString('locationList');
    if (locationListJson != null) {
      final locationList = jsonDecode(locationListJson);
      setState(() {
        runninglocationList = List<Map<String, dynamic>>.from(locationList.map((coord) => {'coordinateTime': coord['coordinateTime'], 'lat': coord['latitude'], 'lng': coord['longitude']}));
      });
    }
  }

  @override
  void initState() {
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
    setupSubscription(widget.drawGround);
    getLocation();
    setCustomMarkerIcon();
    super.initState();

    // 달리기
    // _loadRunningData(widget.runningDist);
    // sendRunningData(
    //   runninglocationList,
    //   widget.runningStart,
    //   widget.runningEnd,
    //   widget.runningPace,
    //   widget.runningDist,
    //   widget.runningDuration,
    //   widget.runningKcal,
    // );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _calculate?.cancel();
    super.dispose();
  }

  //dio 요청
  void sendGameData(
      List<Map<String, dynamic>> runninglocationList,
      String runningStart,
      String runningEnd,
      double runningPace,
      double runningDist,
      String runningDuration,
      double runningKcal) async {
    try {
      var dio = Dio();
      print('백에 보낸당!');
      var response = await dio.post('http://k8c107.p.ssafy.io:8082/api/game/coordinate/',
          data: {
            "coordinateList": runninglocationList,
            "memberId": 6,   // *회원 아이디 넣기
            'runningDistance': runningDist,
            "runningEnd": runningEnd,
            'runningKcal': runningKcal,
            'runningPace': runningPace,
            'runningStart': runningStart,
            'runningTime': runningDuration,
          },
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',    // *토큰 넣어주기
            },
          ));
      print(response.data);
      // dio 통신이 성공하면 SharedPreferences에서 데이터 제거
      SharedPreferences gameResult = await SharedPreferences.getInstance();
      await gameResult.clear();
    } catch (e) {
      print(e.toString());
    }
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
        if (widget.isWalking == false) {
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
          _savePoints();
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
        });
        _loadPoints();
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

  void _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pointsJson = json.encode(_points);
    await prefs.setString('points', pointsJson);
  }

  void _loadPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? pointsJson = prefs.getString('points');
    if (pointsJson != null) {
      List<dynamic> loadedPoints = json.decode(pointsJson);
      List<LatLng> parsedPoints = loadedPoints
          .map((point) => LatLng(point[0] as double, point[1] as double))
          .toList();
      print('가져와용');
      print(parsedPoints);
    }
  }

  // 다각형의 중심점 구하기
  LatLng findPolygonCenter(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    latitude /= points.length;
    longitude /= points.length;

    return LatLng(latitude, longitude);
  }
  _onCustomAnimationAlertPressed(context) {
    Alert(
      context: context,
      title: "영역생성 실패!",
      desc: "경로가 모두 초기화됩니다.",
      alertAnimation: fadeAlertAnimation,
    ).show();
  }

  Widget fadeAlertAnimation(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
  void setupSubscription(bool drawGround) {
    _calculate = drawGroundStream.listen((drawGround) {
      if (drawGround) {
        calculate();
      }
    });
  }
  // 폴리곤 면적 계산
  void calculate() {
    print('면적만들기 실행');
    LatLng center = findPolygonCenter(_points);
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

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
        if(SphericalUtils.computeSignedArea(points) > 0){
          final polygonId = PolygonId('polygon${_polygonSets.length + 1}');
          _polygon = Polygon(
            polygonId: polygonId,
            points: _currentPoints,
            fillColor: Colors.red.withOpacity(0.5),
            strokeWidth: 2,
            strokeColor: Colors.red,
          );
        } else {
          print('Polygon is not filled with color.');
          _onCustomAnimationAlertPressed(context);
          _points = [];
          _currentPoints = [];
          _currentPolylines = {};

        }
        setState(() {
          if(SphericalUtils.computeSignedArea(points) > 0) {
            _polygonSets.add(_polygon!);
            _markers.add(
                Marker(
                  markerId: MarkerId("marker-id"),
                  position: center,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: mediaHeight * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: mediaWidth * 0.1),
                              Container(
                                  width: mediaWidth * 0.2,
                                  height: mediaWidth * 0.2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/images/runningbgi.png",
                                      // *사용자 프로필 이미지
                                      height: mediaWidth * 0.2,
                                      width: mediaWidth * 0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                              Text("닉네임", style: TextStyle(
                                  fontSize: mediaWidth * 0.04)),
                              SizedBox(width: mediaWidth * 0.1),
                            ],
                          ),
                        );
                      },

                    );
                  },

                )
            );
          }
        });

        final polygonArea = SphericalUtils.computeArea(points);
        print('면적테스트');
        print('${polygonArea}');
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
        tiltGesturesEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
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
          if (widget.isWalking) {
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
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}