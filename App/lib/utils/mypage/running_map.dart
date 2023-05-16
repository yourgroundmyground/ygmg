import 'package:app/const/colors.dart';
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

  // 러닝경로 정보 가져오기
  void getRunningRoute(int runningDetailId) async {
    var dio = Dio();
    try {
      print('백에서 러닝경로 가져오기!');
      var response = await dio.get(
        'http://k8c107.p.ssafy.io:8081/api/running/coordinate/$runningDetailId',
      );
      print(response.data);
      // 받은 데이터 중 좌표를 형식을 바꾸기
      setState(() {
        List<dynamic> tmpList = response.data['runningCoordinateList'];
        convertToLatLngList(tmpList);
      });
    } catch (e) {
      print(e.toString());
    }
    _loadMarkersWithImages();
  }

  // 받은 좌표리스트를 LatLng 형식으로 변환
  List<LatLng> convertToLatLngList(List<dynamic> data) {

    for (var coordinate in data) {
      double lat = coordinate['runningLat'];
      double lng = coordinate['runningLng'];
      setState(() {
        latLngList.add(LatLng(lat, lng));
      });
    }
    return latLngList;
  }

  // 시작, 끝 커스텀 마커
  void _loadMarkersWithImages() async {
    // 마커 이미지 로드
    BitmapDescriptor startMarkerImage =
    await _loadMarkerImage('assets/images/material-symbols_flag-outline.png');

    BitmapDescriptor endMarkerImage =
    await _loadMarkerImage('assets/images/material-symbols_flag.png');

    // 마커를 설정합니다
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('runningStart'),
          position: latLngList.first,
          icon: startMarkerImage,
          anchor: Offset(0.2, 0.9),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('runningEnd'),
          position: latLngList.last,
          icon: endMarkerImage,
          anchor: Offset(0.3, 0.85),
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
    return latLngList.isEmpty ? Center(child: CircularProgressIndicator()) :
      GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLngList[latLngList.length ~/ 2],
        zoom: 16
      ),
      polylines: {
        Polyline(
          polylineId: PolylineId("runningRoute"),
          color: YGMG_ORANGE.withOpacity(0.7),
          width: 5,
          points: latLngList,
        ),
      },
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(customMapStyle);
      },
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
    );
  }
}
