import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'dart:async';
import '../../const/colors.dart';

class DailyGameResultMap extends StatefulWidget {
  final int? memberId;

  const DailyGameResultMap({
    required this.memberId,
    Key? key}) : super(key: key);

  @override
  State<DailyGameResultMap> createState() => _DailyGameResultMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

class _DailyGameResultMapState extends State<DailyGameResultMap> {
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
  List<LatLng> extractPolygonCoordinates(List<dynamic> polygonData) {
    List<LatLng> polygonCoordinates = [];
    for (Map<String, dynamic> pointData in polygonData) {
      double? lat = double.tryParse(pointData['areaCoordinateLat'].toString());
      double? lng = double.tryParse(pointData['areaCoordinateLng'].toString());
      if (lat != null && lng != null) {
        LatLng coordinate = LatLng(lat, lng);
        polygonCoordinates.add(coordinate);
      }
    }
    return polygonCoordinates;
  }

  // 일별 폴리곤 좌표리스트 조회 요청
  void getPolygonPoints() async {
    var dio = Dio();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    try {
      print('백에서 일별폴리곤 좌표리스트 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/day/${widget.memberId}/$formattedDate');
      // var response = await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/day/1/2023-05-13');     // *요청 API 주소 넣기
      print(response.data);
      // 데이터 형식
      // List<Map<String, dynamic>> test = [
      //     {
      //         "areaId": 1,
      //         "memberId": 1,
      //         "areaDate": "2023-05-13 13:05:11",
      //         "gameId": 1,
      //         "areaSize": 5.691152769292121E-6,
      //         "coordinateList": [
      //             {
      //                 "areaCoordinateId": 1,
      //                 "areaCoordinateLat": 33.451690157220135,
      //                 "areaCoordinateLng": 126.56738664637757,
      //                 "areaCoordinateTime": "2023-05-12 23:13:05"
      //             },
      //             {
      //                 "areaCoordinateId": 2,
      //                 "areaCoordinateLat": 33.44949922860903,
      //                 "areaCoordinateLng": 126.56737601368614,
      //                 "areaCoordinateTime": "2023-05-12 23:13:05"
      //             },
      //             {
      //                 "areaCoordinateId": 3,
      //                 "areaCoordinateLat": 33.4502143361292,
      //                 "areaCoordinateLng": 126.57104991347728,
      //                 "areaCoordinateTime": "2023-05-12 23:13:05"
      //             },
      //             {
      //                 "areaCoordinateId": 4,
      //                 "areaCoordinateLat": 33.45126460137033,
      //                 "areaCoordinateLng": 126.57070654854132,
      //                 "areaCoordinateTime": "2023-05-12 23:13:05"
      //             },
      //             {
      //                 "areaCoordinateId": 5,
      //                 "areaCoordinateLat": 33.451690157220135,
      //                 "areaCoordinateLng": 126.56738664637757,
      //                 "areaCoordinateTime": "2023-05-12 23:13:05"
      //             }
      //         ]
      //     },
      // ];
      // 받은 좌표 리스트로 폴리곤의 위치 좌표 구하기
      List<dynamic> polygonData = response.data[0]['coordinateList'];
      List<LatLng> polygonCoordinates = extractPolygonCoordinates(polygonData);

      // 랜덤한 색상 선택
      Color randomColor = _polygonColors[Random().nextInt(_polygonColors.length)];

      // 폴리곤 객체 생성
      Polygon polygon = Polygon(
        polygonId: PolygonId('polygon_$polygonId'),
        points: polygonCoordinates,
        strokeWidth: 2,
        strokeColor: randomColor,
        fillColor: randomColor.withOpacity(0.3),
      );

      // 폴리곤의 중심 좌표 계산
      double sumLat = 0;
      double sumLng = 0;
      for (LatLng coordinate in polygonCoordinates) {
        sumLat += coordinate.latitude;
        sumLng += coordinate.longitude;
      }
      double centerLat = sumLat / polygonCoordinates.length;
      double centerLng = sumLng / polygonCoordinates.length;

      setState(() {
        _polygon.add(polygon);
        _center = LatLng(centerLat, centerLng);
      });
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
