import 'package:app/screens/running/running_start.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:app/screens/running/daily_running.dart';
import 'package:app/const/colors.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'dart:math';
import 'package:sensors/sensors.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../const/state_provider_token.dart';

class RunningInfo extends StatefulWidget {
  const RunningInfo({Key? key}) : super(key: key);

  @override
  State<RunningInfo> createState() => _RunningInfoState();
}

class _RunningInfoState extends State<RunningInfo> {
  var _tokenInfo;
  bool isStarted = true;
  bool isPlaying = true;
  double gyrorunningPace = 0.0;
  late DateTime runningStart;

  double runningPace = 0.0;
  double runningPaceKm = 0.0;
  double runningDist = 0.0;
  Duration runningDuration = Duration.zero;
  double runningKcal = 0.0;

  late Timer _timer;
  int _count = 0;

  late Location _location;
  late StreamSubscription<LocationData> _locationSubscription;
  bool _isLocationServiceEnabled = false;
  late PermissionStatus _permissionStatus;

  final List<Map<String, dynamic>> _locationList = [];

  LocationData? _previousLocationData;
  double _currentSpeed = 0.0;
  double _distance = 0.0;

  // 로컬에 저장된 토큰정보 가져오기
  Future<void> _loadTokenInfo() async {
    final tokenInfo = await loadTokenFromSecureStorage();
    setState(() {
      _tokenInfo = tokenInfo;
    });
  }

  // 칼로리 계산
  double calculateRunningKcal(double weight, Duration duration) {
    double runningMinutes = duration.inMinutes.toDouble();
    double runningKcal;

    if (runningDist == 0) {
      return 0;
    }

    runningKcal = (weight * 3.5 * runningMinutes * 4 / 1000) * 5;
    print(runningKcal);
    return runningKcal;
  }

  @override
  void initState() {
    _loadTokenInfo();
    super.initState();
    runningStart = DateTime.now();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      double speed = (event.x.abs() + event.y.abs() + event.z.abs()) / 3;
      gyrorunningPace = (speed * 3.6) * 10;
      gyrorunningPace = (gyrorunningPace.round() / 10);
      // 속도가 0인 경우 isPlaying을 false로 바꾸어줍니다.
      if (gyrorunningPace < 1.0 && isStarted) {
        _count += 1;
        if (_count >= 30) {
          setState(() {
            isPlaying = false;
          });
        }
      } else {
        _count = 0;
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), _updateRunningTime);

    // gps 측정
    _location = Location();
    _checkLocationService();
  }

  @override
  void dispose() {
    _timer.cancel();
    _locationSubscription.cancel();
    gyroscopeEvents.drain();
    super.dispose();
  }

  // gps 측정
  Future<void> _checkLocationService() async {
    _isLocationServiceEnabled = await _location.serviceEnabled();
    if (!_isLocationServiceEnabled) {
      _isLocationServiceEnabled = await _location.requestService();
      if (!_isLocationServiceEnabled) {
        return;
      }
    }

    _permissionStatus = await _location.hasPermission();
    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription =
        _location.onLocationChanged.listen((LocationData locationData) {
      _updateRunningInfo(locationData);
    });
  }

  void _updateRunningInfo(LocationData locationData) {
    if (_previousLocationData == null) {
      _previousLocationData = locationData;
      return;
    }

    Point<num> previousPoint = Point(
      _previousLocationData!.latitude!,
      _previousLocationData!.longitude!,
    );
    Point<num> currentPoint = Point(
      locationData.latitude!,
      locationData.longitude!,
    );
    double distanceInMeters = SphericalUtils.computeDistanceBetween(
      previousPoint,
      currentPoint,
    );

    // 위치 보정 전
    _distance += distanceInMeters / 1000; // 단위: km

    double timeInSeconds =
        (locationData.time! - _previousLocationData!.time!) / 1000.0;
    _currentSpeed = distanceInMeters / timeInSeconds * 3.6; // 단위: km/hr

    setState(() {
      if (_currentSpeed >= 2.0) {
        runningDist = _distance;
        runningPace = _currentSpeed;
        runningKcal = calculateRunningKcal(_tokenInfo.memberWeight, runningDuration);
        // 위치 좌표 리스트에 추가
        _locationList.add({
          'coordinateTime': locationData.time!,
          'lat': locationData.latitude!,
          'lng': locationData.longitude!
        });
      } else {
        runningPace = 0.0;
      }

    });
    print(_locationList);
    _previousLocationData = locationData;
    saveRunningData();
  }

  void _updateRunningTime(Timer timer) {
    if (isPlaying) {
      setState(() {
        runningDuration += Duration(seconds: 1);
      });
    }
  }

  String formatDuration(Duration duration) {
    var hours = duration.inHours.toString().padLeft(2, '0');
    var minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    var seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> saveRunningData() async {
    runningPaceKm = runningDist * 1000 / runningDuration.inSeconds * 3.6;
    SharedPreferences runningResult = await SharedPreferences.getInstance();
    // 위치 좌표 리스트를 로컬에 저장
    await runningResult.setString('locationList', jsonEncode(_locationList));
    await runningResult.setDouble('runningPace', runningPace);
    await runningResult.setDouble('runningDist', runningPaceKm);
    await runningResult.setString(
        'runningDuration', runningDuration.toString());
    await runningResult.setDouble('runningKcal', runningKcal);
  }

  @override
  Widget build(BuildContext context) {
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: mediaHeight * 0.03, horizontal: mediaWidth * 0.06),
      width: mediaWidth * 0.85,
      height: mediaHeight * 0.24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(mediaWidth * 0.05),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 28,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '달린 시간',
                        style: TextStyle(
                            fontSize: mediaWidth * 0.04, color: Colors.black45),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaHeight * 0.005),
                  Row(
                    children: [
                      Text(
                        formatDuration(runningDuration),
                        style: TextStyle(
                          fontSize: mediaWidth * 0.08,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: mediaHeight * 0.008),
                ],
              ),
              isPlaying
                  ? ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: YGMG_ORANGE,
                        fixedSize: Size(mediaWidth * 0.1, mediaWidth * 0.1),
                        side: BorderSide(
                          width: 2,
                          color: YGMG_ORANGE,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(mediaWidth * 0.03),
                        ),
                      ),
                      child: Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: mediaWidth * 0.08,
                      ),
                    )
                  : Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _timer.cancel();
                            _locationSubscription.cancel();
                            gyroscopeEvents.drain();
                            if (runningPaceKm != 0 && runningDist != 0) {
                              DateTime runningEnd = DateTime.now();
                              saveRunningData();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DailyRunning(
                                        runningStart:
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(runningStart),
                                        runningEnd:
                                          DateFormat('yyyy-MM-dd HH:mm:ss')
                                            .format(runningEnd),
                                        runningPace: runningPaceKm,
                                        runningDist: runningDist,
                                        runningDuration:
                                          formatDuration(runningDuration),
                                        runningKcal: runningKcal,
                                      )),
                                (route) => route.settings.name == 'InRunning',
                              );
                            } else {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => RunningStart()),
                                (route) => route.settings.name == 'InRunning',
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            fixedSize: Size(mediaWidth * 0.1, mediaWidth * 0.1),
                            side: BorderSide(
                              width: 2,
                              color: YGMG_ORANGE,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(mediaWidth * 0.03),
                            ),
                          ),
                          child: Icon(
                            Icons.stop_rounded,
                            color: YGMG_ORANGE,
                            size: mediaWidth * 0.08,
                          ),
                        ),
                        SizedBox(
                          width: mediaWidth * 0.03,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: YGMG_ORANGE,
                            fixedSize: Size(mediaWidth * 0.1, mediaWidth * 0.1),
                            side: BorderSide(
                              width: 2,
                              color: YGMG_ORANGE,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(mediaWidth * 0.03),
                            ),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: mediaWidth * 0.08,
                          ),
                        ),
                      ],
                    )
            ],
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: mediaHeight * 0.015, horizontal: mediaWidth * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(mediaWidth * 0.02),
                color: Color(0xFFF3F7FF),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Container(
                        width: mediaWidth * 0.05,
                        alignment: Alignment.topCenter,
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child:
                                Image.asset('assets/images/runningimg.png'))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          runningDist.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: mediaWidth * 0.045,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'km',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: mediaWidth * 0.03, color: TEXT_GREY),
                        ),
                      ],
                    )
                  ]),
                  VerticalDivider(thickness: 1, color: TEXT_GREY),
                  Row(children: [
                    Container(
                        width: mediaWidth * 0.05,
                        alignment: Alignment.topCenter,
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: Image.asset('assets/images/fireimg.png'))),
                    // SizedBox(height: mediaHeight*0.0025),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          runningKcal.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: mediaWidth * 0.045,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'kcal',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: mediaWidth * 0.03, color: TEXT_GREY),
                        ),
                      ],
                    )
                  ]),
                  VerticalDivider(
                    thickness: 1,
                    color: TEXT_GREY,
                  ),
                  Row(children: [
                    Container(
                        width: mediaWidth * 0.05,
                        alignment: Alignment.topCenter,
                        child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: Image.asset(
                                'assets/images/lighteningimg.png'))),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          runningPace.toStringAsFixed(1),
                          style: TextStyle(
                              fontSize: mediaWidth * 0.045,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'km/hr',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: mediaWidth * 0.03, color: TEXT_GREY),
                        ),
                      ],
                    )
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
