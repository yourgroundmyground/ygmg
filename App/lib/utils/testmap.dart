import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Polygon> _polygons = {};
  void addPolygon() {
    List<LatLng> polygonLatLng1 = [
      LatLng(33.4502143361292,	126.57104991347728),
      LatLng(33.44947676224537,	126.57129104971551),
      LatLng(33.45030613108559,	126.57152151454649),
      LatLng(33.4502143361292,	126.57104991347728),
    ];
    Polygon polygon2 = Polygon(
      polygonId: PolygonId("1"),
      points: polygonLatLng1,
      fillColor: Colors.blue.withOpacity(0.5),
      strokeColor: Colors.blue,
      strokeWidth: 2,
    );
    _polygons.add(
      polygon2
    );
    setState(() {
      _polygons.add(
          polygon2
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        polygons: _polygons,
        initialCameraPosition: CameraPosition(
          target: LatLng(33.4502143361292,	126.57104991347728),
          zoom: 12,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPolygon,
        child: Icon(Icons.play_arrow),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    _addPolygons();
  }

  void _addPolygons() {
    List<LatLng> polygonLatLngs = [
      LatLng(33.45113076336205, 126.57175066318219),
      LatLng(33.45213904262599,	126.57203084360238),
      LatLng(33.45211546918497,	126.57042837293268),
      LatLng(33.45126460137033,	126.57070654854132),
      LatLng(33.45113076336205,	126.57175066318219),
    ];

    Polygon polygon = Polygon(
      polygonId: PolygonId("0"),
      points: polygonLatLngs,
      fillColor: Colors.red.withOpacity(0.5),
      strokeColor: Colors.red,
      strokeWidth: 2,
    );



    setState(() {
      _polygons.add(polygon);
    });
  }
}