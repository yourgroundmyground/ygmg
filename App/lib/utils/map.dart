import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class Map extends StatelessWidget {
  var googlemapkey = dotenv.env['GOOGLE_MAP_KEY'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    );
}
