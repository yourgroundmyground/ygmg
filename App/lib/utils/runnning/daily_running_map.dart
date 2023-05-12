import 'dart:async';
import 'dart:convert';
import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

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
  List<dynamic> notConvertList = [];
  List<LatLng> latLngList = [];
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  var customMapStyle;
  Set<Marker> _markers = {};

  // 받은 좌표리스트를 LatLng 형식으로 변환
  List<LatLng> convertToLatLngList(List<dynamic> data) {
    for (var coordinate in data) {
      double lat = coordinate['lat'];
      double lng = coordinate['lng'];
      if (lat != 0.0 && lng != 0.0) {
        setState(() {
          latLngList.add(LatLng(lat, lng));
        });
      }
    }
    _loadMarkersWithImages();
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
      if (mounted) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('runningStart'),
            position: latLngList.first,
            icon: startMarkerImage,
            anchor: Offset(0.3, 0.85),
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
  }

  Future<void> loadLocationList() async {
    SharedPreferences runningResult = await SharedPreferences.getInstance();
    String? stringList = runningResult.getString('locationList');

    if (stringList != null) {
      List<dynamic> locationList = json.decode(stringList);
      setState(() {
        notConvertList = locationList;
      });
    }
  }

  @override
  void initState() {
    loadLocationList().then((_) =>
      {
        if (notConvertList.isNotEmpty) {
          convertToLatLngList(notConvertList)
        }
      }
    );
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
