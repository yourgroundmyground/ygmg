import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../const/state_provider_token.dart';

class DrawPolygonState extends State<DrawPolygon> {
  var _tokenInfo;

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  // 실시간 위치를 표시할 좌표 리스트와 폴리라인
  List<LatLng> _currentPoints = [];
  Set<Polyline> _currentPolylines = {};

  // 영역이 형성되면 해당 좌표의 리스트 저장할 리스트
  List<LatLng> _points = [];
  // 폴리곤 저장
  Set<Polygon> _polygonSets = {};
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  Stream<bool> drawGroundStream = StreamController<bool>().stream;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  final _gyroscopeValues = <double>[0, 0, 0];
  var customMapStyle;
  Polygon? _polygon;
  var area = 0.0;
  var computedArea = 0.0;
  var isCompleted = false;
  var gameId = '';

  // 프로필 이미지 가져오기
  var memberIdString;

  // 영역 보내기 post 요청 관련 변수

  // 땅따먹기 기록


  // 달리기 기록
  bool _isLocationServiceEnabled = false;
  late PermissionStatus _permissionStatus;
  LocationData? _previousLocationData;
  late DateTime runningStart;
  // *달린 속도 변경
  double runningPace = 0.0;
  double runningPaceKm = 0.0;

  // *달린 거리 변경
  double runningDist = 0.0;

  // *달린 시간 변경
  Duration runningDuration = Duration.zero;

  // *태운 칼로리 변경
  double runningKcal = 0.0;
  double _distance = 0.0;
  double _currentSpeed = 0.0;

  final List<Map<String, dynamic>> _polygonList = [];

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
        // runninglocationList = List<Map<String, dynamic>>.from(locationList.map((coord) => {'coordinateTime': coord['coordinateTime'], 'lat': coord['latitude'], 'lng': coord['longitude']}));
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
    _loadTokenInfo();
    setupTimer();
    getLocation();
    getPolygons();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  //dio 요청

//  게임아이디 요청
  void getPolygons() async {
    var dio = Dio();
    try {
      print('gameId 가져오기');
      var gameid = await dio.get('http://k8c107.p.ssafy.io/api/game/gameId');
      var response = await dio.get('http://k8c107.p.ssafy.io/api/game/area/game/${gameid}');
      print(response.data);
      List<int> memberIds = [];
      response.data.forEach((entry) {
        int memberId = int.parse(entry['memberId'].toString());
        if (!memberIds.contains(memberId)) {
          memberIds.add(memberId);
        }
      });
      memberIdString = memberIds.join(',');
      print('멤버들.. $memberIdString');
      var profileresponse = await dio.get('http://k8c107.p.ssafy.io/api/member/profiles?memberList=${memberIdString}');
      print(profileresponse);
      setState(() {
        addPolygon(response.data, profileresponse);
      });
    } catch (e) {
      print('왜이럼');
      print(e.toString());
    }
  }

  // post 요청
  void sendGameData(
      int memberId,
      double runningDist,
      String runningEnd,
      double runningKcal,
      double runningPace,
      String runningStart,
      Duration runningDuration,
      String gameId,
      String areaDate,
      double areaSize,
      List<Map<String, dynamic>> areaCoordinateDtoList)
       async {
    try {
      var dio = Dio();
      print('백에 보낸당!');
      var response = await dio.post('http://k8c107.p.ssafy.io/api/game/coordinate/',
          data: {
            "memberId": _tokenInfo.memberId,   // *회원 아이디 넣기
            'runningDistance': runningDist,
            "runningEnd": runningEnd,
            'runningKcal': runningKcal,
            'runningPace': runningPace,
            'runningStart': runningStart,
            'runningTime': runningDuration,
            "gameId" : gameId,
            "areaDate" : areaDate,
            // "areaSize" : 333.3333,
            "areaCoordinateDtoList" : areaCoordinateDtoList
          },
          options: Options(
            headers: {
              // 'Authorization': 'Bearer $token',    // *토큰 넣어주기
            },
          ));
      print(response.data);
    } catch (e) {
      print(e.toString());
    }
  }

  // 받아온 폴리곤 추가

  void addPolygon(polygonData, memberData) {
    final mediaWidth = MediaQuery
        .of(context)
        .size
        .width;
    final mediaHeight = MediaQuery
        .of(context)
        .size
        .height;
    for (var data in polygonData) {
      List<LatLng> points = [];

      for (var coordinate in data['coordinateList']) {
        double lat = coordinate['areaCoordinateLat'];
        double lng = coordinate['areaCoordinateLng'];
        points.add(LatLng(lat, lng));
      }

      Polygon polygon = Polygon(
        polygonId: PolygonId(data['areaId'].toString()),
        points: points,
        fillColor: Colors.red.withOpacity(0.5),
        strokeWidth: 2,
        strokeColor: Colors.red,
      );

      _polygonSets.add(polygon);

      String getProfileUrl(int memberId) {
        final member = data.firstWhere((member) => member['memberId'] == memberId, orElse: () => null);
        if (member != null) {
          return member['profileUrl'];
        }
        return ''; // memberId에 해당하는 객체를 찾을 수 없는 경우 null을 반환
      }
      String getNickname(int memberId) {
        final member = data.firstWhere((member) => member['memberId'] == memberId, orElse: () => null);
        if (member != null) {
          return member['memberNickname'];
        }
        return ''; // memberId에 해당하는 객체를 찾을 수 없는 경우 null을 반환
      }
      _markers.add(
          Marker(
            markerId: MarkerId(data['areaId'].toString()),
            position: findPolygonCenter(points),
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
                              child: Image.network(
                                "${getProfileUrl(data['memberId'])}",
                                // *사용자 프로필 이미지
                                height: mediaWidth * 0.2,
                                width: mediaWidth * 0.2,
                                fit: BoxFit.cover,
                              ),
                            )
                        ),
                        Text("${getNickname(data['memberId'])}", style: TextStyle(
                            fontSize: mediaWidth * 0.04)),
                        SizedBox(width: mediaWidth * 0.1),
                        Text("${data['areaDate']}", style: TextStyle(
                            fontSize: mediaWidth * 0.04)),
                      ],
                    ),
                  );
                },
              );
            },

        )
      );
    }
    return polygonData;
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


  // 폴리곤의 자기교차 여부 판단
  bool isNotSimplePolygon(List<LatLng> polygon){
    if(polygon.length <= 3)
      return false;

    for(int i = 0; i < polygon.length - 2; i++){
      double x1 = polygon[i].latitude;
      double y1 = polygon[i].longitude;
      double x2 = polygon[i + 1].latitude;
      double y2 = polygon[i + 1].longitude;

      double maxx1 = max(x1, x2), maxy1 = max(y1, y2);
      double minx1 = min(x1, x2), miny1 = min(y1, y2);

      for (int j = i + 2; j < polygon.length; j++) {
        double x21 = polygon[j].latitude;
        double y21 = polygon[j].longitude;
        double x22 = polygon[(j + 1) == polygon.length ? 0 : (j + 1)].latitude;
        double y22 = polygon[(j + 1) == polygon.length ? 0 : (j + 1)].longitude;

        double maxx2 = max(x21, x22), maxy2 = max(y21, y22);
        double minx2 = min(x21, x22), miny2 = min(y21, y22);

        if ((x1 == x21 && y1 == y21) || (x2 == x22 && y2 == y22) || (x1 == x22 && y1 == y22) || (x2 == x21 && y2 == y21))
          continue;

        if (minx1 > maxx2 || maxx1 < minx2 || miny1 > maxy2 || maxy1 < miny2)
          continue;  // The moment when the lines have one common vertex...


        double dx1 = x2-x1, dy1 = y2-y1; // The length of the projections of the first line on the x and y axes
        double dx2 = x22-x21, dy2 = y22-y21; // The length of the projections of the second line on the x and y axes
        double dxx = x1-x21, dyy = y1-y21;

        double div = dy2 * dx1 - dx2 * dy1;
        double mul1 = dx1 * dyy - dy1 * dxx;
        double mul2 = dx2 * dyy - dy2 * dxx;

        if (div == 0)
          continue; // Lines are parallel...

        if (div > 0) {
          if (mul1 < 0 || mul1 > div)
            continue; // The first segment intersects beyond its boundaries...
          if (mul2 < 0 || mul2 > div)
            continue; // // The second segment intersects beyond its borders...
        }
        else{
          if (-mul1 < 0 || -mul1 > -div)
            continue; // The first segment intersects beyond its boundaries...
          if (-mul2 < 0 || -mul2 > -div)
            continue; // The second segment intersects beyond its borders...
        }
        return true;
      }
    }
    return false;
  }
  // 매일 달리기 한 번 제한
  void setupTimer() {
    // 현재 시간과 자정 사이의 지연 시간 계산
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final duration = midnight.difference(now);

    // 자정에 작업 수행
    Timer(duration, () {
      // 변수의 값을 변경
      isCompleted = false;
      print('변수가 변경되었습니다!');
    });
  }

  // 폴리곤 면적 계산
  void calculate() {
    print(_currentPoints);
    if (isCompleted) {
      print('면적만들기 실행');
      LatLng center = findPolygonCenter(_points);
      final mediaWidth = MediaQuery
          .of(context)
          .size
          .width;
      final mediaHeight = MediaQuery
          .of(context)
          .size
          .height;

      final points = _points.map((latLng) =>
          Point(latLng.latitude, latLng.longitude)).toList();
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
            // List<dynamic> convertPoints = List<Map<String, dynamic>>.from(_points.map((coord) => {'coordinateTime': coord['coordinateTime'], 'lat': coord['latitude'], 'lng': coord['longitude']}))
            // _polygonList.add(convertPoints);
          });
          computedArea = SphericalUtils.computeSignedArea(points);
          // if(SphericalUtils.computeSignedArea(points) > 0){
          final polygonId = PolygonId('polygon${_polygonSets.length + 1}');
          _polygon = Polygon(
            polygonId: polygonId,
            points: _currentPoints,
            fillColor: Colors.red.withOpacity(0.5),
            strokeWidth: 2,
            strokeColor: Colors.red,
          );
          if (!isNotSimplePolygon(_currentPoints)) {
            _onCustomAnimationAlertPressed(context);
            _points = [];
            _currentPoints = [];
            _currentPolylines = {};
            // widget.isWalking = false;
            print('영역 생성 실패');
          } else {
            _polygonSets.add(_polygon!);
            print('성공');
            _markers.add(
                Marker(
                  markerId: MarkerId('marker${_markers.length + 1}'),
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
            final polygonArea = SphericalUtils.computeArea(points);
            print('면적테스트');
            print('${polygonArea}');
            print('점들 : ${points}');
            print('면적 : ${_polygon}');
            area = area + polygonArea;
            print(area);
            LatLng lastLatLng = _polygonSets.last.points.first;
            print(_polygonSets.length);
            print('last polygon, first point - latitude: ${lastLatLng
                .latitude}, longitude: ${lastLatLng.longitude}');
            sendGameData(
                _tokenInfo.memberId,
                runningDist,
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                runningKcal,
                runningPace,
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                // widget.currentTime,
                runningDuration,
                gameId,
                DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                area,
                _polygonList
            );
            isCompleted = true;
          }
        }
        _points = [];
        _currentPoints = [];
        _currentPolylines = {};
      } else {
        print('영역이 생성되지 않았습니다.');
        _onCustomAnimationAlertPressed(context);
      }
    } else {
      print('오늘 영역 생성 끝');
      }
    }
  void resetPoints() {
    setState(() {
      _points = []; // points 변수 초기화
      _currentPoints = [];
      _currentPolylines = {};
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

  // 러닝 데이터 수집 함수

  // gps 측정으로 변경
  Future<void> _checkLocationService() async {
    _isLocationServiceEnabled = await location.serviceEnabled();
    if (!_isLocationServiceEnabled) {
      _isLocationServiceEnabled = await location.requestService();
      if (!_isLocationServiceEnabled) {
        return;
      }
    }

    _permissionStatus = await location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
          _updateRunningInfo(locationData);
        });
  }

  void _updateRunningInfo(LocationData locationData) {
    if (_previousLocationData == null) {
      _previousLocationData = locationData;
      return;
    }

    Point<num> previousPoint = Point(
      _previousLocationData!.latitude!,
      _previousLocationData!.longitude!,
    );
    Point<num> currentPoint = Point(
      locationData.latitude!,
      locationData.longitude!,
    );
    double distanceInMeters = SphericalUtils.computeDistanceBetween(
      previousPoint,
      currentPoint,
    );

    // 위치 보정 전
    _distance += distanceInMeters / 1000; // 단위: km

    double timeInSeconds =
        (locationData.time! - _previousLocationData!.time!) / 1000.0;
    _currentSpeed = distanceInMeters / timeInSeconds * 3.6; // 단위: km/hr

    double calculateRunningKcal(double weight, Duration duration) {
      double runningMinutes = duration.inMinutes.toDouble();
      double runningKcal;

      if (runningDist == 0) {
        return 0;
      }

      runningKcal =
          (weight * 3.5 * runningMinutes * 4 / 1000) * 5; // *사용자 몸무게로 칼로리 측정
      print(runningKcal);
      return runningKcal;
    }
    setState(() {
      if (_currentSpeed >= 2.0) {
        runningDist = _distance;
        runningPace = _currentSpeed;
        runningKcal = calculateRunningKcal(_tokenInfo.memberWeight, runningDuration);
        _polygonList.add({
          "areaCoordinateLat": locationData.latitude!,
          "areaCoordinateLng": locationData.longitude!,
          "areaCoordinateTime": locationData.time!,
        });
      } else {
        runningPace = 0.0;
      }

    });
    // print(_locationList);
    _previousLocationData = locationData;
  }

  void _updateRunningTime(Timer timer) {
    // if (widget.isWalking) {
      setState(() {
        runningDuration += Duration(seconds: 1);
      });
    // }
  }

  String formatDuration(Duration duration) {
    var hours = duration.inHours.toString().padLeft(2, '0');
    var minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    var seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('${computedArea}'),
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
        tiltGesturesEnabled: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
          });
          // if (widget.isWalking) {
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
          // }
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
class DrawPolygon extends StatefulWidget {
  late bool? isWalking;
  final bool? drawGround;
  final currentTime;

  DrawPolygon(
      {this.isWalking,
        this.drawGround,
        this.currentTime,
          Key? key})
      : super(key: key);

  @override
  State<DrawPolygon> createState() => DrawPolygonState();
}

Future<String> loadMapStyle() async {
  return await rootBundle.loadString('assets/style/map_style.txt');
}