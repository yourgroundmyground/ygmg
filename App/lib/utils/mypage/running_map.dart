import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class RunningMap extends StatefulWidget {
  final int runningDetailId;

  const RunningMap({
    required this.runningDetailId,
    Key? key}) : super(key: key);

  @override
  State<RunningMap> createState() => _RunningMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

  Future<BitmapDescriptor> _loadMarkerImage(String imagePath) async {
    return await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.0),
      imagePath,
    );
  }

class _RunningMapState extends State<RunningMap> {
  List<LatLng> latLngList = [];
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  var customMapStyle;
  Set<Marker> _markers = {};

  // *테스트 데이터, 추후에 삭제 바람
  final test = {
    "coordinateList": [
      {
        "coordinateTime": "15:40:10",
        "runningLat": 35.2051205,
        "runningLng": 126.8116811
      },
      {
        "coordinateTime": "15:40:30",
        "runningLat": 35.2051147,
        "runningLng": 126.8116459
      },
    ],
  };

  // 러닝경로 정보 가져오기
  void getRunningRoute(int runningDetailId) async {
    var dio = Dio();
    try {
      print('백에서 러닝경로 가져오기!');
      var response = await dio.get(
        'http://k8c107.p.ssafy.io:8081/api/running/coordinate/$runningDetailId',
        options: Options(
          headers: {
            // 'Authorization': 'Bearer $token',    // *토큰 넣어주기
          }
        )
      );
      print(response.data);
      // 받은 데이터 중 좌표를 형식을 바꾸기
      setState(() {
        latLngList = convertToLatLngList(response.data['runningCoordinateList'] as List<Map<String, dynamic>>);
      });
    } catch (e) {
      print(e.toString());
    }
    latLngList = convertToLatLngList(test['coordinateList'] as List<Map<String, dynamic>>);
    _loadMarkersWithImages();
  }

  // 받은 좌표리스트를 LatLng 형식으로 변환
  List<LatLng> convertToLatLngList(List<Map<String, dynamic>> data) {

    for (var coordinate in data) {
      double lat = coordinate['runningLat'];
      double lng = coordinate['runningLng'];
      latLngList.add(LatLng(lat, lng));
    }

    return latLngList;
  }

  // 시작, 끝 커스텀 마커
  void _loadMarkersWithImages() async {
    // 마커 이미지 로드
    BitmapDescriptor startMarkerImage =
    await _loadMarkerImage('assets/images/testProfile.png');

    BitmapDescriptor endMarkerImage =
    await _loadMarkerImage('assets/images/testProfile.png');

    // 마커를 설정합니다
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('runningStart'),
          position: latLngList.first,
          icon: startMarkerImage,
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('runningEnd'),
          position: latLngList.last,
          icon: endMarkerImage,
        ),
      );
    });
  }

  @override
  void initState() {
    getRunningRoute(widget.runningDetailId);
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLngList[0],
        zoom: 16
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId("runningRoute"),
          color: Colors.blue,
          width: 5,
          points: latLngList,
        ),
      },
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(customMapStyle);
      },
    );
  }
}