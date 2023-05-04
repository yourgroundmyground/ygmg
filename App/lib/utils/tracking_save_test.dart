import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sensors/sensors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// 5초마다 위치 정보 수집 후, 로컬 데이터저장소에 저장하는 코드
class TrackingSave extends StatefulWidget {
  const TrackingSave({Key? key}) : super(key: key);

  @override
  State<TrackingSave> createState() => _TrackingSaveState();
}

class _TrackingSaveState extends State<TrackingSave> {
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
  SharedPreferences? prefs;
  Timer? _locationTimer;

  // 커스텀 이미지 마커
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
    _locationTimer?.cancel();
    super.dispose();
  }

  // 위치 정보 수집
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

    _startLocationTimer();

    // 5초마다 수집이 아닌 위치변동 확인시 위치 수집
    // _locationSubscription = location.onLocationChanged.listen((location) {
    //   if (currentLocation == null) {
    //     setState(() {
    //       currentLocation = location;
    //     });
    //     _onMapCreated(mapController);
    //   } else {
    //     if (isWalking == false) {
    //       setState(() {
    //         currentLocation = location;
    //       });
    //       return;
    //     }
    //     // _points.add(LatLng(currentLocation!.latitude!, currentLocation!.longitude!));
    //     // LatLng newLocation = LatLng(location.latitude!, location.longitude!);
    //     // Polyline route = Polyline(
    //     //   polylineId: PolylineId('route1'),
    //     //   points: [..._polylines.first.points, newLocation],
    //     //   width: 5,
    //     //   color: Colors.blue,
    //     // );
    //     LatLng newLocation = LatLng(location.latitude!, location.longitude!);
    //     if (_points.isNotEmpty) {
    //       LatLng lastLocation = _points.last;
    //       if (lastLocation.latitude == newLocation.latitude &&
    //           lastLocation.longitude == newLocation.longitude) {
    //         // 위치가 변경되지 않았으면 중복 값을 추가하지 않습니다.
    //         return;
    //       }
    //     }
    //     setState(() {
    //       _points.add(newLocation); // _points 리스트 업데이트
    //       _savePoints(); // _points 저장
    //
    //       Polyline route = Polyline(
    //         polylineId: PolylineId('route1'),
    //         points: [..._polylines.first.points, newLocation],
    //         width: 5,
    //         color: Colors.blue,
    //       );
    //       _polylines = {_polylines.first, route};
    //       currentLocation = location;
    //       _markers = {
    //         Marker(
    //           markerId: MarkerId('current'),
    //           icon: currentLocationIcon,
    //           position: newLocation,
    //
    //         ),
    //       };
    //       // _points.add(newLocation); // _points 리스트 업데이트
    //       // _savePoints(); // _points 저장
    //     });
    //     _loadPoints();
    //   }
    // });
  }

  // 5초마다 위치수집
  void _startLocationTimer() {
    _locationTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      LocationData newLocation = await location.getLocation();
      if (currentLocation == null) {
        setState(() {
          currentLocation = newLocation;
        });
        _onMapCreated(mapController);
      } else {
        if (isWalking == false) {
          setState(() {
            currentLocation = newLocation;
          });
          return;
        }
        LatLng newLatLng = LatLng(newLocation.latitude!, newLocation.longitude!);
        if (_points.isNotEmpty) {
          LatLng lastLocation = _points.last;
          if (lastLocation.latitude == newLatLng.latitude &&
              lastLocation.longitude == newLatLng.longitude) {
            // 위치가 변경되지 않았으면 중복 값을 추가하지 않습니다.
            return;
          }
        }
        setState(() {
          _points.add(newLatLng);
          _savePoints();

          Polyline route = Polyline(
            polylineId: PolylineId('route1'),
            points: [..._polylines.first.points, newLatLng],
            width: 5,
            color: Colors.blue,
          );
          _polylines = {_polylines.first, route};
          currentLocation = newLocation;
          _markers = {
            Marker(
              markerId: MarkerId('current'),
              icon: currentLocationIcon,
              position: newLatLng,
            ),
          };
        });
        _loadPoints();
      }
    });
  }

  // 위치정보 로컬에 저장
  void _savePoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pointsJson = json.encode(_points);
    await prefs.setString('points', pointsJson);
  }

  // 로컬에 저장된 위치정보 불러오기
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

  // 지도 생성
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
    // final testpoints = [LatLng(35.2051205, 126.8116811), LatLng(35.2051147, 126.8116459), LatLng(35.2051522, 126.8116607), LatLng(35.2051534, 126.8116587), LatLng(35.2051526, 126.8116458), LatLng(35.2051459, 126.8116281), LatLng(35.2051564, 126.8115957), LatLng(35.2051682, 126.8115753), LatLng(35.2051978, 126.81154), LatLng(35.2052461, 126.8114945), LatLng(35.2052722, 126.8114794), LatLng(35.205295, 126.8114691), LatLng(35.2053052, 126.8114564), LatLng(35.2053247, 126.8114475), LatLng(35.2053539, 126.8114448), LatLng(35.2053727, 126.8114486), LatLng(35.205395, 126.8114547), LatLng(35.2054234, 126.8114613), LatLng(35.2054932, 126.8115306), LatLng(35.2055264, 126.8116026), LatLng(35.2054981, 126.8115984), LatLng(35.2054439, 126.8116201), LatLng(35.2053836, 126.8116399), LatLng(35.2053173, 126.8116604), LatLng(35.2052645, 126.8116918), LatLng(35.2052134, 126.8117058), LatLng(35.2051926, 126.8117058), LatLng(35.205178, 126.8117015), LatLng(35.2051708, 126.811692), LatLng(35.2051968, 126.8115868), LatLng(35.2052249, 126.811472)];
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
  }
}
