import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(37.4219999, -122.0840575),
    zoom: 14,
  );

  Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _polygons.add(
      Polygon(
        polygonId: PolygonId('polygon_1'),
        points: [
          LatLng(37.422000, -122.084057),
          LatLng(37.421988, -122.083885),
          LatLng(37.421936, -122.083880),
          LatLng(37.421928, -122.084055),
        ],
        strokeColor: Colors.red,
        strokeWidth: 3,
        fillColor: Colors.red.withOpacity(0.2),
      ),
    );
    _polygons.add(
      Polygon(
        polygonId: PolygonId('polygon_2'),
        points: [
          LatLng(37.421962, -122.084003),
          LatLng(37.421981, -122.084044),
          LatLng(37.421921, -122.084087),
          LatLng(37.421904, -122.084044),
        ],
        strokeColor: Colors.blue,
        strokeWidth: 3,
        fillColor: Colors.blue.withOpacity(0.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        polygons: _polygons,
        onMapCreated: (GoogleMapController controller) {
          // 두 개의 폴리곤의 겹친 부분을 표시합니다.
          Path path1 = createPath(_polygons.elementAt(0).points);
          Path path2 = createPath(_polygons.elementAt(1).points);
          Path intersectPath = Path.combine(PathOperation.intersect, path1, path2);
          List<LatLng> intersectPoints = [];
          double length = intersectPath.computeMetrics().fold(
              0, (previousValue, element) => previousValue + element.length);
          double distance = 0;
          while (distance < length) {
            PathMetric metric = intersectPath.computeMetrics().first;
            Tangent? tangent = metric.getTangentForOffset(distance);
            if (tangent != null) {
              intersectPoints.add(LatLng(tangent.position.dy, tangent.position.dx));
            }
            distance += 10; // offset distance 설정
          }
          _polygons.add(
            Polygon(
              polygonId: PolygonId('intersect_polygon'),
              points: intersectPoints,
              strokeColor: Colors.green,
              strokeWidth: 3,
              fillColor: Colors.green.withOpacity(0.2),
            ),
          );
          setState(() {});
        },
      ),
    );
  }

  // 폴리곤을 이용해 Path 객체를 생성하는 함수
  Path createPath(List<LatLng> polygon) {
    Path path = Path();
    path.moveTo(polygon[0].latitude, polygon[0].longitude);
    for (int i = 1; i < polygon.length; i++) {
      path.lineTo(polygon[i].latitude, polygon[i].longitude);
    }
    path.close();
    return path;
  }
}
