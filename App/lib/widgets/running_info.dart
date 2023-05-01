import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';
import 'package:app/screens/running/daily_running.dart';

class RunningInfo extends StatefulWidget {
  const RunningInfo({Key? key}) : super(key: key);

  @override
  State<RunningInfo> createState() => _RunningInfoState();
}

class _RunningInfoState extends State<RunningInfo> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *달린 시간 변경
    const runningTime = '01:09:44';
    // *달린 거리 변경
    const runningDist = 10.9;
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
                          Text(runningTime,
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
                  isPlaying ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => DailyRunning()));
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
                    :
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
                              Text('$runningDist', style: TextStyle(
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
                              Text('$runningDist', style: TextStyle(
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
                              Text('$runningDist', style: TextStyle(
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
