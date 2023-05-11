import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class InRunningMap extends StatefulWidget {
  const InRunningMap({Key? key}) : super(key: key);

  @override
  State<InRunningMap> createState() => _InRunningMapState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

class _InRunningMapState extends State<InRunningMap> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  var customMapStyle;

  @override
  void initState() {
    super.initState();
    loadMapStyle().then((value) {
      setState(() {
        customMapStyle = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        bearing: 0,
        target: LatLng(35.2051965, 126.8117383),
        zoom: 18.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        controller.setMapStyle(customMapStyle);
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      rotateGesturesEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
