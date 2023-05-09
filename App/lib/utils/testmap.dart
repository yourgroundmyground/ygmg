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
      LatLng(37.7849, -122.4293),
      LatLng(37.7869, -122.4193),
      LatLng(37.7748, -122.4194),
      LatLng(37.7748, -122.4294),
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
          target: LatLng(37.77483, -122.41942),
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
      LatLng(37.78493, -122.42932),
      LatLng(37.78693, -122.41932),
      LatLng(37.77483, -122.41942),
      LatLng(37.77483, -122.42942),
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