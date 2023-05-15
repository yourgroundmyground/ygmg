import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import '../../const/colors.dart';

class WeeklyGameResultMap extends StatefulWidget {
  final int memberId;

  const WeeklyGameResultMap({
    required this.memberId,
    Key? key}) : super(key: key);

  @override
  State<WeeklyGameResultMap> createState() => _WeeklyGameResultMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

class _WeeklyGameResultMapState extends State<WeeklyGameResultMap> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  var customMapStyle;

  Set<Polygon>_polygon = {};
  int polygonId = 0;
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

  // 폴리곤 좌표리스트로 변환
  List<List<LatLng>> extractCoordinateLists(List<dynamic> data) {
    List<List<LatLng>> result = [];

    for (dynamic item in data) {
      Map<String, dynamic> mapItem = item as Map<String, dynamic>;
      List<dynamic> coordinateList = mapItem['coordinateList'] as List<dynamic>;

      List<LatLng> coordinatePoints = coordinateList.map((coord) {
        Map<String, dynamic> coordMap = coord as Map<String, dynamic>;
        double lat = coordMap['areaCoordinateLat'] as double;
        double lng = coordMap['areaCoordinateLng'] as double;
        return LatLng(lat, lng);
      }).toList();

      result.add(coordinatePoints);
    }

    return result;
  }

  // 주별 폴리곤 좌표리스트 조회 요청(*수정 필요)
  void getPolygonPoints() async {
    var dio = Dio();
    try {
      print('백에서 주별폴리곤 좌표리스트 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/member/${widget.memberId}');
      // var response = await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/member/1/2023-05-13');     // *요청 API 주소 넣기
      print(response.data);

      // 받은 좌표 리스트로 폴리곤의 위치 좌표 구하기
      List<dynamic> polygonData = response.data;
      List<List<LatLng>> polygonCoordinates = extractCoordinateLists(polygonData);
      print('좌표만 얻기 $polygonCoordinates');

      // 랜덤한 색상 선택
      Color randomColor = _polygonColors[Random().nextInt(_polygonColors.length)];

      // 폴리곤 객체 생성
      for (int i = 0; i < polygonCoordinates.length; i++) {
        List<LatLng> coordinateList = polygonCoordinates[i];

        // 폴리곤 객체 생성
        Polygon polygon = Polygon(
          polygonId: PolygonId('polygon_${polygonId}_$i'),
          points: coordinateList,
          strokeWidth: 2,
          strokeColor: randomColor,
          fillColor: randomColor.withOpacity(0.3),
        );

        // 폴리곤의 중심 좌표 계산
        double sumLat = 0;
        double sumLng = 0;
        for (LatLng coordinate in coordinateList) {
          sumLat += coordinate.latitude;
          sumLng += coordinate.longitude;
        }
        double centerLat = sumLat / coordinateList.length;
        double centerLng = sumLng / coordinateList.length;

        setState(() {
          _polygon.add(polygon);
          _center = LatLng(centerLat, centerLng);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    loadMapStyle().then((style) {
      setState(() {
        customMapStyle = style;
      });
    });
    getPolygonPoints();
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
      zoomControlsEnabled: false,
      tiltGesturesEnabled: false,
    );
  }
}
