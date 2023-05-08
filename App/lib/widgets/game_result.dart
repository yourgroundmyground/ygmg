import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';

class GameResultInfo extends StatelessWidget {
  final String modalType;
  final String runningTime;
  final double runningDist;
  final double runningKcal;
  final double runningPace;

  const GameResultInfo({
    required this.modalType,
    required this.runningTime,
    required this.runningDist,
    required this.runningKcal,
    required this.runningPace,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return DailyInfo();   // *추후에 페이지별로 다르게 세팅해야 함
    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *달린 시간 변경
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
                children: [
                  Text(modalType == 'running' ? '달린 시간' : '내가 따먹은 땅 크기',
                    style: TextStyle(
                        fontSize: mediaWidth*0.04,
                        color: Colors.black45
                    ),
                  )
                ],
              ),
              SizedBox(height: mediaHeight*0.005),
              Row(
                children: [
                  // Text(modalType == 'running' ? runningTime : '$runningArea m²',     // *게임일 경우 면적으로 표시되게 하기
                  Text(runningTime,
                    style: TextStyle(
                      fontSize: mediaWidth*0.08,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: mediaHeight*0.008),
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
                      Container(
                        child: Row(
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
                      ),
                      VerticalDivider(
                          thickness: 1,
                          color: TEXT_GREY
                      ),
                      Container(
                        child: Row(
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
                      ),
                      VerticalDivider(
                        thickness: 1,
                        color: TEXT_GREY,
                      ),
                      Container(
                        child: Row(
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
                                  Text(runningPace.toStringAsFixed(1), style: TextStyle(
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

