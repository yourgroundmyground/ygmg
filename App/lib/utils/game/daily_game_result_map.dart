import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';

import '../../const/colors.dart';

class DailyGameResultMap extends StatefulWidget {
  const DailyGameResultMap({Key? key}) : super(key: key);

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
  LatLng _center = LatLng(35.2051965, 126.8117383);

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

  // 일별 폴리곤 좌표리스트 조회 요청
  void getPolygonPoints() async {
    var dio = Dio();
    try {
      print('백에서 일별폴리곤 좌표리스트 가져오기!');
      var response = await dio.get('............');     // *요청 API 주소 넣기
      print(response.data);
      // 데이터 형식
      // {
      //   "kakaoEmail": "suasdfa1@naver.com",
      //   "memberBirth": "0512",
      //   "memberName": "adf",
      //   "memberNickname": "asdf",
      //   "memberWeight": 23,
      //   "profileImg": "https://asdfasdf.jpg"
      // }

      // 받은 좌표 리스트로 폴리곤의 위치 좌표 구하기
      List<dynamic> polygonData = response.data;
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

  // 폴리곤 좌표리스트로 변환
  List<LatLng> extractPolygonCoordinates(List<dynamic> polygonData) {
   List<LatLng> polygonCoordinates = [];
    for (dynamic pointData in polygonData) {
      double lat = pointData['lat'];
      double lng = pointData['long'];
      LatLng coordinate = LatLng(lat, lng);
      polygonCoordinates.add(coordinate);
    }
    return polygonCoordinates;
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
    return GoogleMap(
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
