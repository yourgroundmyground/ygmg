import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class DailyRunningMap extends StatefulWidget {
  final List<Map<String, dynamic>> runninglocationList;

  const DailyRunningMap({
    required this.runninglocationList,
    Key? key}) : super(key: key);

  @override
  State<DailyRunningMap> createState() => _DailyRunningMapState();
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

class _DailyRunningMapState extends State<DailyRunningMap> {
  List<LatLng> latLngList = [];
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  var customMapStyle;
  Set<Marker> _markers = {};

  // 받은 좌표리스트를 LatLng 형식으로 변환
  void convertToLatLngList(List<Map<String, dynamic>> data) {
    setState(() {
      latLngList = data
          .map((location) => LatLng(location['latitude'], location['longitude']))
          .toList();
    });
    _loadMarkersWithImages();
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
    convertToLatLngList(widget.runninglocationList);
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
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
    );
  }
}
