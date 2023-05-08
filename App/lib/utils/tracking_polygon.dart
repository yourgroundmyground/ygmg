import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 수집한 위치 정보로 다각형만들기 시도 중...
// 다각형은 만들어지지만 안의 색이 변하지 않음
class TrackingPolygon extends StatefulWidget {
  const TrackingPolygon({Key? key}) : super(key: key);

  @override
  State<TrackingPolygon> createState() => _TrackingPolygonState();
}

class _TrackingPolygonState extends State<TrackingPolygon> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _points = [];
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  bool isWalking = false;
  bool isFinish = false;
  final _accelerometerValues = <double>[0, 0, 0];
  final _userAccelerometerValues = <double>[0, 0, 0];
  final _gyroscopeValues = <double>[0, 0, 0];
  SharedPreferences? prefs;
  // Timer? _locationTimer;

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
    SharedPreferences.getInstance().then((SharedPreferences sharedPreferences) {
      prefs = sharedPreferences;
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
        // _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
        // LatLng newLocation = LatLng(location.latitude!, location.longitude!);
        // Polyline route = Polyline(
        //   polylineId: PolylineId('route1'),
        //   points: [..._polylines.first.points, newLocation],
        //   width: 5,
        //   color: Colors.blue,
        // );
        LatLng newLocation = LatLng(location.latitude!, location.longitude!);
        if (_points.isNotEmpty) {
          LatLng lastLocation = _points.last;
          if (lastLocation.latitude == newLocation.latitude &&
              lastLocation.longitude == newLocation.longitude) {
            // 위치가 변경되지 않았으면 중복 값을 추가하지 않습니다.
            return;
          }
        }
        setState(() {
          _points.add(newLocation); // _points 리스트 업데이트
          _savePoints(); // _points 저장

          Polyline route = Polyline(
            polylineId: PolylineId('route1'),
            points: [..._polylines.first.points, newLocation],
            width: 5,
            color: Colors.blue,
          );
          _polylines = {_polylines.first, route};
          currentLocation = location;
          _markers = {
            Marker(
              markerId: MarkerId('current'),
              icon: currentLocationIcon,
              position: newLocation,

            ),
          };
          // _points.add(newLocation); // _points 리스트 업데이트
          // _savePoints(); // _points 저장
        });
        _loadPoints();
      }
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

  // 다각형 생성 - 다각형, 다각형 안의 마커
  void _onPolygonCreated(Set<Polygon> polygons) {
    print('이제 다각형을 만들거예요');
    LatLng center = findPolygonCenter(_points);
    // LatLng center = findPolygonCenter([LatLng(35.2051205, 126.8116811), LatLng(35.2051147, 126.8116459), LatLng(35.2051522, 126.8116607), LatLng(35.2051534, 126.8116587), LatLng(35.2051526, 126.8116458), LatLng(35.2051459, 126.8116281), LatLng(35.2051564, 126.8115957), LatLng(35.2051682, 126.8115753), LatLng(35.2051978, 126.81154), LatLng(35.2052461, 126.8114945), LatLng(35.2052722, 126.8114794), LatLng(35.205295, 126.8114691), LatLng(35.2053052, 126.8114564), LatLng(35.2053247, 126.8114475), LatLng(35.2053539, 126.8114448), LatLng(35.2053727, 126.8114486), LatLng(35.205395, 126.8114547), LatLng(35.2054234, 126.8114613), LatLng(35.2054932, 126.8115306), LatLng(35.2055264, 126.8116026), LatLng(35.2054981, 126.8115984), LatLng(35.2054439, 126.8116201), LatLng(35.2053836, 126.8116399), LatLng(35.2053173, 126.8116604), LatLng(35.2052645, 126.8116918), LatLng(35.2052134, 126.8117058), LatLng(35.2051926, 126.8117058), LatLng(35.205178, 126.8117015), LatLng(35.2051708, 126.811692), LatLng(35.2051968, 126.8115868), LatLng(35.2052249, 126.811472)]);
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    setState(() {
      _polygons.add(
      Polygon(
        polygonId: PolygonId("mypolygon"),
        // points: [LatLng(35.2051205, 126.8116811), LatLng(35.2051147, 126.8116459), LatLng(35.2051522, 126.8116607), LatLng(35.2051534, 126.8116587), LatLng(35.2051526, 126.8116458), LatLng(35.2051459, 126.8116281), LatLng(35.2051564, 126.8115957), LatLng(35.2051682, 126.8115753), LatLng(35.2051978, 126.81154), LatLng(35.2052461, 126.8114945), LatLng(35.2052722, 126.8114794), LatLng(35.205295, 126.8114691), LatLng(35.2053052, 126.8114564), LatLng(35.2053247, 126.8114475), LatLng(35.2053539, 126.8114448), LatLng(35.2053727, 126.8114486), LatLng(35.205395, 126.8114547), LatLng(35.2054234, 126.8114613), LatLng(35.2054932, 126.8115306), LatLng(35.2055264, 126.8116026), LatLng(35.2054981, 126.8115984), LatLng(35.2054439, 126.8116201), LatLng(35.2053836, 126.8116399), LatLng(35.2053173, 126.8116604), LatLng(35.2052645, 126.8116918), LatLng(35.2052134, 126.8117058), LatLng(35.2051926, 126.8117058), LatLng(35.205178, 126.8117015), LatLng(35.2051708, 126.811692), LatLng(35.2051968, 126.8115868), LatLng(35.2052249, 126.811472),],
        points: _points,
        fillColor: Colors.red,
        strokeColor: Colors.blue,
        strokeWidth: 2,
      ));
      // 마커 클릭시 하단시트 모달로 프로필, 닉네임 보여주기
      _markers.add(
        Marker(
          markerId: MarkerId("marker-id"),
          position: center,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: mediaHeight*0.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: mediaWidth*0.1),
                      Container(
                        width: mediaWidth*0.2,
                        height: mediaWidth*0.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            "assets/images/runningbgi.png",    // *사용자 프로필 이미지
                            height: mediaWidth*0.2,
                            width: mediaWidth*0.2,
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                      Text("닉네임", style: TextStyle(fontSize: mediaWidth*0.04)),
                      SizedBox(width: mediaWidth*0.1),
                    ],
                  ),
                );
              },
            );
          },
        )
      );
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
        polygons: _polygons,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isWalking = !isWalking;
            if (isWalking == false) {
              print('끝났어요');
              isFinish = true;
              _onPolygonCreated(_polygons);
            }
          });
        },
        child: Icon(isWalking ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
