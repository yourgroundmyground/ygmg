import 'dart:math';
import 'package:app/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class GameMap extends StatefulWidget {
  final List<Map<String, dynamic>> gamedata;

  const GameMap({
    required this.gamedata,
    Key? key}) : super(key: key);

  @override
  State<GameMap> createState() => _GameMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }


class _GameMapState extends State<GameMap> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  var customMapStyle;

  Set<Polygon>_polygon = {};
  List<LatLng> polygonPoints = [];
  int polygonId = 0;
  Color randomColor = Colors.transparent;
  var _center;

  // colors.dart에서 정의한 색상 리스트
  final List<Color> _polygonColors = [
    YGMG_RED,
    YGMG_ORANGE,
    YGMG_YELLOW,
    YGMG_BEIGE,
    YGMG_GREEN,
    YGMG_SKYBLUE,
    YGMG_DARKGREEN,
    YGMG_PURPLE,
  ];

  void extractCoordinateLists(List<dynamic> data) {
    List<LatLng> latLngList = data.map((item) {
      double lat = item['areaCoordinateLat'];
      double lng = item['areaCoordinateLng'];
      return LatLng(lat, lng);
    }).toList();

    // 폴리곤 객체 생성
    Polygon polygon = Polygon(
      polygonId: PolygonId('polygon_$polygonId'),
      points: latLngList,
      strokeWidth: 2,
      strokeColor: randomColor,
      fillColor: randomColor.withOpacity(0.3),
    );

    // 폴리곤의 중심 좌표 계산
    double sumLat = 0;
    double sumLng = 0;
    for (LatLng coordinate in latLngList) {
      sumLat += coordinate.latitude;
      sumLng += coordinate.longitude;
    }
    double centerLat = sumLat / latLngList.length;
    double centerLng = sumLng / latLngList.length;

    setState(() {
      polygonPoints = latLngList;
      _polygon.add(polygon);
      _center = LatLng(centerLat, centerLng);
      polygonId += 1;
    });

  }

  @override
  void initState() {
    loadMapStyle().then((style) {
      setState(() {
        customMapStyle = style;
      });
    });
    // 랜덤한 색상 선택
    randomColor = _polygonColors[Random().nextInt(_polygonColors.length)];
    for (var i = 0; i < widget.gamedata.length; i++) {
      extractCoordinateLists(widget.gamedata[i]['coordinateList']);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _center == null ? Center(child: CircularProgressIndicator(),) :
    GoogleMap(
      initialCameraPosition: CameraPosition(
        bearing: 0,
        target: _center,
        zoom: 16.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(customMapStyle);
      },
      polygons: _polygon,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: true,
      tiltGesturesEnabled: false,
    );
  }
}
