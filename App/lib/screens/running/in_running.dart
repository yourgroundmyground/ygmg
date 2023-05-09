import 'package:app/widgets/running_info.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class InRunning extends StatefulWidget {
  const InRunning({Key? key}) : super(key: key);

  @override
  State<InRunning> createState() => _InRunningState();
}
  Future<String> loadMapStyle() async {
    return await rootBundle.loadString('assets/style/map_style.txt');
  }

class _InRunningState extends State<InRunning> {

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

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage('assets/images/runningbgi.png'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topLeft,
                repeat: ImageRepeat.noRepeat,
              )
            ),
            child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(mediaWidth*0.1, mediaHeight*0.1, mediaWidth*0.1, mediaHeight*0.05),
                child: Text('잘 하고 있어요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: mediaWidth*0.07,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 1
                  )
                ),
              ),
              CircleAvatar(
                radius: mediaWidth*0.4,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    bearing: 0,
                    target: LatLng(35.2051965, 126.8117383),
                    zoom: 18.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    controller.setMapStyle(customMapStyle);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  rotateGesturesEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
              // CircleAvatar(
              //   backgroundImage: AssetImage('assets/images/running-gif.gif'),
              //   radius: mediaWidth*0.4,
              // ),
              SizedBox(height: mediaHeight*0.07,),
              RunningInfo()    //  *running_info 위젯으로 변경하기
            ]
          )
        )
      )
    );
  }
}
