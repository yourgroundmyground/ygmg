import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';

class MyWeeklyGame extends StatelessWidget {
  const MyWeeklyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeeklyInfo();   //
  }
}

class WeeklyInfo extends StatelessWidget {
  const WeeklyInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // 미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // * 주 표시
    const week = '이번 주';
    // * 주 표시
    const date = '4월 11일 - 4월 16일';
    // 면적
    const area = 124435;
    // 칼로리
    const calories = 142;

    return Stack(

      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: mediaHeight*0.03, horizontal: mediaWidth*0.06),
          width: mediaWidth*0.85,
          height: mediaHeight*0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(mediaWidth*0.1),
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
              Expanded(
                child: SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/runningimg.png'),
                          radius: 20,
                        ),
                      ),
                      Container(
                        child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('$week 땅따먹기', style: TextStyle(
                                      fontSize: mediaWidth*0.045,
                                      fontWeight: FontWeight.w700
                                  ),),
                                  Text('$date',
                                    style: TextStyle(
                                        fontSize: mediaWidth*0.03,
                                        color: TEXT_GREY
                                    ),),
                                ],
                              )
                            ]
                        ),
                      ),
                      Container(
                        child: Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('$area m^', style: TextStyle(
                                      fontSize: mediaWidth*0.045,
                                      fontWeight: FontWeight.w700
                                  ),),
                                  Text('$calories kcal',
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
