import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import '../../const/colors.dart';

class WeeklygGameResultAllMap extends StatefulWidget {
  final int gameId;

  const WeeklygGameResultAllMap({
    required this.gameId,
    Key? key}) : super(key: key);

  @override
  State<WeeklygGameResultAllMap> createState() => _WeeklygGameResultAllMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

class _WeeklygGameResultAllMapState extends State<WeeklygGameResultAllMap> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  var customMapStyle;

  Set<Polygon>_polygon = {};
  Set<Marker> _marker = {};
  int polygonId = 0;
  var _center;
  List<dynamic> memberInfo = [];

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
  List<LatLng> extractCoordinates(List<dynamic> data) {
    List<LatLng> result = [];

    for (dynamic item in data) {
      Map<String, dynamic> mapItem = item as Map<String, dynamic>;
      List<dynamic> coordinateList = mapItem['coordinateList'] as List<dynamic>;

      for (dynamic coord in coordinateList) {
        Map<String, dynamic> coordMap = coord as Map<String, dynamic>;
        double lat = coordMap['areaCoordinateLat'] as double;
        double lng = coordMap['areaCoordinateLng'] as double;
        LatLng coordinate = LatLng(lat, lng);
        result.add(coordinate);
      }
    }

    return result;
  }

  void openProfileModal(List<dynamic> memberInfoList) {
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    final markerTapContext = context;
    showModalBottomSheet(
      context: markerTapContext,
      builder: (BuildContext context) {
        return SizedBox(
          height: mediaHeight * 0.2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: mediaWidth * 0.1),
              Container(
                width: mediaWidth * 0.2,
                height: mediaWidth * 0.2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.network(
                    memberInfoList[0]['profileUrl'],
                    height: mediaWidth * 0.2,
                    width: mediaWidth * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                memberInfoList[0]['memberNickname'],
                style: TextStyle(fontSize: mediaWidth * 0.04),
              ),
              SizedBox(width: mediaWidth * 0.1),
            ],
          ),
        );
      },
    );
  }

  // 주별 모든 폴리곤 좌표리스트 조회 요청
  void getPolygonPoints() async {
    var dio = Dio();
    try {
      print('백에서 주별 모든폴리곤 좌표리스트 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io/api/game/area/game/${widget.gameId}');
      // var response = await dio.get('http://k8c107.p.ssafy.io:8082/api/game/area/member/1/1');     // *요청 API 주소 넣기
      print(response.data);

      Map<int, List<dynamic>> memberData = {};

      for (var item in response.data) {
        int memberId = item['memberId'];
        if (!memberData.containsKey(memberId)) {
          memberData[memberId] = [];
        }
        memberData[memberId]?.add(item);
      }

      // memberId 별로 생성된 리스트 출력
      print('멤버별로 출력');
      print(memberData);
      memberData.forEach((memberId, memberList) {
        print('Member ID: $memberId');
        print('Member List: $memberList');

        // // 랜덤한 색상 선택
        Color randomColor = _polygonColors[Random().nextInt(
            _polygonColors.length)];

        // 멤버별 폴리곤 리스트 하나씩 넣기
        for (int i = 0; i < memberList.length; i++) {
          print(memberList[i]);
          int memberId = memberList[i]['memberId'];
          print('폴리곤 별 멤버아이디: $memberId');
          List<dynamic> polygonData = memberList[i]['coordinateList'];
          // print('멤버별 폴리곤 리스트 하나씩 넣기');
          // print(polygonData);
          List<LatLng> latLngList = polygonData.map((item) {
            double lat = item["areaCoordinateLat"];
            double lng = item["areaCoordinateLng"];
            return LatLng(lat, lng);
          }).toList();
          print('좌표들만뽑음');
          print(latLngList);

          Polygon polygon = Polygon(
            polygonId: PolygonId('polygon_$i'),
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

          Marker marker = Marker(
            markerId: MarkerId('marker_${i}_$memberId'),
            position: LatLng(centerLat, centerLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              HSLColor.fromColor(randomColor).hue
            ),
            onTap: () async {
              var memberInfoList = await getMemberInfo(memberId);
              openProfileModal(memberInfoList);
            },
          );

          setState(() {
            _polygon.add(polygon);
            _marker.add(marker);
            _center = LatLng(centerLat, centerLng);
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<dynamic>> getMemberInfo(int memberId) async {
    var dio = Dio();
    try {
      print('백에서 사용자들 닉네임, 프로필 가져오기!');
      var response = await dio.get('http://k8c107.p.ssafy.io/api/member/profiles?memberList=$memberId');
      print(response.data);
      return response.data ?? [];
    } catch (e) {
      print(e.toString());
      return [];
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

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: _center == null ? Center(child: CircularProgressIndicator(),) :
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
              markers: _marker,
              myLocationButtonEnabled: false,
              rotateGesturesEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
          Positioned(
            top: mediaHeight*0.06,
            right: mediaWidth*0.06,
            child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset('assets/images/closebtn.png', width: mediaWidth*0.08,)
          ))
        ],
      )
    );
  }
}
