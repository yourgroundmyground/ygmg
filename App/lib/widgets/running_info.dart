import 'dart:async';
import 'package:app/screens/running/daily_running.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';
import 'package:sensors/sensors.dart';

class RunningInfo extends StatefulWidget {
  const RunningInfo({Key? key}) : super(key: key);

  @override
  State<RunningInfo> createState() => _RunningInfoState();
}

class _RunningInfoState extends State<RunningInfo> {
  bool isStarted = true;
  bool isPlaying = true;
  // *달린 속도 변경
  double runningPace = 0.0;
  // *달린 거리 변경
  double runningDist = 0.0;
  // *달린 시간 변경
  Duration runningDuration = Duration.zero;
  // *태운 칼로리 변경
  double runningKcal = 0.0;


  late Timer _timer;
  int _seconds = 0;

  // 칼로리 계산
  double calculateRunningKcal(double weight, Duration duration) {
    double runningMinutes = duration.inMinutes.toDouble();
    double runningKcal;

    if (runningDist == 0) {
      return 0;
    }

    runningKcal = (47.6*3.5*runningMinutes*4 / 1000)*5;
    print(runningKcal);
    return runningKcal;
    // if (gender == 'M') {
    //   runningKcal = ((age * 0.2017) + ((weight * 0.09036) + ((220 - age) * 0.8 * 0.6309) - 55.0969) * runningMinutes / 4.184);
    //   return runningKcal;
    // } else {
    //   runningKcal = ((age * 0.074) + ((weight * 0.05741) + ((220 - age) * 0.8 * 0.4472) - 20.4022) * runningMinutes / 4.184);
    //   return runningKcal;
    // }
  }

  @override
  void initState() {
    super.initState();
    gyroscopeEvents.listen((GyroscopeEvent event) {
      double speed = (event.x.abs() + event.y.abs() + event.z.abs()) / 3;
      runningPace = (speed * 3.6) * 10;
      runningPace = (runningPace.round() / 10);
      // 속도가 0인 경우 isPlaying을 false로 바꾸어줍니다.
      if (runningPace == 0 && isStarted) {
        _seconds += 1;
        if (_seconds >= 30) {
          setState(() {
            isPlaying = false;
          });
        }
      } else {
        _seconds = 0;
      }
    });

    _timer = Timer.periodic(Duration(seconds: 1), _updateRunningInfo);
  }

  @override
  void dispose() {
    // gyroscopeEvents.drain();
    _timer.cancel();
    super.dispose();
  }

  void _updateRunningInfo(Timer timer) {
    if (isPlaying) {
      setState(() {
        runningDuration += Duration(seconds: 1);
        double distance = runningPace * runningDuration.inSeconds / 3600;
        // double distance = runningPace * runningDuration.inSeconds / 1000;
        runningDist += (distance.round() / 10);
        runningKcal = calculateRunningKcal(47.6, runningDuration);
      });
    }
  }

  String formatDuration(Duration duration) {
    var hours = duration.inHours.toString().padLeft(2, '0');
    var minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    var seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: mediaHeight*0.03, horizontal: mediaWidth*0.06),
          width: mediaWidth*0.85,
          height: mediaHeight*0.24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(mediaWidth*0.05),
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
                          Text('달린 시간',
                            style: TextStyle(
                                fontSize: mediaWidth*0.04,
                                color: Colors.black45
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaHeight*0.005),
                      Row(
                        children: [
                          Text(formatDuration(runningDuration),
                            style: TextStyle(
                              fontSize: mediaWidth*0.08,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: mediaHeight*0.008),
                    ],
                  ),
                  isPlaying ?
                   ElevatedButton(
                     onPressed: () {
                       setState(() {
                         isPlaying = !isPlaying;
                       });
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: YGMG_ORANGE,
                       fixedSize: Size(mediaWidth*0.1, mediaWidth*0.1),
                       side: BorderSide(
                         width: 2,
                         color: YGMG_ORANGE,
                       ),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(mediaWidth * 0.03),
                       ),
                     ),
                     child: Icon(
                       Icons.pause,
                       color: Colors.white,
                       size: mediaWidth * 0.08,
                     ),
                   )
                  :
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => DailyRunning()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: Size(mediaWidth*0.1, mediaWidth*0.1),
                          side: BorderSide(
                            width: 2,
                            color: YGMG_ORANGE,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mediaWidth * 0.03),
                          ),
                        ),
                        child: Icon(
                          Icons.stop_rounded,
                          color: YGMG_ORANGE,
                          size: mediaWidth * 0.08,
                        ),
                      ),
                      SizedBox(width: mediaWidth*0.03,),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: YGMG_ORANGE,
                          fixedSize: Size(mediaWidth*0.1, mediaWidth*0.1),
                          side: BorderSide(
                            width: 2,
                            color: YGMG_ORANGE,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(mediaWidth * 0.03),
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
                  padding: EdgeInsets.symmetric(vertical: mediaHeight*0.015, horizontal: mediaWidth*0.05),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mediaWidth*0.02),
                    color: Color(0xFFF3F7FF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                              width: mediaWidth*0.05,
                              alignment: Alignment.topCenter,
                              child:
                              Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.asset('assets/images/runningimg.png')
                              )
                          ),
                          // SizedBox(height: mediaHeight*0.0025),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(runningDist.toStringAsFixed(1), style: TextStyle(
                                  fontSize: mediaWidth*0.045,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text('km',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: mediaWidth*0.03,
                                    color: TEXT_GREY
                                ),),
                            ],
                          )
                        ]
                      ),
                      VerticalDivider(
                          thickness: 1,
                          color: TEXT_GREY
                      ),
                      Row(
                        children: [
                          Container(
                              width: mediaWidth*0.05,
                              alignment: Alignment.topCenter,
                              child:
                              Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.asset('assets/images/fireimg.png')
                              )
                          ),
                          // SizedBox(height: mediaHeight*0.0025),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(runningKcal.toStringAsFixed(1), style: TextStyle(
                                  fontSize: mediaWidth*0.045,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text('kcal',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: mediaWidth*0.03,
                                    color: TEXT_GREY
                                ),),
                            ],
                          )
                        ]
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: TEXT_GREY,
                      ),
                      Row(
                        children: [
                          Container(
                              width: mediaWidth*0.05,
                              alignment: Alignment.topCenter,
                              child:
                              Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Image.asset('assets/images/lighteningimg.png')
                              )
                          ),
                          // SizedBox(height: mediaHeight*0.0025),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('$runningPace', style: TextStyle(
                                  fontSize: mediaWidth*0.045,
                                  fontWeight: FontWeight.w700
                              ),),
                              Text('km/hr',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: mediaWidth*0.03,
                                    color: TEXT_GREY
                                ),),
                            ],
                          )
                        ]
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
