import 'package:app/widgets/my_weekely_game_result.dart';
import 'package:app/screens/mypage/game_detail.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:app/const/colors.dart';
import 'package:tap_to_expand/tap_to_expand.dart';

class MyWeeklyGame extends StatelessWidget {
  const MyWeeklyGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WeeklyInfo(
    );   //
  }
}
//
class WeeklyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //미디어 사이즈
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    // *달린 시간 변경
    const runningTime = '01:09:44';
    // *달린 거리 변경
    const runningDist = 10.9;
    // * 주 표시
    const week = '이번 주';
    // * 날짜 표시
    const date = '4월 11일 - 4월 16일';
    // 면적
    const area = 124435;
    // 칼로리
    const calories = 142;
    // 닉네임
    const nickname = '펑펑';
    // 순위
    const rank = 11;
    // 백분위
    const percent = 7;

    return Stack(
      children: [
        Center(
          child: TapToExpand(
            content: Stack(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: mediaHeight*0.03, horizontal: mediaWidth*0.03),
                  width: mediaWidth*0.85,
                  height: mediaHeight*0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(mediaWidth*0.05),
                    color: Colors.white,
                  ),
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Text('${nickname}님의 최종 순위',
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
                                  Text('${rank}위',
                                    style: TextStyle(
                                      fontSize: mediaWidth*0.08,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                                  Text('상위 ${percent}%',
                                    style: TextStyle(
                                        fontSize: mediaWidth*0.05,
                                        color: Colors.black
                                    ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: mediaHeight*0.02),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: mediaHeight*0.015, horizontal: mediaWidth*0.05),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mediaWidth*0.02),
                            color: Color(0xFFF3F7FF),
                          ),
                          child: Column(
                              children: [
                                Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('내 땅 크기',
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
                                            Text('${area}m^',
                                              style: TextStyle(
                                                fontSize: mediaWidth*0.08,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => GameDetail()),
                                            );
                                          },
                                          child: Container(
                                            width: mediaWidth*0.08,
                                            child: Image.asset('assets/images/right-arrow.png'),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              ]
                          ),
                        ),
                      ),
                      SizedBox(height: mediaHeight*0.008),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: mediaHeight*0.015, horizontal: mediaWidth*0.05),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(mediaWidth*0.02),
                            color: Color(0xFFF3F7FF),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('누적 달리기 시간',
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
                                      Text('${runningTime}',
                                        style: TextStyle(
                                          fontSize: mediaWidth*0.08,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: mediaHeight*0.01),
                              Row(
                                children: [
                                  Text('평균 달리기 기록',
                                    style: TextStyle(
                                        fontSize: mediaWidth*0.04,
                                        color: Colors.black45
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: mediaHeight*0.01),
                              Row(
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
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],

            ),
            title: Row(
              children:[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: mediaWidth*0.03),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/runningimg.png'),
                    radius: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: mediaWidth*0.03),
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
                                  fontSize: mediaWidth*0.035,
                                  color: TEXT_GREY
                              ),
                            ),
                          ],
                        )
                      ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: mediaWidth*0.015),
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
            onTapPadding: 10,
            closedHeight: mediaHeight*0.12,
            scrollable: true,
            borderRadius: 40,
            openedHeight: mediaHeight*0.5,
                    ),
          ),
      ]
    );
  }
  const WeeklyInfo({Key? key}) : super(key: key);
}
