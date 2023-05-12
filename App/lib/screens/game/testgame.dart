import 'package:app/widgets/profile_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:dart_jts/dart_jts.dart' as jts_package;

class InGame extends StatefulWidget {
  const InGame({Key? key}) : super(key: key);
  @override
  State<InGame> createState() => InGameState();
}
class InGameState extends State<InGame> {
  var isWalking = false;
  @override
  Widget build(BuildContext context) {

    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return SafeArea(child: Text('hi'));
    // return Stack(
    //       children: [
    //         Container(
    //           child:  ? Center(
    // child: CircularProgressIndicator(),
    // )
    //     : GoogleMap(
    // onMapCreated: _onMapCreated,
    // initialCameraPosition: CameraPosition(
    // target: LatLng(
    // currentLocation!.latitude!,
    // currentLocation!.longitude!,
    // ),
    // zoom: 17.0,
    // ),
    // // myLocationEnabled: true,
    // markers: _markers,
    // polylines: _currentPolylines,
    // polygons: _polygonSets,
    // tiltGesturesEnabled: false,
    // ),
    //         ),
    //         Positioned(
    //           left: mediaWidth*0.03,
    //           top: mediaHeight*0.03,
    //           child: Container(
    //             //왼쪽 위 모달
    //             width: 200,
    //             decoration: BoxDecoration(
    //                 color: Colors.white.withOpacity(0.8),
    //                 borderRadius: BorderRadius.circular(15)
    //             ),
    //             child: Column(
    //               children: [
    //                 Text('시간모달', style: TextStyle(fontSize: 20,color: Colors.black),),
    //                 Text('0m²', style: TextStyle(fontSize: 25,color: Colors.black, fontWeight: FontWeight.w400),)
    //               ],
    //             ),
    //           ),
    //         ),
    //         Positioned(
    //             right: mediaWidth*0.03,
    //             top: mediaHeight*0.03,
    //             child: Container(
    //               //오른쪽 위 모달
    //               width: 200,
    //               decoration: BoxDecoration(
    //                   color: Colors.white.withOpacity(0.8),
    //                   borderRadius: BorderRadius.circular(15)
    //               ),
    //               child: Column(
    //                 children: [
    //                   Column(
    //                     children: [
    //                       Text('실시간 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
    //                       SizedBox(
    //                         child: Userprofile(
    //                             height: mediaHeight*0.04,
    //                             width: mediaWidth*0.8,
    //                             imageProvider: AssetImage('assets/images/profile01mini.png'),
    //                             text1: '1',
    //                             text2: '군침이싹도나',
    //                             text3: null,
    //                             textStyle: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 15
    //                             )),
    //                       ),
    //                       SizedBox(
    //                         child: Userprofile(
    //                             height: mediaHeight*0.04,
    //                             width: mediaWidth*0.8,
    //                             imageProvider: AssetImage('assets/images/profile02mini.png'),
    //                             text1: '2',
    //                             text2: '오늘도군것질',
    //                             text3: null,
    //                             textStyle: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 15
    //                             )),
    //                       )
    //                     ],
    //                   ),
    //                   Column(
    //                     children: [
    //                       Text('내 순위', style: TextStyle(fontSize: 16, color: Colors.black)),
    //                       SizedBox(
    //                         child: Userprofile(
    //                             height: mediaHeight*0.04,
    //                             width: mediaWidth*0.8,
    //                             imageProvider: AssetImage('assets/images/profilememini.png'),
    //                             text1: '_',
    //                             text2: '가면말티즈',
    //                             text3: null,
    //                             textStyle: TextStyle(
    //                                 color: Colors.black,
    //                                 fontSize: 15
    //                             )),
    //                       )
    //                     ],
    //                   )
    //                 ],
    //               ),
    //             )
    //         ),
    //         Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Container(
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 children: [
    //                   Container(
    //                     width: 80,
    //                     height: 80,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(50),
    //                         gradient: LinearGradient(
    //                             colors: [
    //                               Color(0xFFFDD987),
    //                               Color(0xFFF79CC3),
    //                             ],
    //                             begin: Alignment.topCenter,
    //                             end: Alignment.bottomCenter
    //                         ),
    //                         border: Border.all(
    //                             color: Colors.white,
    //                             width: 3
    //                         )
    //                     ),
    //                     child: FloatingActionButton(
    //                         backgroundColor: Colors.transparent,
    //                         onPressed: (){
    //                           drawPolygonStateKey.currentState?.resetPoints();
    //                         }, child: Icon(Icons.stop_rounded, size: 45)),
    //                   ),
    //                   Container(
    //                     width: 80,
    //                     height: 80,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(50),
    //                         gradient: LinearGradient(
    //                             colors: [
    //                               Color(0xFFFDD987),
    //                               Color(0xFFF79CC3),
    //                             ],
    //                             begin: Alignment.topCenter,
    //                             end: Alignment.bottomCenter
    //                         ),
    //                         border: Border.all(
    //                             color: Colors.white,
    //                             width: 3
    //                         )
    //                     ),
    //                     child: FloatingActionButton(
    //                         backgroundColor: Colors.transparent,
    //                         onPressed: (){
    //                           setState(() {
    //                             isWalking = !isWalking;
    //                           });
    //                         }, child: Icon(isWalking ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 45)),
    //                   ),
    //                   Container(
    //                     width: 80,
    //                     height: 80,
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(50),
    //                         gradient: LinearGradient(
    //                             colors: [
    //                               Color(0xFFFDD987),
    //                               Color(0xFFF79CC3),
    //                             ],
    //                             begin: Alignment.topCenter,
    //                             end: Alignment.bottomCenter
    //                         ),
    //                         border: Border.all(
    //                             color: Colors.white,
    //                             width: 3
    //                         )
    //                     ),
    //                     child: FloatingActionButton(
    //                         backgroundColor: Colors.transparent,
    //                         onPressed: (){
    //
    //                         }, child: Icon(Icons.star_border_rounded, size: 45)),
    //                   ),
    //                 ],
    //               )
    //           ),
    //         ),
    //
    // ],
    // );
  }
}
